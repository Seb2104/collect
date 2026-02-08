# Period

The `Period` class represents a duration of time with support for years, months, days, hours, minutes, seconds,
milliseconds, and microseconds. It's designed to work seamlessly with the `Moment` class for date arithmetic.

## Table of Contents

- [Construction](#construction)
- [Arithmetic Operations](#arithmetic-operations)
- [Comparison](#comparison)
- [Conversion](#conversion)
- [Examples](#examples)

## Construction

### Basic Construction

```dart
// Single units
final oneDay = Period(days: 1);
final twoHours = Period(hours: 2);
final thirtyMinutes = Period(minutes: 30);

// Multiple units
final complex = Period(
  years: 1,
  months: 2,
  days: 15,
  hours: 6,
  minutes: 30,
  seconds: 45,
);

// All units
final complete = Period(
  years: 1,
  months: 2,
  days: 15,
  hours: 6,
  minutes: 30,
  seconds: 45,
  milliseconds: 500,
  microseconds: 250,
);
```

### Time Unit Constants

```dart
Period.microsecondsPerMillisecond  // 1,000
Period.millisecondsPerSecond       // 1,000
Period.secondsPerMinute            // 60
Period.minutesPerHour              // 60
Period.hoursPerDay                 // 24

Period.microsecondsPerSecond       // 1,000,000
Period.microsecondsPerMinute       // 60,000,000
Period.microsecondsPerHour         // 3,600,000,000
Period.microsecondsPerDay          // 86,400,000,000

Period.millisecondsPerMinute       // 60,000
Period.millisecondsPerHour         // 3,600,000
Period.millisecondsPerDay          // 86,400,000

Period.secondsPerHour              // 3,600
Period.secondsPerDay               // 86,400

Period.minutesPerDay               // 1,440
```

## Arithmetic Operations

### Addition

```dart
final oneWeek = Period(days: 7);
final twoWeeks = Period(days: 14);
final threeWeeks = oneWeek + twoWeeks;  // 21 days

final mixedPeriod = Period(days: 5) + Period(hours: 12) + Period(minutes: 30);
```

### Subtraction

```dart
final twoWeeks = Period(days: 14);
final oneWeek = Period(days: 7);
final remaining = twoWeeks - oneWeek;  // 7 days

final difference = Period(hours: 5) - Period(minutes: 30);
```

### Multiplication

```dart
final oneDay = Period(days: 1);
final threeDays = oneDay * 3;

final halfDay = oneDay * 0.5;  // 12 hours
```

### Negation

```dart
final future = Period(days: 7);
final past = -future;  // -7 days

// Use in arithmetic
final now = Moment.now();
final lastWeek = now + (-Period(days: 7));
```

### Absolute Value

```dart
final negative = Period(days: -7);
final positive = negative.abs();  // 7 days
```

## Comparison

### Equality

```dart
final period1 = Period(days: 1);
final period2 = Period(hours: 24);

period1 == period2  // true (same duration)
```

### Comparison Operators

```dart
final short = Period(hours: 1);
final long = Period(hours: 2);

short < long   // true
short <= long  // true
long > short   // true
long >= short  // true
```

### Sign Check

```dart
final positive = Period(days: 7);
final negative = -Period(days: 7);

positive.isNegative  // false
negative.isNegative  // true
```

## Conversion

### To Moment

Convert a period to a moment (interpreted as duration from epoch):

```dart
final period = Period(days: 100, hours: 12);
final moment = period.moment;

print(moment.year);  // 1970 + (days/365)
print(moment.date);  // Remaining days
```

**Note**: This uses approximations (365 days/year, 30 days/month) and is mainly useful for debugging or display
purposes.

### To String

```dart
final period = Period(days: 7, hours: 12, minutes: 30);
print(period.toString());  // "669000000 microseconds"
```

## Examples

### Deadline Tracker

```dart
class DeadlineTracker extends StatelessWidget {
  final Moment deadline;

  DeadlineTracker({required this.deadline});

  @override
  Widget build(BuildContext context) {
    final now = Moment.now();
    final timeUntil = deadline.difference(now);
    final isOverdue = deadline < now;

    return Card(
      color: isOverdue
          ? AppTheme.error(context).withOpacity(0.1)
          : AppTheme.success(context).withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Word.primary(isOverdue ? 'Overdue!' : 'Time Remaining'),
            SizedBox(height: 8),
            Word(deadline.timeAgo(from: now)),
            SizedBox(height: 4),
            Word.tertiary(
              'Deadline: ${deadline.format([MM, '/', DD, '/', yyyy, space, at, space, hh, colon, mm, space, A])}',
            ),
          ],
        ),
      ),
    );
  }
}
```

### Work Session Timer

```dart
class WorkSession {
  final Period duration;
  final Moment startTime;

  WorkSession({
    required this.duration,
    required this.startTime,
  });

  Moment get endTime => startTime + duration;

  Period get remaining {
    final now = Moment.now();
    if (now < endTime) {
      return endTime.difference(now);
    }
    return Period(); // Zero duration
  }

  bool get isComplete => Moment.now() >= endTime;
}

class WorkSessionDisplay extends StatefulWidget {
  final WorkSession session;

  WorkSessionDisplay({required this.session});

  @override
  _WorkSessionDisplayState createState() => _WorkSessionDisplayState();
}

class _WorkSessionDisplayState extends State<WorkSessionDisplay> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.session.remaining;
    final progress = widget.session.isComplete
        ? 1.0
        : 1.0 - (remaining.moment.totalSeconds / widget.session.duration.moment.totalSeconds);

    return Column(
      children: [
        LinearProgressIndicator(value: progress),
        SizedBox(height: 16),
        if (!widget.session.isComplete) ...[
          Word.primary('Time Remaining'),
          Word(widget.session.endTime.timeAgo(from: Moment.now())),
        ] else
          Word.primary('Session Complete!'),
      ],
    );
  }
}
```

### Recurring Events

```dart
class RecurringEvent {
  final String title;
  final Moment startDate;
  final Period interval;
  final int occurrences;

  RecurringEvent({
    required this.title,
    required this.startDate,
    required this.interval,
    required this.occurrences,
  });

  List<Moment> getOccurrences() {
    final dates = <Moment>[];
    var currentDate = startDate;

    for (int i = 0; i < occurrences; i++) {
      dates.add(currentDate);
      currentDate = currentDate + interval;
    }

    return dates;
  }

  Moment getNextOccurrence() {
    final now = Moment.now();
    var occurrence = startDate;

    while (occurrence < now) {
      occurrence = occurrence + interval;
    }

    return occurrence;
  }
}

// Usage
final weeklyMeeting = RecurringEvent(
  title: 'Team Standup',
  startDate: Moment(year: 2026, month: 1, date: 1, hour: 9, minute: 0),
  interval: Period(days: 7),  // Weekly
  occurrences: 52,  // One year
);

final monthlyReview = RecurringEvent(
  title: 'Monthly Review',
  startDate: Moment(year: 2026, month: 1, date: 1, hour: 14, minute: 0),
  interval: Period(days: 30),  // Monthly (approximate)
  occurrences: 12,  // One year
);

// Display
class EventList extends StatelessWidget {
  final RecurringEvent event;

  EventList({required this.event});

  @override
  Widget build(BuildContext context) {
    final occurrences = event.getOccurrences();
    final next = event.getNextOccurrence();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Word.primary(event.title),
        Word.tertiary('Next: ${next.timeAgo()}'),
        SizedBox(height: 16),
        ...occurrences.map((occurrence) {
          final isPast = occurrence < Moment.now();
          return ListTile(
            leading: Icon(
              isPast ? Icons.check_circle_outline : Icons.schedule,
              color: isPast ? Colors.green : Colors.grey,
            ),
            title: Word(occurrence.format([MM, '/', DD, '/', yyyy])),
            subtitle: Word.tertiary(occurrence.timeAgo()),
          );
        }).toList(),
      ],
    );
  }
}
```

### Countdown Timer

```dart
class CountdownTimer extends StatefulWidget {
  final Period duration;
  final VoidCallback? onComplete;

  CountdownTimer({
    required this.duration,
    this.onComplete,
  });

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Moment endTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    endTime = Moment.now() + widget.duration;
    timer = Timer.periodic(Duration(milliseconds: 100), _tick);
  }

  void _tick(Timer timer) {
    setState(() {});

    if (Moment.now() >= endTime) {
      timer.cancel();
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String _formatRemaining(Period remaining) {
    final moment = remaining.moment;
    final hours = moment.hour ?? 0;
    final minutes = moment.minute ?? 0;
    final seconds = moment.second ?? 0;

    return '${hours.toString().padLeft(2, '0')}:'
           '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final now = Moment.now();
    final remaining = endTime > now
        ? endTime.difference(now)
        : Period();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatRemaining(remaining),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: Fonts.jetBrainsMono.value,
            ),
          ),
          SizedBox(height: 16),
          if (remaining.moment.totalSeconds <= 0)
            Word.primary('Time\'s up!'),
        ],
      ),
    );
  }
}

// Usage
CountdownTimer(
  duration: Period(minutes: 25),  // Pomodoro timer
  onComplete: () {
    context.notify('Time to take a break!');
  },
)
```

### Duration Calculator

```dart
class DurationCalculator extends StatefulWidget {
  @override
  _DurationCalculatorState createState() => _DurationCalculatorState();
}

class _DurationCalculatorState extends State<DurationCalculator> {
  Moment? startTime;
  Moment? endTime;

  @override
  Widget build(BuildContext context) {
    Period? duration;
    if (startTime != null && endTime != null) {
      duration = endTime!.difference(startTime!);
    }

    return Column(
      children: [
        ListTile(
          title: Word('Start Time'),
          subtitle: Word.tertiary(
            startTime?.format([MM, '/', DD, '/', yyyy, space, hh, colon, mm, space, A]) ??
                'Not set',
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final date = await _pickDateTime(context);
              if (date != null) {
                setState(() => startTime = Moment.fromDateTime(date));
              }
            },
          ),
        ),
        ListTile(
          title: Word('End Time'),
          subtitle: Word.tertiary(
            endTime?.format([MM, '/', DD, '/', yyyy, space, hh, colon, mm, space, A]) ??
                'Not set',
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final date = await _pickDateTime(context);
              if (date != null) {
                setState(() => endTime = Moment.fromDateTime(date));
              }
            },
          ),
        ),
        if (duration != null) ...[
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Word.primary('Duration'),
                SizedBox(height: 8),
                Word(endTime!.timeAgo(from: startTime!, short: false)),
                SizedBox(height: 4),
                Word.tertiary(
                  '${(endTime!.totalSeconds - startTime!.totalSeconds) ~/ 86400} days total',
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<DateTime?> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        return DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }

    return null;
  }
}
```

## Best Practices

### Choosing Units

```dart
// ✅ Good: Use appropriate units
final shortDuration = Period(minutes: 30);
final mediumDuration = Period(hours: 2);
final longDuration = Period(days: 7);

// ❌ Avoid: Using inappropriate units
final awkward = Period(minutes: 10080);  // Use days: 7 instead
```

### Arithmetic

```dart
// ✅ Good: Chain operations clearly
final workWeek = Period(days: 5);
final lunch = Period(hours: 1);
final dailyWork = Period(hours: 8) - lunch;
final totalWork = dailyWork * 5;

// ✅ Good: Use parentheses for complex operations
final result = (Period(days: 7) + Period(hours: 12)) * 2;
```

### Comparison with Moments

```dart
// ✅ Good: Calculate period, then compare
final deadline = Moment(year: 2026, month: 12, date: 31);
final gracePeriod = Period(days: 7);
final extendedDeadline = deadline + gracePeriod;

if (Moment.now() < extendedDeadline) {
  print('Still within grace period');
}
```

### Performance

```dart
// ✅ Good: Calculate once, reuse
class EventInfo {
  final Moment start;
  final Moment end;
  late final Period duration = end.difference(start);

  EventInfo(this.start, this.end);
}

// ❌ Avoid: Recalculating repeatedly
Widget build(BuildContext context) {
  final duration = end.difference(start);  // Recalculated every build
  return Text(duration.toString());
}
```

## Limitations

### Month/Year Approximations

Period uses approximations for months and years:

- 1 month = 30 days
- 1 year = 365 days

```dart
// These are approximate
final oneMonth = Period(months: 1);  // Actually 30 days
final oneYear = Period(years: 1);    // Actually 365 days

// For exact calendar operations, use Moment arithmetic
final exactNextMonth = Moment(year: 2026, month: 2, date: 1)
    + Period(days: 28);  // Accounts for February
```

### Large Durations

Very large periods may overflow:

```dart
// ✅ Good: Reasonable durations
final century = Period(years: 100);

// ⚠️ Caution: Very large durations may overflow
final enormous = Period(years: 1000000);
```

## Related

- [Moment](moment.md) - Works with Period for date arithmetic
- [Extensions/Int](../extensions/int.md) - Create durations from integers
