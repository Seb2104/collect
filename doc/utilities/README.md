# Utilities

The Collect package provides utility classes for common operations like base conversion, notifications, and string
manipulation.

## Overview

| Utility                           | Purpose             | Key Features                                                     |
|-----------------------------------|---------------------|------------------------------------------------------------------|
| [Radix](radix.md)                 | Base conversion     | Binary, octal, decimal, hexadecimal, and beyond (up to base-256) |
| [Notifications](notifications.md) | Toast notifications | Auto-dismissing overlays, multiple types, animations             |
| [Strings](strings.md)             | String manipulation | Formatting, validation, case conversion                          |

## Quick Start

### Radix - Base Conversion

```dart
// Convert to different bases
Radix.bin(255);  // "11111111"
Radix.oct(255);  // "377"
Radix.hex(255);  // "FF"

// Convert from any base to decimal
Radix.base('FF', Bases.b16);  // 255
Radix.base('377', Bases.b8);  // 255

// Color utilities
Radix.percentToColourValue(50);    // 127 (50% of 255)
Radix.fractionToColourValue(0.5);  // 127 (0.5 * 255)
```

### Notifications - Toast Messages

```dart
// Simple notifications
context.notify('Operation successful');
context.warn('This is a warning');
context.fail('An error occurred');

// Custom notifications
NotificationManager().show(
  context: context,
  message: 'Custom notification',
  type: NotificationType.info,
  duration: Duration(seconds: 5),
);
```

### Strings - Text Manipulation

```dart
// Case transformations
Strings.toCamelCase('hello_world');      // "HelloWorld"
Strings.toSnakeCase('HelloWorld');       // "hello_world"
Strings.toProperCase('hello world');     // "Hello World"
Strings.toCapitalised('hello');          // "Hello"

// Validation
Strings.isBlank('  ');        // true
Strings.isNumeric('123.45');  // true
Strings.isAscii('hello');     // true
Strings.isUpperCase('HELLO'); // true

// Formatting
Strings.abbreviate('Hello World', 6);  // "Hel..."
Strings.reverse('hello');              // "olleh"
Strings.left('hello', 3);              // "hel"
Strings.right('hello', 3);             // "llo"
```

## Radix Utility

### Supported Bases

The Radix utility supports an extensive range of bases:

```dart
// Common bases
Bases.b2   // Binary (0-1)
Bases.b8   // Octal (0-7)
Bases.b10  // Decimal (0-9)
Bases.b16  // Hexadecimal (0-9, A-F)

// Extended bases
Bases.b32  // Base-32
Bases.b64  // Base-64
Bases.b256 // Base-256 (full character set)
```

### Conversion Examples

```dart
// Number to string (various bases)
final number = 1234;
print(Radix.bin(number));  // "10011010010"
print(Radix.oct(number));  // "2322"
print(Radix.dec(number));  // "1234"
print(Radix.hex(number));  // "4D2"

// String to number (from any base)
print(Radix.base('4D2', Bases.b16));       // 1234
print(Radix.base('2322', Bases.b8));       // 1234
print(Radix.base('10011010010', Bases.b2)); // 1234

// Convert between bases
final hexValue = Radix.base(1234, Bases.b16);  // "4D2"
final binValue = Radix.base(hexValue, Bases.b2); // Would convert from hex to binary
```

### Color Conversions

```dart
// Percentage to color value (0-100 → 0-255)
Radix.percentToColourValue(0);    // 0
Radix.percentToColourValue(50);   // 127
Radix.percentToColourValue(100);  // 255

// Fraction to color value (0.0-1.0 → 0-255)
Radix.fractionToColourValue(0.0);   // 0
Radix.fractionToColourValue(0.5);   // 127
Radix.fractionToColourValue(1.0);   // 255

// Direct color value clamping
Radix.colourValue(300);   // 255 (clamped)
Radix.colourValue(-10);   // 0 (clamped)
Radix.colourValue(128);   // 128
```

### Custom Base Encoding

```dart
class DataEncoder {
  static String encodeToBase64(String data) {
    // Convert string to numbers
    final codes = data.codeUnits;

    // Convert each code to base-64
    final encoded = codes.map((code) {
      return Radix.base(code, Bases.b64);
    }).join(',');

    return encoded;
  }

  static String compactEncode(int value) {
    // Use base-256 for maximum compactness
    return Radix.base(value, Bases.b256);
  }
}
```

## Notification System

### Notification Types

```dart
enum NotificationType {
  success,   // Green, for successful operations
  error,     // Red, for errors
  info,      // Blue, for information
  warning,   // Orange, for warnings
}
```

### Display Notifications

