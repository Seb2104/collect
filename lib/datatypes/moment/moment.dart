part of '../../collect.dart';

final class Moment implements Comparable<Moment> {
  int? second;
  int? minute;
  int? hour;
  int? date;
  int? month;
  int? year;
  List<String>? formatStyle = defaultFormatStyle;

  Moment({
    this.second,
    this.minute,
    this.hour,
    this.date,
    this.month,
    this.year,
    this.formatStyle,
  });

  Moment.fromDateTime(DateTime dateTime)
    : year = dateTime.year,
      second = dateTime.second,
      minute = dateTime.minute,
      hour = dateTime.hour,
      date = dateTime.day,
      month = dateTime.month,
      formatStyle = defaultFormatStyle;

  static Moment parse({required String string}) {
    var split1 = string.split('-');
    var dates = split1[0].split('/');
    var times = split1[1].split(':');
    return Moment(
      year: int.parse(dates[0]),
      month: int.parse(dates[1]),
      date: int.parse(dates[2]),
      hour: int.parse(times[0]),
      minute: int.parse(times[1]),
      second: int.parse(times[2]),
    );
  }

  static Moment? tryParse(String? string, {dynamic onException}) {
    try {
      if (string == null) {
        throw Exception('value is null');
      }
      return Moment.parse(string: string);
    } catch (e) {
      return onException(e);
    }
  }

  static Moment now() {
    return Moment.fromDateTime(DateTime.now());
  }

  DateTime get dateTime => DateTime(
    year ?? DateTime.now().year,
    month ?? 1,
    date ?? 1,
    hour ?? 0,
    minute ?? 0,
    second ?? 0,
  );

  Moment operator +(Period period) {
    DateTime dt = dateTime.add(Duration(microseconds: period._period));
    return Moment.fromDateTime(dt);
  }

  Moment operator -(Period period) {
    DateTime dt = dateTime.subtract(Duration(microseconds: period._period));
    return Moment.fromDateTime(dt);
  }

  Moment addPeriod(Period period) => this + period;

  bool operator <(Moment other) => totalSeconds < other.totalSeconds;

  bool operator <=(Moment other) => totalSeconds <= other.totalSeconds;

  bool operator >(Moment other) => totalSeconds > other.totalSeconds;

  bool operator >=(Moment other) => totalSeconds >= other.totalSeconds;

  List toList() => [second, minute, hour, date, month, year];

  Moment fromMap(Map<String, dynamic> map) {
    return Moment(
      second: map[second],
      minute: map[minute],
      hour: map[hour],
      date: map[date],
      month: map[month],
      year: map[year],
      formatStyle: const [
        the,
        space,
        Do,
        space,
        of,
        space,
        mmmm,
        space,
        yyyy,
        space,
        at,
        space,
        hh,
        colon,
        mm,
        colon,
        ss,
      ],
    );
  }

  Map<String, dynamic> get asMap => {
    second.toString(): second ?? 0.0,
    minute.toString(): minute ?? 0.0,
    hour.toString(): hour ?? 0.0,
    date.toString(): date ?? 0.0,
    month.toString(): month ?? 0.0,
    year.toString(): year ?? 0.0,
  };

  Period get period => Period(
    seconds: second ?? 0,
    minutes: minute ?? 0,
    hours: hour ?? 0,
    days: date ?? 0,
    months: month ?? 0,
    years: year ?? 0,
  );

  int get totalSeconds {
    int y = year ?? 1970;
    int m = month ?? 1;
    int d = date ?? 1;
    int h = hour ?? 0;
    int min = minute ?? 0;
    int s = second ?? 0;

    int totalDays = 0;

    for (int yr = 1970; yr < y; yr++) {
      totalDays += _isLeapYear(yr) ? 366 : 365;
    }

    for (int yr = y; yr < 1970; yr++) {
      totalDays -= _isLeapYear(yr) ? 366 : 365;
    }

    for (int mn = 1; mn < m; mn++) {
      totalDays += _daysInMonth(mn, y);
    }

    totalDays += d - 1;

    int totalSeconds = totalDays * 86400 + h * 3600 + min * 60 + s;

    return totalSeconds;
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  int _daysInMonth(int month, int year) {
    const monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && _isLeapYear(year)) return 29;
    return monthDays[month - 1];
  }

