part of '../../common.dart';

class Period {
  @override
  String toString() => '$period';

  final int _period;

  Period get period => this;

  const Period._microseconds(int period) : _period = period + 0;

  Period operator +(Period other) {
    return Period._microseconds(_period + other._period);
  }

  Period operator -(Period other) {
    return Period._microseconds(_period - other._period);
  }

  Period operator *(num factor) {
    return Period._microseconds((_period * factor).round());
  }

  Period operator -() => Period._microseconds(-_period);

  Period abs() => Period._microseconds(_period.abs());

  bool operator <(Period other) => _period < other._period;

  bool operator >(Period other) => _period > other._period;

  bool operator <=(Period other) => _period <= other._period;

  bool operator >=(Period other) => _period >= other._period;

  @override
  bool operator ==(Object other) {
    if (other is! Period) return false;
    return _period == other._period;
  }

  @override
  int get hashCode => _period.hashCode;

  const Period({
    int years = 0,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) : this._microseconds(
    microseconds +
        years * microsecondsPerMillisecond * milliseconds +
        microsecondsPerSecond * seconds +
        microsecondsPerMinute * minutes +
        microsecondsPerHour * hours +
        microsecondsPerDay * days,
  );

  static const int microsecondsPerMillisecond = 1000;

  static const int millisecondsPerSecond = 1000;

  static const int secondsPerMinute = 60;

  static const int minutesPerHour = 60;

  static const int hoursPerDay = 24;

  static const int microsecondsPerSecond =
      microsecondsPerMillisecond * millisecondsPerSecond;

  static const int microsecondsPerMinute =
      microsecondsPerSecond * secondsPerMinute;

  static const int microsecondsPerHour = microsecondsPerMinute * minutesPerHour;

  static const int microsecondsPerDay = microsecondsPerHour * hoursPerDay;

  static const int millisecondsPerMinute =
      millisecondsPerSecond * secondsPerMinute;

  static const int millisecondsPerHour = millisecondsPerMinute * minutesPerHour;

  static const int millisecondsPerDay = millisecondsPerHour * hoursPerDay;

  static const int secondsPerHour = secondsPerMinute * minutesPerHour;

  static const int secondsPerDay = secondsPerHour * hoursPerDay;

  static const int minutesPerDay = minutesPerHour * hoursPerDay;

  bool get isNegative => _period < 0;

  Moment get moment {
    int totalMicroseconds = _period;
    int totalMilliseconds = totalMicroseconds ~/ microsecondsPerMillisecond;
    int totalSeconds = totalMilliseconds ~/ millisecondsPerSecond;
    int totalMinutes = totalSeconds ~/ secondsPerMinute;
    int totalHours = totalMinutes ~/ minutesPerHour;
    int totalDays = totalHours ~/ hoursPerDay;

    int sec = totalSeconds % secondsPerMinute;
    int min = totalMinutes % minutesPerHour;
    int hr = totalHours % hoursPerDay;

    int yr = 1970 + (totalDays ~/ 365);
    int remainingDays = totalDays % 365;
    int mnth = 1 + (remainingDays ~/ 30);
    int day = 1 + (remainingDays % 30);

    return Moment(
      year: yr,
      month: mnth,
      date: day,
      hour: hr,
      minute: min,
      second: sec,
    );
  }
}