```dart
// Through BuildContext extensions
context.notify('Info message');        // info type
context.warn('Warning message');       // warning type
context.fail('Error message');         // error type

// Through NotificationManager
NotificationManager().show(
  context: context,
  message: 'Operation completed',
  type: NotificationType.success,
  duration: Duration(seconds: 3),
);
```

### Notification Features

- **Auto-dismiss**: Notifications automatically fade out after a duration
- **Multiple notifications**: Stack multiple notifications vertically
- **Animations**: Smooth slide-in from right with fade
- **Click to dismiss**: Tap notification to dismiss immediately
- **Type-specific durations**:
    - `error`: 5 seconds (longer to read)
    - Other types: 3 seconds

### Custom Notification Manager

```dart
class AppNotifications {
  static void showSuccess(BuildContext context, String message) {
    NotificationManager().show(
      context: context,
      message: message,
      type: NotificationType.success,
      duration: Duration(seconds: 2),
    );
  }

  static void showError(BuildContext context, String message) {
    NotificationManager().show(
      context: context,
      message: message,
      type: NotificationType.error,
      duration: Duration(seconds: 5),
    );
  }

  static void showPersistent(BuildContext context, String message) {
    NotificationManager().show(
      context: context,
      message: message,
      type: NotificationType.info,
      duration: Duration(minutes: 5),  // Very long duration
    );
  }

  static void clearAll() {
    NotificationManager().clear();
  }
}
```

### Notification Positioning

Notifications appear in the top-right corner by default:

```dart
// Default position (top-right)
Positioned(
  top: 50,
  right: 20,
  child: NotificationOverlay(...),
)
```

To customize positioning, you would need to modify the NotificationOverlay widget.

## String Utilities

### Case Transformations

```dart
// To camel case
Strings.toCamelCase('hello_world');       // "HelloWorld"
Strings.toCamelCase('hello-world');       // "HelloWorld"
Strings.toCamelCase('hello world');       // "HelloWorld"
Strings.toCamelCase('hello_world', lower: true);  // "helloWorld"

// To snake case
Strings.toSnakeCase('HelloWorld');        // "hello_world"
Strings.toSnakeCase('helloWorld');        // "hello_world"

// To proper case
Strings.toProperCase('hello world');      // "Hello World"
Strings.toProperCase('HELLO WORLD');      // "Hello World"

// Capitalize first letter
Strings.toCapitalised('hello');           // "Hello"
```

### Validation

```dart
// Blank check (null, empty, or whitespace-only)
Strings.isBlank(null);      // true
Strings.isBlank('');        // true
Strings.isBlank('  ');      // true
Strings.isBlank('hello');   // false

// Numeric check
Strings.isNumeric('123');       // true
Strings.isNumeric('123.45');    // true
Strings.isNumeric('abc');       // false
Strings.isNumeric('12.34.56');  // false

// ASCII check
Strings.isAscii('hello');       // true
Strings.isAscii('hello 世界');   // false

// Case checks
Strings.isUpperCase('HELLO');   // true
Strings.isUpperCase('Hello');   // false
Strings.isLowerCase('hello');   // true
Strings.isLowerCase('Hello');   // false

// Starting case checks
Strings.startsWithUpperCase('Hello');  // true
Strings.startsWithLowerCase('hello');  // true
```

### String Manipulation

```dart
// Abbreviate
Strings.abbreviate('Hello World', 8);     // "Hello..."
Strings.abbreviate('Hello', 10);          // "Hello"

// Reverse
Strings.reverse('hello');                 // "olleh"

// Extract portions
Strings.left('hello', 3);                 // "hel"
Strings.right('hello', 3);                // "llo"
Strings.left('ab', 5, pad: Pad.left);     // "   ab"
Strings.right('ab', 5, pad: Pad.right);   // "ab   "

// Escape special characters
Strings.toEscape('Hello\n"World"');       // Escapes \n and quotes
Strings.toPrintable('Hello\nWorld');      // Makes printable

// Case-insensitive comparison
Strings.equalsIgnoreCase('Hello', 'hello');  // true
Strings.equalsIgnoreCase('Hello', 'world');  // false
```

### Padding Enum

```dart
enum Pad {
  none,   // No padding
  left,   // Pad on left
  right,  // Pad on right
}

// Usage
Strings.left('ab', 5, pad: Pad.left);   // "   ab"
Strings.right('ab', 5, pad: Pad.right); // "ab   "
```

## Examples

### Binary Calculator Display