  Period difference(Moment other) {
    int totalSecs = totalSeconds - other.totalSeconds;
    totalSecs = totalSecs.abs();

    int secs = totalSecs % 60;
    int totalMins = totalSecs ~/ 60;
    int mins = totalMins % 60;
    int totalHrs = totalMins ~/ 60;
    int hrs = totalHrs % 24;
    int days = totalHrs ~/ 24;

    int yrs = days ~/ 365;
    int remainingDays = days % 365;
    int months = remainingDays ~/ 30;
    remainingDays = remainingDays % 30;

    return Period(
      years: yrs,
      months: months,
      days: remainingDays,
      hours: hrs,
      minutes: mins,
      seconds: secs,
    );
  }

  String timeAgo({Moment? from, bool short = false}) {
    Moment reference = from ?? Moment.now();
    int totalSecs = reference.totalSeconds - totalSeconds;
    bool isFuture = totalSecs < 0;
    totalSecs = totalSecs.abs();

    int secs = totalSecs % 60;
    int totalMins = totalSecs ~/ 60;
    int mins = totalMins % 60;
    int totalHrs = totalMins ~/ 60;
    int hrs = totalHrs % 24;
    int days = totalHrs ~/ 24;

    int yrs = days ~/ 365;
    int remainingDays = days % 365;
    int months = remainingDays ~/ 30;
    remainingDays = remainingDays % 30;

    List<String> parts = [];

    if (yrs > 0) {
      String unit = short ? 'y' : (yrs == 1 ? ' year' : ' years');
      parts.add('$yrs$unit');
    }
    if (months > 0) {
      String unit = short ? 'mo' : (months == 1 ? ' month' : ' months');
      parts.add('$months$unit');
    }
    if (remainingDays > 0) {
      String unit = short ? 'd' : (remainingDays == 1 ? ' day' : ' days');
      parts.add('$remainingDays$unit');
    }
    if (hrs > 0) {
      String unit = short ? 'h' : (hrs == 1 ? ' hour' : ' hours');
      parts.add('$hrs$unit');
    }
    if (mins > 0) {
      String unit = short ? 'm' : (mins == 1 ? ' minute' : ' minutes');
      parts.add('$mins$unit');
    }
    if (secs > 0 || parts.isEmpty) {
      String unit = short ? 's' : (secs == 1 ? ' second' : ' seconds');
      parts.add('$secs$unit');
    }

    String result = parts.join(short ? ' ' : ', ');

    if (isFuture) {
      return 'in $result';
    } else {
      return short ? result : '$result ago';
    }
  }

  int? get weekday {
    if (date == null || month == null || year == null) return null;
    int y = year!;
    int m = month!;
    int d = date!;

    if (m < 3) {
      m += 12;
      y -= 1;
    }

    int yearOfCentury = y % 100;
    int zeroBasedCentury = y ~/ 100;

    int h =
        (d +
            (13 * (m + 1) ~/ 5) +
            yearOfCentury +
            (yearOfCentury ~/ 4) +
            (zeroBasedCentury ~/ 4) -
            (2 * zeroBasedCentury) +
            700) %
        7;

    return ((h + 5) % 7) + 1;
  }

