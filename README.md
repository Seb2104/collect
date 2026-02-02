# willow_data

A comprehensive Flutter utility package providing reusable UI components, string manipulation utilities, color management, and theming support.

## Features

### String Utilities
The `Strings` library provides null-safe string manipulation with over 50 utility methods:
- Safe operations that gracefully handle null values without throwing exceptions
- String transformations: `toCamelCase`, `toSnakeCase`, `toProperCase`
- String validation: `isBlank`, `isEmpty`, `isNumeric`, `isDigits`
- String parts: `abbreviate`, `left`, `right`, `within`, `hidePart`
- All standard String methods with null-safe wrappers

```dart
import 'package:willow_data/src/lib_strings.dart';

// Handles null gracefully
Strings.toUpperCase(null); // Returns empty string
Strings.substring(null, 2, 3); // Returns ' '

// String transformations
Strings.toCamelCase("hello_world"); // Returns "helloWorld"
Strings.toSnakeCase("HelloWorld"); // Returns "hello_world"
```

### Color Management
Type-safe color manipulation with the `Colour` library:
- ARGB color model with immutable operations
- Color transformation utilities
- Radix color system support

```dart
import 'package:willow_data/src/lib_colour.dart';

final color = Colour(alpha: 1.0, red: 0.5, green: 0.3, blue: 0.8);
final modified = color.withAlpha(0.5);
```

### Material 3 Theme
Pre-configured sage-themed color scheme with light and dark modes:
- Material 3 design system support
- Elegant sage, terracotta, and lavender color palette
- Table-specific theming utilities
- Responsive theme helpers

```dart
import 'package:willow_data/app_theme.dart';

MaterialApp(
  theme: AppTheme.darkTheme(),
  // ...
);

// Access theme colors
final textColor = AppTheme.textPrimary(context);
final borderColor = AppTheme.border(context);
```

### Reusable Widgets
Collection of Flutter widgets for willow_data UI patterns:
- `ActionIcon` - Icon buttons with hover states
- `Menu` components - Custom dropdown menus
- `Sidebar` - Collapsible navigation sidebar
- `TabView` - Custom tab navigation
- `Word` - Text rendering with special formatting

### Number Extensions
Responsive sizing utilities with `SizeConfig` for adaptive layouts.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  willow_data: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

Import the libraries you need:

```dart
import 'package:willow_data/src/lib_strings.dart';
import 'package:willow_data/src/lib_colour.dart';
import 'package:willow_data/src/lib_widgets.dart';
import 'package:willow_data/app_theme.dart';
```

## Platform Support

- Android
- Windows
- iOS (planned)
- macOS (planned)
- Linux (planned)
- Web (planned)

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
