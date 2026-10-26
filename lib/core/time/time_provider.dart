abstract class TimeProvider {
  DateTime now();
  DateTime todayMidnight();
  int currentUtcTimestampMs();
}

class SystemTimeProvider implements TimeProvider {
  const SystemTimeProvider();

  @override
  DateTime now() => DateTime.now();

  @override
  DateTime todayMidnight() {
    final current = DateTime.now();
    return DateTime(current.year, current.month, current.day);
  }

  @override
  int currentUtcTimestampMs() => DateTime.now().toUtc().millisecondsSinceEpoch;
}

class FixedTimeProvider implements TimeProvider {
  DateTime fixedNow;

  FixedTimeProvider(this.fixedNow);

  @override
  DateTime now() => fixedNow;

  @override
  DateTime todayMidnight() =>
      DateTime(fixedNow.year, fixedNow.month, fixedNow.day);

  @override
  int currentUtcTimestampMs() => fixedNow.toUtc().millisecondsSinceEpoch;
}
