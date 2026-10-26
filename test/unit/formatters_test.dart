import 'package:flutter_test/flutter_test.dart';
import 'package:digital_balance/core/utils/formatters.dart';

void main() {
  group('Formatters Unit Tests', () {
    test(
      'formatDurationMinutes formats 0, minutes only, hours only, and mixed',
      () {
        expect(Formatters.formatDurationMinutes(0), equals('0m'));
        expect(Formatters.formatDurationMinutes(-5), equals('0m'));
        expect(Formatters.formatDurationMinutes(45), equals('45m'));
        expect(Formatters.formatDurationMinutes(60), equals('1h'));
        expect(Formatters.formatDurationMinutes(120), equals('2h'));
        expect(Formatters.formatDurationMinutes(155), equals('2h 35m'));
      },
    );

    test(
      'formatDurationMs converts milliseconds to duration string accurately',
      () {
        expect(Formatters.formatDurationMs(60000), equals('1m'));
        expect(Formatters.formatDurationMs(3600000), equals('1h'));
        expect(
          Formatters.formatDurationMs(7200000 + 1800000),
          equals('2h 30m'),
        );
      },
    );

    test(
      'formatMinuteOfDay converts minute integers to formatted 12h/24h time',
      () {
        expect(Formatters.formatMinuteOfDay(0), equals('12:00 AM'));
        expect(Formatters.formatMinuteOfDay(540), equals('9:00 AM'));
        expect(Formatters.formatMinuteOfDay(720), equals('12:00 PM'));
        expect(Formatters.formatMinuteOfDay(1320), equals('10:00 PM'));
        expect(
          Formatters.formatMinuteOfDay(1320, is24Hour: true),
          equals('22:00'),
        );
        expect(Formatters.formatMinuteOfDay(-1), equals('--:--'));
        expect(Formatters.formatMinuteOfDay(1440), equals('--:--'));
      },
    );

    test('formatDate and formatFullDate format correctly', () {
      final date = DateTime(2026, 10, 12);
      expect(Formatters.formatFullDate(date), equals('2026-10-12'));
    });
  });
}
