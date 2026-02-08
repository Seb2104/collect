# Extensions

The Collect package provides powerful extensions for Dart's built-in types and Flutter widgets, making your code more
readable and concise.

## Overview

| Extension                        | Purpose                     | Key Features                                               |
|----------------------------------|-----------------------------|------------------------------------------------------------|
| [Int](int.md)                    | Enhanced integer operations | Durations, spacing widgets, range checks, date conversions |
| [Double](double.md)              | Enhanced double operations  | Validation, range checks, size creation                    |
| [Num](num.md)                    | Enhanced number operations  | Type checks, formatting, percentage calculations           |
| [String](string.md)              | Enhanced string operations  | Case transformations, validation, formatting               |
| [Widget](widget.md)              | Widget composition helpers  | Padding, sizing, visibility, effects                       |
| [List](list.md)                  | Collection operations       | Validation, indexing, aggregations                         |
| [BuildContext](build_context.md) | Context utilities           | Notifications, theme access                                |

## Quick Examples

### Int Extensions

```dart
// Durations
await Future.delayed(2.seconds);
final timeout = 5.minutes;

// Spacing
Column(
  children: [
    Text('First'),
    16.height,  // SizedBox(height: 16)
    Text('Second'),
  ],
)

// Date names
print(1.toMonthName());  // "January"
print(3.toWeekDay());    // "Wednesday"
```

### String Extensions

```dart
// Transformations
'hello_world'.toCamelCase();  // "HelloWorld"
'HelloWorld'.toSnakeCase();   // "hello_world"

// Validation
'123.45'.isNumeric();  // true
'HELLO'.isUpperCase(); // true
```

### Widget Extensions

```dart
// Padding
Text('Hello').paddingAll(16);
Text('Hello').paddingSymmetric(vertical: 8, horizontal: 16);

// Layout
Text('Hello').center();
Text('Hello').expand();

// Effects
Text('Hello').opacity(opacity: 0.5);
```

## Extension Philosophy

Extensions in Collect follow these principles:

### 1. Null-Safe by Default

All extensions handle null values gracefully:

```dart
int? nullableInt = null;
nullableInt.validate();  // Returns 0

String? nullableString = null;
nullableString.isBlank();  // Returns true
```

### 2. Chainable Operations

Extensions can be chained for clean, readable code:

```dart
Text('Hello')
  .paddingAll(16)
  .center()
  .opacity(opacity: 0.8)
  .cornerRadiusWithClipRRect(8);
```

### 3. Descriptive Names

Method names clearly describe what they do:

```dart
// Good extension names
100.isBetween(50, 150)
'hello'.startsWithLowerCase()
widget.withSize(width: 200, height: 100)

// Not just abbreviations
100.btw(50, 150)  // ❌ Not used
'hello'.swlc()     // ❌ Not used
```

### 4. Common Use Cases

Extensions target frequently-needed operations:

```dart
// Common: Converting ints to durations
5.seconds
10.minutes

// Common: Adding padding to widgets
Container().paddingAll(16)

// Common: Checking string properties
email.isNotBlank()
```

## Usage Patterns

### Responsive Design

```dart
class ResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      width: 200.dynamicWidth,   // Scales with screen
      height: 100.dynamicHeight, // Scales with screen
      child: Text('Responsive!'),
    );
  }
}
```

### Clean Widget Trees

```dart
// Without extensions
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Center(
      child: SizedBox(
        width: 200,
        child: Opacity(
          opacity: 0.8,
          child: Text('Hello'),
        ),
      ),
    ),
  );
}

// With extensions
Widget build(BuildContext context) {
  return Text('Hello')
    .withWidth(200)
    .opacity(opacity: 0.8)
    .center()
    .paddingSymmetric(horizontal: 16);
}
```

### Validation and Checks