  String get time {
    String h = (hour ?? 0).toString().padLeft(2, '0');
    String m = (minute ?? 0).toString().padLeft(2, '0');
    String s = (second ?? 0).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String get shortTime {
    String h = (hour ?? 0).toString().padLeft(2, '0');
    String m = (minute ?? 0).toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get clock {
    int h = hour ?? 0;
    int hour12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    String m = (minute ?? 0).toString().padLeft(2, '0');
    String s = (second ?? 0).toString().padLeft(2, '0');
    return '$hour12:$m:$s $clockPhase';
  }

  String get shortClock {
    int h = hour ?? 0;
    int hour12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    String m = (minute ?? 0).toString().padLeft(2, '0');
    return '$hour12:$m $clockPhase';
  }

  String get clockPhase => (hour ?? 0) < 12 ? 'AM' : 'PM';

  String? get era => year! >= 1
      ? 'AD'
      : year! <= -1
      ? 'BC'
      : null;

  static Moment tomorrow() => ((Moment.now()) + Period(days: 1));

  static Moment yesterday() => ((Moment.now()) - Period(days: 1));

  String _getOrdinal(int? value) {
    String valString = value.toString();
    if (valString.length >= 2) {
      int trailingTwo = int.parse(
        value.toString().substring(valString.length - 2, valString.length),
      );
      if (trailingTwo == 11 || trailingTwo == 12 || trailingTwo == 13) {
        return 'th';
      }
    }
    int trailing = int.parse(value.toString()[value.toString().length - 1]);
    switch (trailing) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String format([List<String>? formatStyle]) {
    String val = '';
    for (int i = 0; i < formatStyle!.length; i++) {
      val += formatToken(this, formatStyle[i]).toString();
    }
    return val;
  }

  String? formatToken(Moment moment, String token) {
    switch (token) {
      case ddd:
        return weekDayNames[moment.weekday]!.substring(0, 3);
      case dddd:
        return weekDayNames[moment.weekday];
      case D:
        return moment.date.toString();
      case Do:
        return '${moment.date}${_getOrdinal(moment.date!)}';
      case DD:
        return moment.date.toString().padLeft(2, '0');
      case M:
        return moment.month.toString();
      case Mo:
        return '${moment.month}${_getOrdinal(moment.month)}';
      case MM:
        return moment.month.toString().padLeft(2, '0');
      case MMM:
        return monthNames[moment.month]!.substring(0, 3);
      case mmmm:
        return monthNames[moment.month];
      case yy:
        return moment.year.toString().substring(2);
      case yyyy:
        return moment.year.toString();
      case h:
        int hour12 = moment.hour! % 12;
        return hour12 == 0 ? '12' : hour12.toString();
      case hh:
        int hour12 = moment.hour! % 12;
        return (hour12 == 0 ? 12 : hour12).toString().padLeft(2, '0');
      case H:
        return moment.hour.toString();
      case HH:
        return moment.hour.toString().padLeft(2, '0');
      case m:
        return moment.minute.toString();
      case mm:
        return moment.minute.toString().padLeft(2, '0');
      case s:
        return moment.second.toString();
      case ss:
        return moment.second.toString().padLeft(2, '0');
      case A:
        return moment.clockPhase;
      case a:
        return moment.clockPhase.toLowerCase();
      case t:
        return '${moment.hour}:${moment.minute}:${moment.second}';
      case dateNumeric:
        return '${moment.date.toString().padLeft(2, '0')}/${moment.month.toString().padLeft(2, '0')}/$year';
      default:
        return token;
    }
  }

  int get millisecondsSinceEpoch {
    int y = year ?? 1970;
    int m = month ?? 1;
    int d = date ?? 1;

    int leapYears = 0;
    for (int i = 1970; i < y; i++) {
      if ((i % 4 == 0 && i % 100 != 0) || (i % 400 == 0)) {
        leapYears++;
      }
    }

    List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    bool isLeap = (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
    if (isLeap) daysInMonth[1] = 29;

    int totalDays = (y - 1970) * 365 + leapYears;

    for (int i = 0; i < m - 1; i++) {
      totalDays += daysInMonth[i];
    }

    totalDays += d - 1;

    int totalSeconds = totalDays * 86400;
    totalSeconds += (hour ?? 0) * 3600;
    totalSeconds += (minute ?? 0) * 60;
    totalSeconds += (second ?? 0);

    return totalSeconds * 1000;
  }

  @override
  int compareTo(Moment other) {
    if (totalSeconds < other.totalSeconds) return -1;
    if (totalSeconds > other.totalSeconds) return 1;
    return 0;
  }

  @override
  int get hashCode => millisecondsSinceEpoch;

  @override
  bool operator ==(Object other) {
    if (other is! Moment) return false;
    return totalSeconds == other.totalSeconds;
  }

  @override
  Type get runtimeType => Moment;

  @override
  String toString() => '$year/$month/$date-$hour:$minute:$second';

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      NoSuchMethodError.withInvocation(this, invocation);
}
