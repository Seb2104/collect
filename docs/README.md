# Collect Documentation

Welcome to the comprehensive documentation for the **Collect** Flutter package! This package provides a rich collection of reusable UI components, type extensions, custom data types, and Material 3 theming support.

## Table of Contents

1. [Getting Started](getting-started.md)
2. [Data Types](datatypes/README.md)
   - [Colour](datatypes/colour.md) - Advanced color manipulation
   - [Moment](datatypes/moment.md) - DateTime wrapper with enhanced features
   - [Period](datatypes/period.md) - Time duration management
3. [Extensions](extensions/README.md)
   - [Int Extensions](extensions/int.md)
   - [Double Extensions](extensions/double.md)
   - [Num Extensions](extensions/num.md)
   - [String Extensions](extensions/string.md)
   - [Widget Extensions](extensions/widget.md)
   - [List Extensions](extensions/list.md)
   - [BuildContext Extensions](extensions/build_context.md)
4. [Presentation Widgets](presentation/README.md)
   - [AppTheme](presentation/app_theme.md) - Material 3 theming system
   - [Word](presentation/word.md) - Enhanced text widget
   - [ActionIcon](presentation/action_icon.md) - Interactive icon button
   - [Menu](presentation/menu.md) - Advanced dropdown menu
   - [TabView](presentation/tab_view.md) - Customizable tab navigation
   - [HoverWidget](presentation/hover_widget.md) - Hover detection
   - [RoundedCheckBox](presentation/rounded_checkbox.md) - Styled checkbox
   - [StyledBox](presentation/box.md) - Advanced box decoration
5. [Utilities](utilities/README.md)
   - [Radix](utilities/radix.md) - Base conversion utilities
   - [Notifications](utilities/notifications.md) - Toast notification system
6. [Examples](examples/README.md)

## Quick Start

```dart
import 'package:collect/collect.dart';

// Use enhanced data types
final moment = Moment.now();
final colour = Colour.fromHex(hexString: '#9CAF88');

// Use extensions
final duration = 5.seconds;
final isValid = 100.isBetween(50, 150);

// Use widgets
Word.primary('Hello World'),
ActionIcon(
  icon: Icons.check,
  tooltip: 'Confirm',
  onTap: () {},
),
```

## Features

### Custom Data Types
- **Colour**: Advanced color class with multiple construction methods (RGB, HSL, HSV, Hex)
- **Moment**: DateTime replacement with formatting, time ago, and date arithmetic
- **Period**: Duration management with year/month/day support

### Type Extensions
- Rich extensions for `int`, `double`, `num`, `String`, `Widget`, `List`, and `BuildContext`
- Convenient helpers for common operations
- Chainable methods for clean code

### UI Components
- Material 3 themed widgets
- Customizable dropdown menus
- Tab navigation system
- Notification overlays
- Styled checkboxes and more

### Utilities
- Base conversion (binary, octal, decimal, hexadecimal, and beyond)
- Toast notification system
- String manipulation utilities

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  collect: ^1.2.0
```

Then run:

```bash
flutter pub get
```

## Requirements

- Dart SDK: `^3.10.1`
- Flutter: `>=3.3.0`

## License

This package is licensed under the Apache License 2.0.
