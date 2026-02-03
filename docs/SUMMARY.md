# Documentation Summary

This document provides a complete overview of all available documentation for the Collect package.

## Documentation Structure

```
docs/
├── README.md                          # Main documentation index
├── getting-started.md                 # Installation and first steps
├── SUMMARY.md                         # This file
│
├── datatypes/                         # Custom data types
│   ├── README.md                     # Datatypes overview
│   ├── colour.md                     # Colour class (50+ pages)
│   ├── moment.md                     # Moment class (40+ pages)
│   └── period.md                     # Period class (30+ pages)
│
├── extensions/                        # Type extensions
│   └── README.md                     # Extensions overview
│
├── presentation/                      # UI widgets
│   └── README.md                     # Widgets overview
│
├── utilities/                         # Utility classes
│   └── README.md                     # Utilities overview
│
└── examples/                          # Real-world examples
    └── README.md                     # Complete app examples
```

## Quick Navigation

### For Beginners

Start here if you're new to Collect:

1. **[Getting Started](getting-started.md)** - Installation, basic concepts, first steps
2. **[Examples](examples/README.md)** - See real-world usage patterns
3. **[Data Types Overview](datatypes/README.md)** - Understand custom types
4. **[Extensions Overview](extensions/README.md)** - Discover available extensions

### By Feature

#### Working with Colors

- **[Colour Data Type](datatypes/colour.md)** - Complete color management
  - RGB, HSL, HSV color spaces
  - Hex, percentage, fraction conversions
  - Color manipulation and properties
  - 20+ construction methods
  - Examples and best practices

#### Working with Dates & Times

- **[Moment Data Type](datatypes/moment.md)** - Enhanced date/time handling
  - Flexible construction (components, DateTime, strings)
  - 25+ format tokens
  - "Time ago" functionality
  - Date arithmetic with Period
  - Comparison and sorting
  - Real-world examples

- **[Period Data Type](datatypes/period.md)** - Duration management
  - Years, months, days, hours, minutes, seconds
  - Arithmetic operations (+, -, *, negation)
  - Comparison operators
  - Works seamlessly with Moment
  - Countdown timers and recurring events

#### Extending Built-in Types

- **[Extensions Overview](extensions/README.md)** - All extensions
  - Int extensions (durations, spacing, date names)
  - Double extensions (validation, ranges)
  - Num extensions (formatting, calculations)
  - String extensions (transformations, validation)
  - Widget extensions (padding, layout, effects)
  - List extensions (aggregations, indexing)
  - BuildContext extensions (notifications)

#### Building UI

- **[Presentation Widgets](presentation/README.md)** - UI components
  - AppTheme (Material 3 theming)
  - Word (enhanced text)
  - ActionIcon (interactive icons)
  - Menu (advanced dropdown)
  - TabView (flexible tabs)
  - HoverWidget (hover detection)
  - RoundedCheckBox (styled checkbox)
  - StyledBox (advanced decorations)

#### Utilities

- **[Utilities Overview](utilities/README.md)** - Helper classes
  - Radix (base conversion up to base-256)
  - Notifications (toast messages)
  - Strings (text manipulation)

### By Use Case

#### "I want to..."

