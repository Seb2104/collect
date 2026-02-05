# Data Types

The Collect package provides three powerful custom data types that enhance Flutter's built-in types with additional functionality and convenience.

## Overview

| Data Type | Purpose | Key Features |
|-----------|---------|--------------|
| [Colour](colour.md) | Advanced color management | RGB, HSL, HSV, Hex conversion; Color manipulation |
| [Moment](moment.md) | Enhanced date/time handling | Formatting, time ago, date arithmetic, comparison |
| [Period](period.md) | Time duration management | Years, months, days support; Duration arithmetic |

## Quick Comparison

### Colour vs Color

```dart
// Flutter's Color
final flutterColor = Color(0xFF9CAF88);
final fromRGB = Color.fromRGBO(156, 175, 136, 1.0);

// Collect's Colour
final collectColour = Colour.fromHex(hexString: '#9CAF88');
final fromHSL = Colour.fromHSL(h: 92, s: 0.22, l: 0.61);
print(collectColour.hex); // "FF9CAF88"
print(collectColour.rgb); // "156,175,136"
```

**When to use Colour:**
- Need to convert between color formats (RGB, HSL, HSV, Hex)
- Want to get string representations of colors
- Need advanced color manipulation
- Want to store color values in different formats

### Moment vs DateTime

```dart
// Dart's DateTime
final dartDateTime = DateTime.now();
final formatted = '${dartDateTime.year}-${dartDateTime.month}-${dartDateTime.day}';

// Collect's Moment
final collectMoment = Moment.now();
final formatted = collectMoment.format([yyyy, dash, MM, dash, DD]);
print(collectMoment.timeAgo()); // "5 minutes ago"
print(collectMoment.clock); // "2:30:45 PM"
```

**When to use Moment:**
- Need human-readable date formatting
- Want "time ago" functionality
- Need date arithmetic with readable syntax
- Want to display dates to users

### Period vs Duration

```dart
// Dart's Duration
final dartDuration = Duration(days: 7, hours: 12, minutes: 30);
final addDuration = DateTime.now().add(dartDuration);

// Collect's Period
final collectPeriod = Period(days: 7, hours: 12, minutes: 30);
final future = Moment.now() + collectPeriod;
final doubled = collectPeriod * 2;
```

**When to use Period:**
- Need to work with years and months
- Want arithmetic operations on periods
- Need to store durations separately from specific times
- Want to combine periods easily

## Working Together

These types are designed to work seamlessly together:

```dart
// Create a moment
final birthday = Moment(year: 1995, month: 7, date: 15);

// Calculate age using Period
final age = Moment.now().difference(birthday);
print('Age: ${age.moment.year - 1970} years');

// Add a period to get future date
final reunion = birthday + Period(years: 30);

// Style with colour
Container(
  decoration: BoxDecoration(
    color: Colour.fromHex(hexString: '#9CAF88').color,
  ),
  child: Word(reunion.format([
    'Reunion:',
    space,
    mmmm,
    space,
    Do,
    comma,
    space,
    yyyy,
  ])),
)
```

## Conversion to Built-in Types

All custom types can be converted to Flutter's built-in types when needed:

```dart
// Colour to Color
Colour customColour = Colour.fromHex(hexString: '#9CAF88');
Color flutterColor = customColour.color;

// Moment to DateTime
Moment customMoment = Moment.now();
DateTime flutterDateTime = customMoment.dateTime;

// Period works with Duration internally
Period customPeriod = Period(days: 7);
Moment result = Moment.now() + customPeriod; // Uses Duration internally
```

## Performance Considerations

### Colour
- Lightweight, stores only 4 integers (ARGB)
- Conversions are computed on-demand
- Use `color` getter to convert to Flutter's `Color` for rendering

### Moment
- Stores 6 nullable integers (year, month, date, hour, minute, second)
- Format calculations are performed on-demand
- Use `dateTime` getter for DateTime operations

### Period
- Stores duration as microseconds internally
- Arithmetic operations are fast
- Conversion to/from years and months uses approximations (365 days/year, 30 days/month)

## Best Practices

1. **Use the right type for the job**
   - Display to users: `Moment`, `Colour`
   - Internal calculations: `DateTime`, `Color`, `Duration`
   - Storage: Consider conversion to primitives

2. **Conversion costs**
   - Convert once and reuse
   - Don't convert in build methods repeatedly
   - Cache formatted strings if used multiple times

3. **Null safety**
   - `Moment` fields can be null for partial dates
   - Always provide defaults when converting to `DateTime`
   - Use validation methods before operations

4. **Immutability**
   - All types are immutable
   - Operations return new instances
   - Safe to pass around and cache

## Next Steps

- [Colour Documentation](colour.md) - Detailed color manipulation guide
- [Moment Documentation](moment.md) - Comprehensive date/time handling
- [Period Documentation](period.md) - Duration management reference
