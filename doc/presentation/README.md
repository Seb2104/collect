# Presentation Widgets

The Collect package provides a comprehensive set of presentation widgets designed for building beautiful, consistent UIs with Material 3 theming.

## Overview

| Widget | Purpose | Key Features |
|--------|---------|--------------|
| [AppTheme](app_theme.md) | Material 3 theme system | Light/dark themes, color schemes, comprehensive theming |
| [Word](word.md) | Enhanced text widget | Theme-aware styling, custom fonts, multiple variants |
| [ActionIcon](action_icon.md) | Interactive icon button | Tooltips, hover effects, active states |
| [Menu](menu.md) | Advanced dropdown menu | Search, filter, keyboard navigation |
| [TabView](tab_view.md) | Customizable tab navigation | All-side placement, animations, flexible layouts |
| [HoverWidget](hover_widget.md) | Hover state detection | Web-friendly hover detection |
| [RoundedCheckBox](rounded_checkbox.md) | Styled checkbox | Customizable appearance, animations |
| [StyledBox](box.md) | Advanced decorations | Inset shadows, complex borders |

## Quick Start

### AppTheme - Material 3 Theming

```dart
MaterialApp(
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: ThemeMode.system,
  home: MyApp(),
)

// Access theme colors
Container(
  color: AppTheme.surface(context),
  child: Text(
    'Themed text',
    style: TextStyle(color: AppTheme.textPrimary(context)),
  ),
)
```

### Word - Enhanced Text

```dart
// Variants
Word('Regular text')
Word.primary('Large heading text')
Word.secondary('Medium subtitle text')
Word.tertiary('Small caption text')

// Custom styling
Word(
  'Custom',
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.blue,
  fontFamily: Fonts.montserrat,
)
```

### ActionIcon - Interactive Icons

```dart
ActionIcon(
  icon: Icons.favorite,
  tooltip: 'Like',
  onTap: () => print('Liked!'),
  isActive: isLiked,
  enabled: true,
)
```

### Menu - Dropdown Menu

```dart
Menu<String>(
  hintText: 'Select option',
  items: [
    MenuEntry(value: 'option1', label: 'Option 1'),
    MenuEntry(value: 'option2', label: 'Option 2'),
    MenuEntry(value: 'option3', label: 'Option 3'),
  ],
  onSelected: (value) => print('Selected: $value'),
  enableSearch: true,
  enableFilter: true,
)
```

### TabView - Tab Navigation

```dart
TabView(
  tabPosition: Side.top,
  indicator: true,
  content: TabViewContent([
    TabViewItem('Home', view: HomeScreen()),
    TabViewItem('Profile', view: ProfileScreen()),
    TabViewItem('Settings', view: SettingsScreen()),
  ]),
)
```

### RoundedCheckBox - Styled Checkbox

```dart
RoundedCheckBox(
  text: 'I agree to terms',
  isChecked: agreedToTerms,
  onTap: (value) => setState(() => agreedToTerms = value!),
  checkedColor: AppTheme.primarySage,
)
```

## Design System

### Color Palette

The AppTheme provides a carefully crafted color palette:

```dart
// Primary colors
AppTheme.primarySage          // #9CAF88
AppTheme.secondaryTerracotta  // #D4B5A0
AppTheme.lavenderMist         // #CBBFD4

// Accent colors
AppTheme.accentGold     // #E6D5B8
AppTheme.accentSuccess  // #88B584
AppTheme.accentWarning  // #E5BD8F
AppTheme.accentError    // #D49490

// Light theme colors
AppTheme.lightBackground     // #F5F3EE
AppTheme.lightSurface        // #FFFDFA
AppTheme.lightTextPrimary    // #3A3731
AppTheme.lightTextSecondary  // #6B6560

// Dark theme colors
AppTheme.darkBackground      // #2A2825
AppTheme.darkSurface         // #1F1D1A
AppTheme.darkTextPrimary     // #F8F6F3
AppTheme.darkTextSecondary   // #C8C1B8
```

### Typography

Word widget provides semantic text styles:

```dart
// Heading
Word.primary('Heading')
  // fontSize: 28
  // fontWeight: FontWeight.bold

// Subtitle
Word.secondary('Subtitle')
  // Uses secondary text color

// Caption
Word.tertiary('Caption')
  // Uses tertiary text color
  // Lower emphasis
```

### Spacing System

Recommended spacing values:

```dart
4.height   // Extra tight
8.height   // Tight
12.height  // Compact
16.height  // Standard
24.height  // Comfortable
32.height  // Loose
48.height  // Extra loose
```

### Font Families

Available through the `Fonts` enum:

```dart
Fonts.timesNewRoman  // Default
Fonts.montserrat     // Modern sans-serif
Fonts.lato           // Clean sans-serif
Fonts.roboto         // Google's Roboto
Fonts.inter          // UI-focused
Fonts.jetBrainsMono  // Monospace for code
Fonts.lora           // Elegant serif
// ... and many more
```

