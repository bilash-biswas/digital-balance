import 'package:flutter_test/flutter_test.dart';

bool isMinuteInSchedule({
  required int currentMinuteOfDay,
  required int startMinuteOfDay,
  required int endMinuteOfDay,
}) {
  if (startMinuteOfDay < 0 || endMinuteOfDay < 0) return false;
  if (startMinuteOfDay < endMinuteOfDay) {
    // Daytime schedule (e.g., 09:00 = 540 to 17:00 = 1020)
    return currentMinuteOfDay >= startMinuteOfDay &&
        currentMinuteOfDay < endMinuteOfDay;
  } else {
    // Overnight schedule (e.g., 22:00 = 1320 to 07:00 = 420)
    return currentMinuteOfDay >= startMinuteOfDay ||
        currentMinuteOfDay < endMinuteOfDay;
  }
}

void main() {
  group('Restriction Schedule Evaluation Tests', () {
    test('Daytime schedule evaluates correctly within and outside window', () {
      const start = 540; // 09:00
      const end = 1020; // 17:00

      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 539,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isFalse,
      );
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 540,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isTrue,
      );
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 720,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isTrue,
      );
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 1019,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isTrue,
      );
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 1020,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isFalse,
      );
    });

    test('Overnight schedule correctly evaluates across midnight', () {
      const start = 1320; // 22:00
      const end = 420; // 07:00

      // Before start in the evening -> Not in schedule
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 1319,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isFalse,
      );
      // At start (22:00) -> In schedule
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 1320,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isTrue,
      );
      // Late night (23:30) -> In schedule
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 1410,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isTrue,
      );
      // Midnight (00:00) -> In schedule
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 0,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isTrue,
      );
      // Early morning (03:00) -> In schedule
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 180,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isTrue,
      );
      // Just before end (06:59) -> In schedule
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 419,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isTrue,
      );
      // At end (07:00) -> Not in schedule
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 420,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isFalse,
      );
      // Afternoon (14:00) -> Not in schedule
      expect(
        isMinuteInSchedule(
          currentMinuteOfDay: 840,
          startMinuteOfDay: start,
          endMinuteOfDay: end,
        ),
        isFalse,
      );
    });
  });
}
