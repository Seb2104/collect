# Moment

The `Moment` class is an enhanced date/time type that provides powerful formatting, manipulation, and display
capabilities beyond Dart's `DateTime`.

## Table of Contents

- [Construction](#construction)
- [Properties](#properties)
- [Formatting](#formatting)
- [Time Ago](#time-ago)
- [Date Arithmetic](#date-arithmetic)
- [Comparison](#comparison)
- [Examples](#examples)

## Construction

### From Current Time

```dart
final now = Moment.now();  // Current date and time
```

### From Components

```dart
// Full date and time
final specific = Moment(
  year: 2026,
  month: 2,
  date: 3,
  hour: 14,
  minute: 30,
  second: 45,
);

// Partial dates (other fields are null)
final yearOnly = Moment(year: 2026);
final dateOnly = Moment(year: 2026, month: 2, date: 3);
```

### From DateTime

```dart
final dateTime = DateTime.now();
final moment = Moment.fromDateTime(dateTime);
```

### From String

```dart
// Format: YYYY/MM/DD-HH:MM:SS
final moment = Moment.parse(string: '2026/02/03-14:30:45');

// Safe parsing with error handling
final moment = Moment.tryParse(
  '2026/02/03-14:30:45',
  onException: (e) {
    print('Parse error: $e');
    return Moment.now();  // Fallback
  },
);
```

### Convenience Constructors

```dart
final tomorrow = Moment.tomorrow();   // Now + 1 day
final yesterday = Moment.yesterday(); // Now - 1 day
```

## Properties

### Date Components

```dart
final moment = Moment(
  year: 2026,
  month: 2,
  date: 3,
  hour: 14,
  minute: 30,
  second: 45,
);

moment.year    // 2026
moment.month   // 2 (1-12)
moment.date    // 3 (day of month)
moment.hour    // 14 (0-23)
moment.minute  // 30
moment.second  // 45
```

### Calculated Properties

```dart
// Weekday (1 = Monday, 7 = Sunday)
moment.weekday  // 2 (Tuesday)

// Era (AD/BC)
moment.era  // "AD"

// Total seconds since epoch (January 1, 1970)
moment.totalSeconds  // 1770235845

// Milliseconds since epoch
moment.millisecondsSinceEpoch  // 1770235845000
```

### Time Strings

```dart
final moment = Moment(year: 2026, month: 2, date: 3, hour: 14, minute: 30, second: 45);

// 24-hour format
moment.time       // "14:30:45"
moment.shortTime  // "14:30"

// 12-hour format
moment.clock       // "2:30:45 PM"
moment.shortClock  // "2:30 PM"
moment.clockPhase  // "PM"
```

### Conversion

```dart
// To DateTime
final dateTime = moment.dateTime;

// To String (YYYY/MM/DD-HH:MM:SS)
final string = moment.toString();  // "2026/2/3-14:30:45"

// To List
final list = moment.toList();  // [45, 30, 14, 3, 2, 2026]

// To Map
final map = moment.asMap;  // {"45": 45, "30": 30, ...}

// To Period (time of day only)
final period = moment.period;  // Period with hours, minutes, seconds
```

## Formatting

### Format Tokens

Moment provides a rich set of format tokens:

| Token         | Output               | Example    |
|---------------|----------------------|------------|
| `yyyy`        | Full year            | 2026       |
| `yy`          | Two-digit year       | 26         |
| `mmmm`        | Full month name      | February   |
| `MMM`         | Short month name     | Feb        |
| `MM`          | Two-digit month      | 02         |
| `M`           | Month number         | 2          |
| `Mo`          | Month with ordinal   | 2nd        |
| `dddd`        | Full day name        | Tuesday    |
| `ddd`         | Short day name       | Tue        |
| `DD`          | Two-digit date       | 03         |
| `D`           | Date number          | 3          |
| `Do`          | Date with ordinal    | 3rd        |
| `HH`          | Two-digit hour (24h) | 14         |
| `H`           | Hour (24h)           | 14         |
| `hh`          | Two-digit hour (12h) | 02         |
| `h`           | Hour (12h)           | 2          |
| `mm`          | Two-digit minute     | 30         |
| `m`           | Minute               | 30         |
| `ss`          | Two-digit second     | 45         |
| `s`           | Second               | 45         |
| `A`           | AM/PM uppercase      | PM         |
| `a`           | am/pm lowercase      | pm         |
| `t`           | Time (H:M:S)         | 14:30:45   |
| `dateNumeric` | Numeric date         | 03/02/2026 |

### Formatting Constants

Use predefined constants from the library:

```dart
// From constants
import 'package:collect/collect.dart';

// Common words
the, of, at, space, comma, colon, dash

// Example usage
final formatted = moment.format([
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
  space,
  A,
]);
// Output: "the 3rd of February 2026 at 02:30 PM"
```

### Default Format

```dart
// Default format
const defaultFormatStyle = [
  the, space, Do, space, of, space,
  mmmm, space, yyyy, space,
  at, space,
  hh, colon, mm, colon, ss
];

final moment = Moment(year: 2026, month: 2, date: 3, hour: 14, minute: 30, second: 45);
moment.format();  // Uses default: "the 3rd of February 2026 at 02:30:45"
```

### Custom Formats

```dart
// ISO 8601 format
moment.format([yyyy, dash, MM, dash, DD]);
// "2026-02-03"

// US format
moment.format([MM, '/', DD, '/', yyyy]);
// "02/03/2026"

// Friendly format
moment.format([dddd, comma, space, mmmm, space, D, comma, space, yyyy]);
// "Tuesday, February 3, 2026"

// Time only
moment.format([hh, colon, mm, space, A]);
// "02:30 PM"

// Custom text
moment.format(['Today is ', dddd, '!']);
// "Today is Tuesday!"
```

## Time Ago

Display relative time from now or a reference point:

### Basic Usage

```dart
final past = Moment(year: 2025, month: 12, date: 25);
print(past.timeAgo());
// "1 month, 9 days ago" (from now)
```

### Custom Reference Point

```dart
final birthday = Moment(year: 1995, month: 7, date: 15);
final reference = Moment(year: 2026, month: 2, date: 3);

print(birthday.timeAgo(from: reference));
// "30 years, 6 months, 19 days ago"
```

### Short Format

```dart
final past = Moment(year: 2026, month: 2, date: 1);
print(past.timeAgo(short: true));
// "2d" (2 days)

final older = Moment(year: 2025, month: 12, date: 1);
print(older.timeAgo(short: true));
// "2mo 2d" (2 months 2 days)
```

### Future Times

```dart
final future = Moment(year: 2026, month: 3, date: 1);
print(future.timeAgo());
// "in 25 days"

print(future.timeAgo(short: true));
// "25d"
```

### Time Units

The `timeAgo` method shows:

- Years
- Months (approximate, 30 days)
- Days
- Hours
- Minutes
- Seconds

```dart
// Just now
print(Moment.now().timeAgo());  // "0 seconds ago"

// Complex duration
final complex = Moment(year: 2020, month: 1, date: 1);
print(complex.timeAgo());
// "6 years, 1 month, 2 days, 14 hours, 30 minutes ago"
```

## Date Arithmetic

Perform date calculations using `Period`:

### Addition

```dart
final now = Moment.now();

// Add days
final nextWeek = now + Period(days: 7);

// Add months
final nextMonth = now + Period(months: 1);

// Add years
final nextYear = now + Period(years: 1);

// Add mixed periods
final future = now + Period(
  years: 1,
  months: 2,
  days: 15,
  hours: 6,
  minutes: 30,
);
```

### Subtraction

```dart
final now = Moment.now();

// Subtract days
final lastWeek = now - Period(days: 7);

// Subtract months
final lastMonth = now - Period(months: 1);

// Complex subtraction
final past = now - Period(
  years: 1,
  months: 6,
  days: 10,
);
```

### Using Method

```dart
final now = Moment.now();
final future = now.addPeriod(Period(days: 7));
```

### Difference Between Moments

```dart
final start = Moment(year: 2025, month: 1, date: 1);
final end = Moment(year: 2026, month: 2, date: 3);

final diff = end.difference(start);
// Returns Period representing the time between
```

## Comparison

### Equality

```dart
final moment1 = Moment(year: 2026, month: 2, date: 3);
final moment2 = Moment(year: 2026, month: 2, date: 3);

moment1 == moment2  // true
```

### Comparison Operators

```dart
final earlier = Moment(year: 2025, month: 1, date: 1);
final later = Moment(year: 2026, month: 1, date: 1);

earlier < later   // true
earlier <= later  // true
later > earlier   // true
later >= earlier  // true
```

### Comparable Interface

```dart
final moments = [
  Moment(year: 2026, month: 3, date: 1),
  Moment(year: 2026, month: 1, date: 1),
  Moment(year: 2026, month: 2, date: 1),
];

moments.sort();  // Sorts chronologically
```

## Examples

### Birthday Countdown

```dart
class BirthdayCountdown extends StatelessWidget {
  final Moment birthday;

  BirthdayCountdown({required this.birthday});

  @override
  Widget build(BuildContext context) {
    // Calculate next birthday
    final now = Moment.now();
    var nextBirthday = Moment(
      year: now.year!,
      month: birthday.month,
      date: birthday.date,
    );

    // If birthday passed this year, use next year
    if (nextBirthday < now) {
      nextBirthday = Moment(
        year: now.year! + 1,
        month: birthday.month,
        date: birthday.date,
      );
    }

    final age = now.year! - birthday.year!;
    final timeUntil = nextBirthday.timeAgo(from: now, short: false);

    return Column(
      children: [
        Word.primary('Birthday Countdown'),
        Word('You are $age years old'),
        Word('Next birthday ${timeUntil.replaceAll(' ago', '')}'),
        Word(
          nextBirthday.format([
            dddd,
            comma,
            space,
            mmmm,
            space,
            Do,
            comma,
            space,
            yyyy,
          ]),
        ),
      ],
    );
  }
}
```

### Event Timeline

```dart
class Event {
  final String title;
  final Moment moment;

  Event(this.title, this.moment);
}

class Timeline extends StatelessWidget {
  final List<Event> events = [
    Event('Project Start', Moment(year: 2025, month: 1, date: 1)),
    Event('First Release', Moment(year: 2025, month: 6, date: 15)),
    Event('Version 2.0', Moment(year: 2026, month: 1, date: 1)),
    Event('Major Update', Moment(year: 2026, month: 6, date: 1)),
  ];

  @override
  Widget build(BuildContext context) {
    // Sort events chronologically
    events.sort((a, b) => a.moment.compareTo(b.moment));

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isPast = event.moment < Moment.now();

        return ListTile(
          leading: Icon(
            isPast ? Icons.check_circle : Icons.schedule,
            color: isPast ? Colors.green : Colors.orange,
          ),
          title: Word(event.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Word(event.moment.format([mmmm, space, Do, comma, space, yyyy])),
              Word.tertiary(event.moment.timeAgo()),
            ],
          ),
        );
      },
    );
  }
}
```

### Meeting Scheduler

```dart
class MeetingScheduler extends StatefulWidget {
  @override
  _MeetingSchedulerState createState() => _MeetingSchedulerState();
}

class _MeetingSchedulerState extends State<MeetingScheduler> {
  Moment? scheduledTime;

  void _scheduleMeeting(DateTime dateTime) {
    setState(() {
      scheduledTime = Moment.fromDateTime(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (scheduledTime != null) ...[
          Word.primary('Meeting Scheduled'),
          SizedBox(height: 16),

          // Full format
          InfoRow(
            label: 'Date',
            value: scheduledTime!.format([
              dddd,
              comma,
              space,
              mmmm,
              space,
              Do,
              comma,
              space,
              yyyy,
            ]),
          ),

          // Time
          InfoRow(
            label: 'Time',
            value: scheduledTime!.clock,
          ),

          // Relative time
          InfoRow(
            label: 'In',
            value: scheduledTime!.timeAgo(),
          ),

          // Weekday
          InfoRow(
            label: 'Day',
            value: scheduledTime!.weekday.toString(),
          ),
        ],

        ElevatedButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );

            if (picked != null) {
              final TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (time != null) {
                final dateTime = DateTime(
                  picked.year,
                  picked.month,
                  picked.day,
                  time.hour,
                  time.minute,
                );
                _scheduleMeeting(dateTime);
              }
            }
          },
          child: Text('Schedule Meeting'),
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Word.secondary(label + ':'),
          Word(value),
        ],
      ),
    );
  }
}
```

### Age Calculator

```dart
class AgeCalculator extends StatelessWidget {
  final Moment birthDate;

  AgeCalculator({required this.birthDate});

  Map<String, int> calculateAge() {
    final now = Moment.now();
    final diff = now.difference(birthDate);

    int years = diff.moment.year! - 1970;
    int months = diff.moment.month! - 1;
    int days = diff.moment.date! - 1;

    return {
      'years': years,
      'months': months,
      'days': days,
      'totalDays': (now.totalSeconds - birthDate.totalSeconds) ~/ 86400,
      'totalHours': (now.totalSeconds - birthDate.totalSeconds) ~/ 3600,
    };
  }

  @override
  Widget build(BuildContext context) {
    final age = calculateAge();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Word.primary('Age Information'),
            SizedBox(height: 16),
            Word('${age['years']} years, ${age['months']} months, ${age['days']} days old'),
            SizedBox(height: 8),
            Word.tertiary('Total: ${age['totalDays']} days (${age['totalHours']} hours)'),
            SizedBox(height: 16),
            Word.secondary('Born on:'),
            Word(birthDate.format([dddd, comma, space, mmmm, space, Do, comma, space, yyyy])),
          ],
        ),
      ),
    );
  }
}
```

### Date Range Selector

```dart
class DateRangeDisplay extends StatelessWidget {
  final Moment start;
  final Moment end;

  DateRangeDisplay({required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    final duration = end.difference(start);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.border(context)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Word.tertiary('From'),
                    Word(start.format([MM, '/', DD, '/', yyyy])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Word.tertiary('To'),
                    Word(end.format([MM, '/', DD, '/', yyyy])),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(),
          Word.tertiary('Duration: ${duration.moment.date} days'),
        ],
      ),
    );
  }
}
```

## Best Practices

### Null Safety

```dart
// ✅ Good: Check for null before operations
if (moment.year != null && moment.month != null && moment.date != null) {
  // Safe to perform date operations
  final formatted = moment.format([yyyy, dash, MM, dash, DD]);
}

// ✅ Good: Provide defaults when converting to DateTime
final dateTime = moment.dateTime;  // Automatically provides defaults
```

### Performance

```dart
// ✅ Good: Cache formatted strings
class EventDisplay {
  final Moment eventTime;
  late final String displayDate = eventTime.format([mmmm, space, Do, comma, space, yyyy]);
  late final String displayTime = eventTime.clock;

  EventDisplay(this.eventTime);
}

// ❌ Avoid: Formatting in build method
Widget build(BuildContext context) {
  return Text(moment.format([...]));  // Formats every build
}
```

### Storage

```dart
// ✅ Good: Store as string or milliseconds
final momentString = moment.toString();  // "2026/2/3-14:30:45"
final momentMillis = moment.millisecondsSinceEpoch;

// Load from storage
final moment = Moment.parse(string: momentString);
final moment = Moment.fromDateTime(
  DateTime.fromMillisecondsSinceEpoch(momentMillis),
);
```

## Related

- [Period](period.md) - Used for date arithmetic with Moment
- [Extensions/Int](../extensions/int.md) - Convert integers to month/day names
- [Constants/Moment](../constants/moment.md) - Format token constants