## Layout Patterns

### Card with Header

```dart
Card(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Header
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated(context),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.info),
            12.width,
            Word.primary('Card Title').expand(),
            ActionIcon(
              icon: Icons.more_vert,
              tooltip: 'Options',
              onTap: () {},
            ),
          ],
        ),
      ),

      // Content
      Padding(
        padding: EdgeInsets.all(16),
        child: Word('Card content goes here'),
      ),
    ],
  ),
).cornerRadiusWithClipRRect(12);
```

### Form Section

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Word.primary('Personal Information'),
    16.height,
    TextField(
      decoration: InputDecoration(
        labelText: 'Full Name',
        prefixIcon: Icon(Icons.person),
      ),
    ),
    12.height,
    TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
      ),
    ),
    12.height,
    RoundedCheckBox(
      text: 'Subscribe to newsletter',
      isChecked: subscribed,
      onTap: (value) => setState(() => subscribed = value!),
    ),
  ],
).paddingAll(16);
```

### Action Bar

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    color: AppTheme.surface(context),
    border: Border(
      bottom: BorderSide(
        color: AppTheme.border(context),
      ),
    ),
  ),
  child: Row(
    children: [
      Word.secondary('Actions').expand(),
      ActionIcon(
        icon: Icons.edit,
        tooltip: 'Edit',
        onTap: () {},
      ),
      8.width,
      ActionIcon(
        icon: Icons.delete,
        tooltip: 'Delete',
        onTap: () {},
      ),
      8.width,
      ActionIcon(
        icon: Icons.share,
        tooltip: 'Share',
        onTap: () {},
      ),
    ],
  ),
);
```

### Stat Card

```dart
Container(
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: AppTheme.surface(context),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppTheme.border(context),
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(
        Icons.trending_up,
        color: AppTheme.success(context),
        size: 32,
      ),
      12.height,
      Word(
        '1,234',
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      4.height,
      Word.tertiary('Total Users'),
      8.height,
      Row(
        children: [
          Icon(
            Icons.arrow_upward,
            size: 16,
            color: AppTheme.success(context),
          ),
          4.width,
          Word(
            '+12.5%',
            color: AppTheme.success(context),
            fontSize: 14,
          ),
        ],
      ),
    ],
  ),
);
```

## Component Composition

### Building Complex UIs

```dart
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final bool isPositive;

  DashboardCard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor = isPositive
        ? AppTheme.success(context)
        : AppTheme.error(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24).expand(),
                ActionIcon(
                  icon: Icons.more_horiz,
                  tooltip: 'Options',
                  onTap: () {},
                ),
              ],
            ),
            16.height,
            Word(
              value,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            4.height,
            Word.tertiary(title),
            12.height,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: changeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    size: 14,
                    color: changeColor,
                  ),
                  4.width,
                  Word(
                    change,
                    color: changeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).cornerRadiusWithClipRRect(12);
  }
}
```

## Best Practices

### Theme Consistency

```dart
// ✅ Good: Use theme colors
Container(
  color: AppTheme.surface(context),
  child: Text(
    'Text',
    style: TextStyle(color: AppTheme.textPrimary(context)),
  ),
)

// ❌ Avoid: Hard-coded colors
Container(
  color: Color(0xFFF5F3EE),  // Won't adapt to dark mode
  child: Text(
    'Text',
    style: TextStyle(color: Color(0xFF3A3731)),
  ),
)
```

### Widget Reusability

```dart
// ✅ Good: Create reusable components
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMoreTap;

  SectionHeader({required this.title, this.onMoreTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Word.primary(title).expand(),
        if (onMoreTap != null)
          ActionIcon(
            icon: Icons.more_horiz,
            tooltip: 'More',
            onTap: onMoreTap,
          ),
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 8);
  }
}
```

### Accessibility

```dart
// ✅ Good: Include tooltips and semantic labels
ActionIcon(
  icon: Icons.delete,
  tooltip: 'Delete item',  // Screen reader support
  onTap: onDelete,
)

Word(
  'Important message',
  semanticsLabel: 'Important: message content',
)
```

### Performance

```dart
// ✅ Good: Use const constructors
const Word('Static text')

// ✅ Good: Extract expensive widgets
class _ExpensiveWidget extends StatelessWidget {
  const _ExpensiveWidget();

  @override
  Widget build(BuildContext context) {
    return /* complex widget tree */;
  }
}
```

## Related Documentation

- [AppTheme Details](app_theme.md)
- [Word Widget](word.md)
- [ActionIcon Widget](action_icon.md)
- [Menu Widget](menu.md)
- [TabView Widget](tab_view.md)
- [Examples](../examples/README.md)
