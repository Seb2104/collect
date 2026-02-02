part of '../../common.dart';

extension NumEXT on num? {
  /// Validate given double is not null and returns given value if null.
  num validate({num value = 0}) => this ?? value;

  /// Returns true if the validated number is greater than 0.
  bool get isPositive => validate() > 0;

  /// Returns true if the validated number is less than 0.
  bool get isNegative => validate() < 0;

  /// Returns true if the validated number is equal to 0.
  bool get isZero => validate() == 0;

  /// Formats the validated number to a string with a fixed number of [fractionDigits].
  /// Returns "0.00" (or based on [fractionDigits]) if the number is null.
  String toDoubleDigits(int fractionDigits) {
    return validate().toStringAsFixed(fractionDigits);
  }

  /// Calculates what percentage the validated number is of a given [total].
  /// Returns 0.0 if [total] is 0 or null.
  double percentageOf(num total) {
    if (total == 0) return 0.0;
    return (validate() / total) * 100;
  }

  /// Checks if the validated number falls within a specified range [[min], [max]].
  /// By default, the check is inclusive. Set [inclusive] to false for an exclusive check.
  bool isBetween(num min, num max, {bool inclusive = true}) {
    final num value = validate();
    return inclusive
        ? value >= min && value <= max
        : value > min && value < max;
  }

  /// Returns the absolute value of the validated number.
  num abs() => validate().abs();

  /// Clamps the validated number to be within the range [lowerLimit, upperLimit].
  num clamp(num lowerLimit, num upperLimit) {
    return validate().clamp(lowerLimit, upperLimit);
  }

  /// Rounds the validated number to a specified number of decimal [precision].
  /// For example, (10.12345).roundToPrecision(2) will return 10.12
  double roundToPrecision(int precision) {
    final num value = validate();
    if (value is int) return value.toDouble();
    if (value is double) {
      final num mod = math.pow(10.0, precision);
      return ((value * mod).round().toDouble() / mod);
    }
    return value.toDouble(); // Should not happen given validate()
  }

  /// Returns true if the validated number has no fractional part.
  bool get isInteger => validate() % 1 == 0;
}

extension IntEXT on int? {
  /// Validate given int is not null and returns given value if null.
  int validate({int value = 0}) {
    return this ?? value;
  }

  /// Leaves given height of space
  Widget get height => SizedBox(height: this?.toDouble());

  double get dynamicHeight {
    double screenHeight = SizeConfig.screenHeight as double;
    // 812 is the layout height that designer use
    return (this! / 585) * screenHeight;
  }

  double get dynamicWidth {
    double screenWidth = SizeConfig.screenWidth as double;
    // 375 is the layout width that designer use
    return (this! / 270) * screenWidth;
  }

  /// Leaves given width of space
  Widget get width => SizedBox(width: this?.toDouble());

  /// HTTP status code
  bool isSuccessful() => this! >= 200 && this! <= 206;

  BorderRadius borderRadius([double? val]) =>
      BorderRadius.all(Radius.circular(val ?? 10));

  /// Returns microseconds duration
  /// 5.microseconds
  Duration get microseconds => Duration(microseconds: validate());

  /// Returns milliseconds duration
  /// ```dart
  /// 5.milliseconds
  /// ```
  Duration get milliseconds => Duration(milliseconds: validate());

  /// Returns seconds duration
  /// ```dart
  /// 5.seconds
  /// ```
  Duration get seconds => Duration(seconds: validate());

  /// Returns minutes duration
  /// ```dart
  /// 5.minutes
  /// ```
  Duration get minutes => Duration(minutes: validate());

  /// Returns hours duration
  /// ```dart
  /// 5.hours
  /// ```
  Duration get hours => Duration(hours: validate());

  /// Returns days duration
  /// ```dart
  /// 5.days
  /// ```
  Duration get days => Duration(days: validate());

  /// Returns if a number is between `first` and `second`
  /// ```dart
  /// 100.isBetween(50, 150) // true;
  /// 100.isBetween(100, 100) // true;
  /// ```
  bool isBetween(num first, num second) {
    if (first <= second) {
      return validate() >= first && validate() <= second;
    } else {
      return validate() >= second && validate() <= first;
    }
  }

  /// Returns Size
  Size get size => Size(this!.toDouble(), this!.toDouble());

  // return suffix (th,st,nd,rd) of the given month day number
  String toMonthDaySuffix() {
    if (!(this! >= 1 && this! <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (this! >= 11 && this! <= 13) {
      return '$this th';
    }

    switch (this! % 10) {
      case 1:
        return '$this st';
      case 2:
        return '$this nd';
      case 3:
        return '$this rd';
      default:
        return '$this th';
    }
  }

  // returns month name from the given int
  String toMonthName({bool isHalfName = false}) {
    String status = '';
    if (!(this! >= 1 && this! <= 12)) {
      throw Exception('Invalid day of month');
    }
    if (this == 1) {
      return status = isHalfName ? 'Jan' : 'January';
    } else if (this == 2) {
      return status = isHalfName ? 'Feb' : 'February';
    } else if (this == 3) {
      return status = isHalfName ? 'Mar' : 'March';
    } else if (this == 4) {
      return status = isHalfName ? 'Apr' : 'April';
    } else if (this == 5) {
      return status = isHalfName ? 'May' : 'May';
    } else if (this == 6) {
      return status = isHalfName ? 'Jun' : 'June';
    } else if (this == 7) {
      return status = isHalfName ? 'Jul' : 'July';
    } else if (this == 8) {
      return status = isHalfName ? 'Aug' : 'August';
    } else if (this == 9) {
      return status = isHalfName ? 'Sept' : 'September';
    } else if (this == 10) {
      return status = isHalfName ? 'Oct' : 'October';
    } else if (this == 11) {
      return status = isHalfName ? 'Nov' : 'November';
    } else if (this == 12) {
      return status = isHalfName ? 'Dec' : 'December';
    }
    return status;
  }

  // returns WeekDay from the given int
  String toWeekDay({bool isHalfName = false}) {
    if (!(this! >= 1 && this! <= 7)) {
      throw Exception('Invalid day of month');
    }
    String weekName = '';

    if (this == 1) {
      return weekName = isHalfName ? "Mon" : "Monday";
    } else if (this == 2) {
      return weekName = isHalfName ? "Tue" : "Tuesday";
    } else if (this == 3) {
      return weekName = isHalfName ? "Wed" : "Wednesday";
    } else if (this == 4) {
      return weekName = isHalfName ? "Thu" : "Thursday";
    } else if (this == 5) {
      return weekName = isHalfName ? "Fri" : "Friday";
    } else if (this == 6) {
      return weekName = isHalfName ? "Sat" : "Saturday";
    } else if (this == 7) {
      return weekName = isHalfName ? "Sun" : "Sunday";
    }
    return weekName;
  }

  /// Returns true if given value is 1, else returns false
  bool getBoolInt() {
    if (this == 1) {
      return true;
    }
    return false;
  }
}

extension DoubleEXT on double? {
  /// Validate given double is not null and returns given value if null.
  double validate({double value = 0.0}) => this ?? value;

  /// 100.0.isBetween(50.0, 150.0) // true;
  /// 100.0.isBetween(100.0, 100.0) // true;
  /// ```
  bool isBetween(num first, num second) {
    final lower = math.min(first, second);
    final upper = math.max(first, second);
    return validate() >= lower && validate() <= upper;
  }

  /// Returns Size
  Size get size => Size(this!, this!);
}