```dart
// Form validation
if (email.isNotBlank() && email.isAscii()) {
  // Valid email format check
}

// Range validation
if (age.isBetween(18, 120)) {
  // Valid age range
}

// Number checks
if (amount.isPositive && !amount.isZero) {
  // Process payment
}
```

### List Operations

```dart
final numbers = [1, 2, 3, 4, 5];

// Safe operations
final safeList = numbers.validate();  // Never null

// Aggregations
final sum = numbers.sumBy((n) => n);        // 15
final average = numbers.averageBy((n) => n); // 3.0

// With index
numbers.forEachIndexed((element, index) {
  print('$index: $element');
});
```

## Performance Considerations

### Extension Method Costs

Extensions are resolved at compile-time and have minimal overhead:

```dart
// No runtime cost
final duration = 5.seconds;  // Just creates Duration(seconds: 5)

// Minimal cost
widget.paddingAll(16);  // Creates one Padding widget
```

### Avoid Repeated Conversions

```dart
// ✅ Good: Convert once
final color = AppTheme.primarySage.color;
return Container(
  color: color,
  child: Text('Text', style: TextStyle(color: color)),
);

// ❌ Avoid: Multiple conversions
return Container(
  color: AppTheme.primarySage.color,  // Conversion 1
  child: Text('Text', style: TextStyle(
    color: AppTheme.primarySage.color,  // Conversion 2
  )),
);
```

### Widget Building

```dart
// ✅ Good: Use extensions for composition
Text('Hello')
  .paddingAll(16)
  .center();

// ✅ Also good: Direct construction for simple cases
Padding(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
);
```

## Best Practices

### 1. Use Validation Extensions

```dart
// ✅ Good: Always validate nullable values
int? userInput = getUserInput();
final safeValue = userInput.validate();  // Defaults to 0

// ❌ Avoid: Using ?? everywhere
final value = userInput ?? 0;
final other = userInput ?? 0;
```

### 2. Chain When It Improves Readability

```dart
// ✅ Good: Short, readable chains
Text('Hello')
  .paddingAll(16)
  .center();

// ⚠️ Caution: Very long chains may be hard to read
Text('Hello')
  .paddingAll(16)
  .center()
  .opacity(opacity: 0.8)
  .scale(scale: 1.2)
  .rotate(angle: 0.5)
  .withSize(width: 200, height: 100);  // Consider breaking up

// ✅ Better: Use intermediate variables
final styledText = Text('Hello')
  .paddingAll(16)
  .center();

final transformedText = styledText
  .opacity(opacity: 0.8)
  .scale(scale: 1.2)
  .rotate(angle: 0.5);
```

### 3. Use the Right Extension

```dart
// ✅ Good: Use specific extensions
if (text.isNotBlank() && text.startsWithLowerCase()) {
  // ...
}

// ❌ Avoid: Manual checks when extensions exist
if (text != null && text.isNotEmpty && text.trim().isNotEmpty) {
  // Use isNotBlank() instead
}
```

## Migration from Standard Dart

### Duration Creation

```dart
// Before
final timeout = Duration(seconds: 5);
final delay = Duration(minutes: 2);

// After
final timeout = 5.seconds;
final delay = 2.minutes;
```

### Widget Padding

```dart
// Before
Padding(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)

// After
Text('Hello').paddingAll(16)
```

### String Checks

```dart
// Before
if (str != null && str.isNotEmpty && str.trim().isNotEmpty) {
  // ...
}

// After
if (str.isNotBlank()) {
  // ...
}
```

## Related Documentation

- [Int Extensions](int.md) - Complete int extension reference
- [Double Extensions](double.md) - Complete double extension reference
- [Num Extensions](num.md) - Complete num extension reference
- [String Extensions](string.md) - Complete string extension reference
- [Widget Extensions](widget.md) - Complete widget extension reference
- [List Extensions](list.md) - Complete list extension reference
- [BuildContext Extensions](build_context.md) - Complete context extension reference
