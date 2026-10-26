import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/updates/app_update_service.dart';

class UpdateAvailableDialog extends StatefulWidget {
  final UpdateInfo updateInfo;
  final AppUpdateService updateService;

  const UpdateAvailableDialog({
    super.key,
    required this.updateInfo,
    required this.updateService,
  });

  static Future<void> show(
    BuildContext context, {
    required UpdateInfo updateInfo,
    required AppUpdateService updateService,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateAvailableDialog(
        updateInfo: updateInfo,
        updateService: updateService,
      ),
    );
  }

  @override
  State<UpdateAvailableDialog> createState() => _UpdateAvailableDialogState();
}

class _UpdateAvailableDialogState extends State<UpdateAvailableDialog> {
  bool _isDownloading = false;
  double _progress = 0.0;
  String _statusText = '';
  String? _errorMessage;
  String? _cachedDownloadedPath;

  Future<void> _startDownloadAndInstall() async {
    // If already downloaded, check permission and launch installer immediately
    if (_cachedDownloadedPath != null) {
      final canInstall = await widget.updateService.canRequestPackageInstalls();
      if (!canInstall) {
        setState(() {
          _errorMessage =
              'Please enable "Allow from this source" in Settings, then tap Install Now.';
        });
        await widget.updateService.openManageUnknownAppSources();
        return;
      }

      final launched = await widget.updateService.installApk(_cachedDownloadedPath!);
      if (launched && mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    setState(() {
      _isDownloading = true;
      _progress = 0.0;
      _statusText = 'Connecting to download server...';
      _errorMessage = null;
    });

    try {
      final file = await widget.updateService.downloadApk(
        widget.updateInfo.downloadUrl,
        (p) {
          if (mounted) {
            setState(() {
              _progress = p;
              _statusText = 'Downloading: ${(p * 100).toStringAsFixed(0)}%';
            });
          }
        },
      );

      if (!mounted) return;

      _cachedDownloadedPath = file.path;

      // Check if permission to install unknown apps is granted
      final canInstall =
          await widget.updateService.canRequestPackageInstalls();
      if (!canInstall) {
        if (!mounted) return;
        setState(() {
          _isDownloading = false;
          _statusText = 'Permission needed: Allow from this source';
          _errorMessage =
              'Please turn ON "Allow from this source" in Android Settings, then tap "Install Now".';
        });
        await widget.updateService.openManageUnknownAppSources();
        return;
      }

      setState(() {
        _statusText = 'Opening Android package installer...';
      });

      final launched = await widget.updateService.installApk(file.path);
      if (!launched) {
        setState(() {
          _errorMessage =
              'Could not launch installer. Please check app permissions.';
          _isDownloading = false;
        });
      } else {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Download failed: $e';
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sizeMb = (widget.updateInfo.apkSizeBytes / (1024 * 1024)).toStringAsFixed(1);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.system_update_alt_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Update Available',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Chip(
                  label: Text('v${widget.updateInfo.latestVersion}'),
                  backgroundColor: theme.colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(Current: v${widget.updateInfo.currentVersion})',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (widget.updateInfo.apkSizeBytes > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Download size: ~$sizeMb MB',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Text(
              "What's New:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Container(
              constraints: const BoxConstraints(maxHeight: 160),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  widget.updateInfo.changelog,
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
              ),
            ),
            if (_isDownloading) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progress > 0 ? _progress : null,
                minHeight: 6,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 6),
              Text(
                _statusText,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (!_isDownloading)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later'),
          ),
        FilledButton.icon(
          icon: Icon(
            _cachedDownloadedPath != null
                ? Icons.system_update_alt_rounded
                : Icons.download_rounded,
            size: 18,
          ),
          label: Text(
            _isDownloading
                ? 'Downloading...'
                : (_cachedDownloadedPath != null
                    ? 'Install Now'
                    : 'Download & Install'),
          ),
          onPressed: _isDownloading ? null : _startDownloadAndInstall,
        ),
      ],
    );
  }
}