```dart
class BinaryCalculator extends StatefulWidget {
  @override
  _BinaryCalculatorState createState() => _BinaryCalculatorState();
}

class _BinaryCalculatorState extends State<BinaryCalculator> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildDisplay('DEC', Radix.dec(value)),
              _buildDisplay('HEX', Radix.hex(value)),
              _buildDisplay('OCT', Radix.oct(value)),
              _buildDisplay('BIN', Radix.bin(value)),
            ],
          ),
        ),
        16.height,
        Row(
          children: [
            ElevatedButton(
              onPressed: () => setState(() => value++),
              child: Text('+1'),
            ),
            8.width,
            ElevatedButton(
              onPressed: () => setState(() => value--),
              child: Text('-1'),
            ),
            8.width,
            ElevatedButton(
              onPressed: () => setState(() => value = 0),
              child: Text('Clear'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDisplay(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Word.tertiary(label),
          Word(
            value,
            fontFamily: Fonts.jetBrainsMono,
          ),
        ],
      ),
    );
  }
}
```

### Form Validator

```dart
class FormValidator {
  static String? validateField(
    String? value, {
    required String fieldName,
    bool required = true,
    int? minLength,
    int? maxLength,
    bool mustBeNumeric = false,
    bool mustBeAscii = false,
  }) {
    // Required check
    if (required && Strings.isBlank(value)) {
      return '$fieldName is required';
    }

    if (Strings.isNotBlank(value)) {
      // Length checks
      if (minLength != null && value!.length < minLength) {
        return '$fieldName must be at least $minLength characters';
      }

      if (maxLength != null && value!.length > maxLength) {
        return '$fieldName must be at most $maxLength characters';
      }

      // Numeric check
      if (mustBeNumeric && !Strings.isNumeric(value!)) {
        return '$fieldName must be numeric';
      }

      // ASCII check
      if (mustBeAscii && !Strings.isAscii(value!)) {
        return '$fieldName must contain only ASCII characters';
      }
    }

    return null;
  }
}

// Usage
TextField(
  decoration: InputDecoration(
    labelText: 'Username',
    errorText: FormValidator.validateField(
      usernameController.text,
      fieldName: 'Username',
      minLength: 3,
      maxLength: 20,
      mustBeAscii: true,
    ),
  ),
)
```

### Notification Center

```dart
class NotificationCenter extends StatefulWidget {
  @override
  _NotificationCenterState createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  void _showRandomNotification() {
    final types = NotificationType.values;
    final messages = [
      'Operation completed successfully',
      'Warning: Check your settings',
      'Error: Something went wrong',
      'Information: New update available',
    ];

    final random = DateTime.now().millisecondsSinceEpoch % types.length;

    NotificationManager().show(
      context: context,
      message: messages[random],
      type: types[random],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Word.primary('Notification Center'),
        24.height,
        ElevatedButton(
          onPressed: _showRandomNotification,
          child: Text('Show Random Notification'),
        ),
        16.height,
        ElevatedButton(
          onPressed: () => context.notify('Info message'),
          child: Text('Show Info'),
        ),
        8.height,
        ElevatedButton(
          onPressed: () => context.warn('Warning message'),
          child: Text('Show Warning'),
        ),
        8.height,
        ElevatedButton(
          onPressed: () => context.fail('Error message'),
          child: Text('Show Error'),
        ),
        24.height,
        TextButton(
          onPressed: () => NotificationManager().clear(),
          child: Text('Clear All'),
        ),
      ],
    );
  }
}
```

## Best Practices

### Radix Usage

```dart
// ✅ Good: Use helper methods for common bases
final hex = Radix.hex(255);
final bin = Radix.bin(255);

// ❌ Avoid: Manual conversion when helpers exist
final hex = Radix.base(255, Bases.b16);  // Use Radix.hex instead
```

### Notifications

```dart
// ✅ Good: Use appropriate types
context.notify('Saved successfully');  // For success
context.fail('Network error');         // For errors

// ✅ Good: Clear notifications when navigating
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => NewScreen()),
).then((_) => NotificationManager().clear());

// ❌ Avoid: Too many simultaneous notifications
for (int i = 0; i < 10; i++) {
  context.notify('Message $i');  // Overwhelming
}
```

### String Utilities

```dart
// ✅ Good: Use extension methods for convenience
if (text.isNotBlank()) {
  // Process text
}

// ✅ Good: Use Strings class for reusable logic
String formatName(String? name) {
  return Strings.toProperCase(name ?? 'Unknown');
}

// ❌ Avoid: Manual null checks when utilities exist
if (text != null && text.isNotEmpty && text.trim().isNotEmpty) {
  // Use isNotBlank instead
}
```

## Related Documentation

- [Radix Details](radix.md)
- [Notifications Details](notifications.md)
- [Strings Details](strings.md)
- [Extensions](../extensions/README.md)
