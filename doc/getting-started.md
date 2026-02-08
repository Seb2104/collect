# Getting Started with Collect

This guide will help you get up and running with the Collect package in your Flutter project.

## Installation

### 1. Add Dependency

Add `collect` to your `pubspec.yaml`:

```yaml
dependencies:
  collect: ^1.2.0
```

### 2. Install Package

Run the following command:

```bash
flutter pub get
```

### 3. Import

Import the package in your Dart files:

```dart
import 'package:collect/collect.dart';
```

## First Steps

### Using Custom Data Types

#### Moment - Enhanced DateTime

```dart
// Create moments
final now = Moment.now();
final birthday = Moment(year: 1990, month: 5, date: 15);

// Format dates
print(now.format()); // "the 3rd of February 2026 at 14:30:45"
print(now.shortTime); // "14:30"
print(now.clock); // "2:30:45 PM"

// Time ago
print(birthday.timeAgo()); // "35 years, 8 months, 19 days ago"

// Date arithmetic
final tomorrow = now + Period(days: 1);
final nextWeek = now + Period(weeks: 1);
```

#### Colour - Advanced Color Management

```dart
// Create colours
final sage = Colour.fromHex(hexString: '#9CAF88');
final customRgb = Colour.fromRGB(red: 156, green: 175, blue: 136);
final transparent = Colour.fromARGB(opacity: 50, red: 156, green: 175, blue: 136);

// Convert between formats
final hslColor = Colour.fromHSL(h: 92, s: 0.22, l: 0.61);
final hsvColor = Colour.fromHSV(h: 92, s: 0.22, v: 0.69);

// Get color properties
print(sage.hex); // "FF9CAF88"
print(sage.rgb); // "156,175,136"
```

#### Period - Time Durations

```dart
// Create periods
final oneDay = Period(days: 1);
final twoWeeks = Period(weeks: 2);
final mixed = Period(years: 1, months: 2, days: 15, hours: 6);

// Arithmetic
final total = oneDay + Period(hours: 12);
final doubled = oneDay * 2;

// Use with moments
final future = Moment.now() + Period(days: 7);
```

### Using Extensions

#### Int Extensions

```dart
// Durations
final fiveSeconds = 5.seconds;
final tenMinutes = 10.minutes;
await Future.delayed(2.seconds);

// Spacing widgets
Column(
  children: [
    Text('First'),
    20.height, // SizedBox with 20 height
    Text('Second'),
  ],
)

// Range checks
if (userAge.isBetween(18, 65)) {
  print('Working age');
}

// Month and day names
print(3.toMonthName()); // "March"
print(1.toWeekDay()); // "Monday"
```

#### String Extensions

```dart
// Case checks
'hello'.isLowerCase(); // true
'HELLO'.isUpperCase(); // true

// Transformations
'hello_world'.toCamelCase(); // "HelloWorld"
'HelloWorld'.toSnakeCase(); // "hello_world"
'hello world'.toProperCase(); // "Hello World"
'hello world'.toCapitalised(); // "Hello world"

// Validation
'123.45'.isNumeric(); // true
'abc123'.isAscii(); // true

// Truncation
'Hello World'.abbreviate(6); // "Hel..."
```

#### Widget Extensions

```dart
// Padding
Container().paddingAll(16)
Container().paddingSymmetric(vertical: 8, horizontal: 16)
Container().paddingOnly(top: 10, left: 20)

// Sizing
Text('Hello').withWidth(200)
Text('Hello').withHeight(100)
Text('Hello').withSize(width: 200, height: 100)

// Layout
Text('Hello').center()
Text('Hello').expand()
Text('Hello').flexible()

// Visibility
Text('Hello').visible(isLoggedIn)

// Effects
Text('Hello').opacity(opacity: 0.5)
Text('Hello').rotate(angle: 0.5)
Text('Hello').scale(scale: 1.2)
```

### Using UI Components

#### Word - Enhanced Text

```dart
// Basic usage
Word('Regular text')
Word.primary('Heading text') // Large, bold
Word.secondary('Subtitle text') // Medium emphasis
Word.tertiary('Caption text') // Low emphasis

// Custom styling
Word(
  'Custom text',
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.blue,
  fontFamily: Fonts.montserrat,
)
```

#### AppTheme - Material 3 Theming

```dart
// Apply theme
MaterialApp(
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: ThemeMode.system,
  home: MyHomePage(),
)

// Use theme colors
Container(
  color: AppTheme.primarySage,
  child: Text(
    'Themed text',
    style: TextStyle(
      color: AppTheme.textPrimary(context),
    ),
  ),
)
```

#### Notifications

```dart
// Show notifications
context.notify('Operation successful');
context.warn('This is a warning');
context.fail('An error occurred');

// Or use the manager directly
NotificationManager().show(
  context: context,
  message: 'Custom notification',
  type: NotificationType.info,
  duration: Duration(seconds: 5),
);
```

## Next Steps

- Explore [Data Types](datatypes/README.md) for detailed information on Colour, Moment, and Period
- Check out [Extensions](extensions/README.md) to see all available extension methods
- Browse [Presentation Widgets](presentation/README.md) for UI components
- Look at [Examples](examples/README.md) for real-world usage patterns

## Common Patterns

### Responsive Sizing

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      width: 100.dynamicWidth,
      height: 50.dynamicHeight,
      child: Text('Responsive!'),
    );
  }
}
```

### Theme-Aware UI

```dart
Container(
  decoration: BoxDecoration(
    color: AppTheme.surface(context),
    border: Border.all(
      color: AppTheme.border(context),
    ),
  ),
  child: Word.primary('Theme-aware content'),
)
```

### Date Formatting

```dart
final moment = Moment.fromDateTime(DateTime.now());

// Various formats
Text(moment.format([yyyy, dash, MM, dash, DD])); // 2026-02-03
Text(moment.clock); // 2:30:45 PM
Text(moment.time); // 14:30:45
Text(moment.timeAgo(short: true)); // "5m ago"
```

## Tips

1. **Use Extensions**: Extensions make your code more readable and concise
2. **Leverage AppTheme**: Use the theme system for consistent, adaptive UI
3. **Moment vs DateTime**: Use `Moment` for display and formatting, `DateTime` for calculations
4. **Widget Chaining**: Chain widget extensions for clean, readable layouts
5. **Type Safety**: All extensions are null-safe and provide validation methods

## Troubleshooting

### Issue: Extensions not available

**Solution**: Make sure you've imported the package:

```dart
import 'package:collect/collect.dart';
```

### Issue: Fonts not displaying

**Solution**: The package includes font assets. Make sure you're using the provided fonts through the `Fonts` enum:

```dart
Word('Text', fontFamily: Fonts.montserrat)
```

### Issue: Theme colors not updating

**Solution**: Access theme colors through methods that take `BuildContext`:

```dart
// Good
AppTheme.textPrimary(context)

// Bad
AppTheme.lightTextPrimary // Static color, doesn't adapt
```
