import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/permissions/permission_service.dart';

const int _maxIconCacheSize = 150;
final Map<String, Uint8List?> _iconMemoryCache = {};

void _cacheIcon(String pkg, Uint8List? bytes) {
  if (_iconMemoryCache.length >= _maxIconCacheSize) {
    _iconMemoryCache.remove(_iconMemoryCache.keys.first);
  }
  _iconMemoryCache[pkg] = bytes;
}

class AppIconWidget extends ConsumerStatefulWidget {
  final String packageName;
  final String appName;
  final double size;
  final double borderRadius;

  const AppIconWidget({
    super.key,
    required this.packageName,
    required this.appName,
    this.size = 42.0,
    this.borderRadius = 12.0,
  });

  @override
  ConsumerState<AppIconWidget> createState() => _AppIconWidgetState();
}

class _AppIconWidgetState extends ConsumerState<AppIconWidget> {
  Uint8List? _iconBytes;

  @override
  void initState() {
    super.initState();
    _loadIcon();
  }

  @override
  void didUpdateWidget(covariant AppIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.packageName != widget.packageName) {
      _loadIcon();
    }
  }

  Future<void> _loadIcon() async {
    if (widget.packageName.isEmpty) return;

    if (_iconMemoryCache.containsKey(widget.packageName)) {
      final cached = _iconMemoryCache.remove(widget.packageName);
      _iconMemoryCache[widget.packageName] = cached;
      if (mounted) {
        setState(() {
          _iconBytes = cached;
        });
      }
      return;
    }

    try {
      final bridge = ref.read(platformBridgeProvider);
      final Uint8List? bytes = await bridge.getAppIcon(widget.packageName);
      _cacheIcon(widget.packageName, bytes);
      if (mounted) {
        setState(() {
          _iconBytes = bytes;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_iconBytes != null && _iconBytes!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Image.memory(
          _iconBytes!,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(theme),
        ),
      );
    }

    return _buildFallback(theme);
  }

  Widget _buildFallback(ThemeData theme) {
    final initial = widget.appName.trim().isNotEmpty
        ? widget.appName.trim().substring(0, 1).toUpperCase()
        : '?';

    // Deterministic pastel color based on package name hash
    final hash = widget.packageName.hashCode.abs();
    final hue = (hash % 360).toDouble();
    final pastelColor = HSLColor.fromAHSL(1.0, hue, 0.45, 0.85).toColor();
    final textColor = HSLColor.fromAHSL(1.0, hue, 0.70, 0.25).toColor();

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: pastelColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: widget.size * 0.45,
        ),
      ),
    );
  }
}
