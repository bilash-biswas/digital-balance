import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../constants/app_constants.dart';
import '../logging/app_logger.dart';
import '../platform/platform_bridge.dart';

class UpdateInfo {
  final String latestVersion;
  final String changelog;
  final String downloadUrl;
  final String publishedAt;
  final int apkSizeBytes;

  const UpdateInfo({
    required this.latestVersion,
    required this.changelog,
    required this.downloadUrl,
    required this.publishedAt,
    required this.apkSizeBytes,
  });
}

class AppUpdateService {
  final PlatformBridge _bridge;

  static const String githubReleasesApiUrl =
      'https://api.github.com/repos/bilash-biswas/digital-balance/releases/latest';

  AppUpdateService([PlatformBridge? bridge])
      : _bridge = bridge ?? PlatformBridge();

  /// Compares semantic versions (e.g. "1.0.1" vs "1.0.0")
  static bool isNewerVersion(String remoteVer, String currentVer) {
    try {
      final cleanRemote =
          remoteVer.trim().replaceAll(RegExp(r'^[vV]'), '').split('+').first;
      final cleanCurrent =
          currentVer.trim().replaceAll(RegExp(r'^[vV]'), '').split('+').first;

      final rParts = cleanRemote
          .split('.')
          .map((e) => int.tryParse(e) ?? 0)
          .toList();
      final cParts = cleanCurrent
          .split('.')
          .map((e) => int.tryParse(e) ?? 0)
          .toList();

      for (var i = 0; i < 3; i++) {
        final r = i < rParts.length ? rParts[i] : 0;
        final c = i < cParts.length ? cParts[i] : 0;
        if (r > c) return true;
        if (r < c) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Check GitHub Releases API for a newer release tag
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);
      final request = await client.getUrl(Uri.parse(githubReleasesApiUrl));
      request.headers.set('User-Agent', 'DigitalBalance-AppUpdate');
      request.headers.set('Accept', 'application/vnd.github.v3+json');

      final response = await request.close();
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final rawTag = data['tag_name'] as String? ?? '';
        final cleanTag = rawTag.replaceAll(RegExp(r'^[vV]'), '');
        final changelog =
            data['body'] as String? ?? 'Bug fixes and performance improvements.';
        final publishedAt = data['published_at'] as String? ?? '';

        final assets = data['assets'] as List<dynamic>? ?? [];
        String? downloadUrl;
        int apkSize = 0;

        for (final item in assets) {
          final m = item as Map<String, dynamic>;
          final name = m['name'] as String? ?? '';
          if (name.endsWith('.apk')) {
            downloadUrl = m['browser_download_url'] as String?;
            apkSize = (m['size'] as num?)?.toInt() ?? 0;
            break;
          }
        }

        if (downloadUrl != null &&
            isNewerVersion(cleanTag, AppConstants.appVersion)) {
          return UpdateInfo(
            latestVersion: cleanTag,
            changelog: changelog,
            downloadUrl: downloadUrl,
            publishedAt: publishedAt,
            apkSizeBytes: apkSize,
          );
        }
      }
    } catch (e) {
      AppLogger.warning('Failed to check for updates: $e');
    }
    return null;
  }

  /// Downloads the release APK into local temp cache with progress reporting
  Future<File> downloadApk(
    String downloadUrl,
    void Function(double progress) onProgress,
  ) async {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(downloadUrl));
    final response = await request.close();

    final totalBytes = response.contentLength;
    var receivedBytes = 0;

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/digital_balance_update.apk');
    if (await file.exists()) {
      await file.delete();
    }

    final sink = file.openWrite();
    await for (final chunk in response) {
      sink.add(chunk);
      receivedBytes += chunk.length;
      if (totalBytes > 0) {
        onProgress((receivedBytes / totalBytes).clamp(0.0, 1.0));
      }
    }
    await sink.flush();
    await sink.close();

    return file;
  }

  /// Triggers Android package installer
  Future<bool> installApk(String filePath) async {
    return _bridge.installApk(filePath);
  }

  Future<bool> canRequestPackageInstalls() async {
    return _bridge.canRequestPackageInstalls();
  }

  Future<bool> openManageUnknownAppSources() async {
    return _bridge.openManageUnknownAppSources();
  }
}
