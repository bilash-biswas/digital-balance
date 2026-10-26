import 'package:digital_balance/core/updates/app_update_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUpdateService Semantic Version Comparison Tests', () {
    test('Detects newer patch version', () {
      expect(AppUpdateService.isNewerVersion('1.0.1', '1.0.0'), isTrue);
      expect(AppUpdateService.isNewerVersion('v1.0.1', '1.0.0'), isTrue);
    });

    test('Detects newer minor and major versions', () {
      expect(AppUpdateService.isNewerVersion('1.1.0', '1.0.9'), isTrue);
      expect(AppUpdateService.isNewerVersion('2.0.0', '1.99.99'), isTrue);
      expect(AppUpdateService.isNewerVersion('v2.0.0', '1.0.0'), isTrue);
    });

    test('Identifies equal or older versions correctly', () {
      expect(AppUpdateService.isNewerVersion('1.0.0', '1.0.0'), isFalse);
      expect(AppUpdateService.isNewerVersion('v1.0.0', '1.0.0'), isFalse);
      expect(AppUpdateService.isNewerVersion('0.9.9', '1.0.0'), isFalse);
      expect(AppUpdateService.isNewerVersion('1.0.0', '1.0.1'), isFalse);
    });

    test('Handles build metadata and malformed prefixes gracefully', () {
      expect(AppUpdateService.isNewerVersion('1.0.1+5', '1.0.0+1'), isTrue);
      expect(AppUpdateService.isNewerVersion('V1.0.2', '1.0.1'), isTrue);
      expect(AppUpdateService.isNewerVersion('invalid', '1.0.0'), isFalse);
    });
  });
}