**Display formatted dates**
→ [Moment formatting](datatypes/moment.md#formatting)
→ [Examples: Date formatting](examples/README.md#data-management)

**Show "time ago" text**
→ [Moment timeAgo](datatypes/moment.md#time-ago)
→ [Examples: Timeline](examples/README.md#event-timeline)

**Work with colors**
→ [Colour construction](datatypes/colour.md#construction)
→ [Colour conversions](datatypes/colour.md#color-spaces)

**Add padding to widgets**
→ [Widget extensions](extensions/README.md#widget-extensions)
→ [Getting started: Widget extensions](getting-started.md#using-extensions)

**Create durations easily**
→ [Int extensions](extensions/README.md#int-extensions)
→ [Period construction](datatypes/period.md#construction)

**Show notifications**
→ [Notifications](utilities/README.md#notification-system)
→ [BuildContext extensions](extensions/README.md#buildcontext-extensions)

**Theme my app**
→ [AppTheme](presentation/README.md#apptheme---material-3-theming)
→ [Getting started: AppTheme](getting-started.md#using-ui-components)

**Validate strings**
→ [String extensions](extensions/README.md#string-extensions)
→ [Utilities: Strings](utilities/README.md#string-utilities)

**Build complex UI**
→ [Examples: Complete apps](examples/README.md#complete-app-examples)
→ [Presentation: Layout patterns](presentation/README.md#layout-patterns)

## Documentation Metrics

### Coverage

- **Data Types**: 3 types, ~120 pages of documentation
- **Extensions**: 7 extension types, comprehensive coverage
- **Widgets**: 8 presentation widgets, full documentation
- **Utilities**: 3 utility classes, detailed examples
- **Examples**: 10+ complete app examples
- **Total**: ~200 pages of documentation

### Content Types

- **Tutorials**: Getting started, usage patterns
- **Reference**: Complete API documentation
- **Examples**: Real-world code samples
- **Best Practices**: Performance tips, patterns to avoid
- **Comparisons**: Collect vs built-in types

## Features by Documentation Page

### Colour (datatypes/colour.md)
- 10+ construction methods
- 3 color space conversions (RGB, HSL, HSV)
- 5+ string format outputs
- Color modification methods
- 15+ examples
- Performance tips

### Moment (datatypes/moment.md)
- 6+ construction methods
- 25+ format tokens
- Time ago with short/long formats
- Date arithmetic operators
- Comparison and sorting
- 10+ examples
- Best practices

### Period (datatypes/period.md)
- Multiple unit construction
- 5+ arithmetic operations
- Comparison operators
- Conversion methods
- 8+ examples
- Limitations documentation

### Extensions (extensions/README.md)
- 50+ extension methods
- Null-safe operations
- Chainable methods
- Performance considerations
- Usage patterns
- Migration guides

### Presentation (presentation/README.md)
- 8 widget types
- Material 3 theming
- Complete color palette
- Typography system
- Layout patterns
- Component composition

### Utilities (utilities/README.md)
- Base conversion (2-256)
- Toast notifications
- String manipulation
- 10+ utility methods
- Best practices

### Examples (examples/README.md)
- 2 complete apps
- 5+ UI patterns
- 3+ data management examples
- 4+ utility examples
- Production-ready code

## Learning Paths

### Path 1: Quick Start (30 minutes)

1. Read [Getting Started](getting-started.md)
2. Try Int extensions: `5.seconds`, `10.height`
3. Try String extensions: `'hello'.toCamelCase()`
4. Try Widget extensions: `.paddingAll(16)`, `.center()`
5. Create a simple UI with Word and AppTheme

### Path 2: Data Types (2 hours)

1. Read [Datatypes Overview](datatypes/README.md)
2. Explore [Colour](datatypes/colour.md)
   - Try different construction methods
   - Convert between formats
3. Explore [Moment](datatypes/moment.md)
   - Create moments
   - Format dates
   - Use timeAgo
4. Explore [Period](datatypes/period.md)
   - Create periods
   - Do date arithmetic
5. Build a birthday countdown widget

### Path 3: Complete App (4 hours)

1. Read [Examples Overview](examples/README.md)
2. Study the Todo App example
3. Study the Theme Customizer example
4. Build your own app combining:
   - AppTheme for theming
   - Word for text
   - Moment for dates
   - Notifications for feedback
   - Extensions for clean code

### Path 4: Advanced Features (2 hours)

1. Read [Utilities Overview](utilities/README.md)
2. Learn Radix for base conversion
3. Explore notification system
4. Study string manipulation
5. Read [Best Practices](#best-practices) sections
6. Review performance tips

## Best Practices Summary

### Performance
- Cache formatted strings
- Convert Colour/Moment once and reuse
- Use const constructors when possible
- Extract expensive widgets

### Code Quality
- Use extensions for cleaner code
- Chain operations for readability
- Prefer semantic over hardcoded values
- Use AppTheme for consistent theming

### Maintenance
- Store colors as hex strings
- Store moments as strings or milliseconds
- Use validation extensions
- Include tooltips for accessibility

## Common Patterns

### Responsive Layout
```dart
SizeConfig().init(context);
Container(
  width: 200.dynamicWidth,
  height: 100.dynamicHeight,
)
```

### Theme-Aware UI
```dart
Container(
  color: AppTheme.surface(context),
  child: Word.primary('Text'),
)
```

### Date Display
```dart
final moment = Moment.now();
Word(moment.format([mmmm, space, Do, comma, space, yyyy]))
```

### Clean Widget Trees
```dart
Text('Hello')
  .paddingAll(16)
  .center()
  .opacity(opacity: 0.8);
```

## Support and Resources

### Getting Help

1. Check the relevant documentation page
2. Search for examples in [Examples](examples/README.md)
3. Review [Getting Started](getting-started.md) troubleshooting
4. Check the package README.md

### Contributing

When contributing examples or improvements:
- Follow existing documentation style
- Include code examples
- Add best practices section
- Update this summary

### Updates

This documentation reflects version 1.2.0 of the Collect package.

Last updated: February 2026
