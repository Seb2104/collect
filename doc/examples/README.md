# Examples

This section contains comprehensive, real-world examples demonstrating how to use the Collect package effectively.

## Table of Contents

- [Complete App Examples](#complete-app-examples)
- [UI Patterns](#ui-patterns)
- [Data Management](#data-management)
- [Utilities](#utilities)

## Complete App Examples

### Todo App with Deadlines

```dart
import 'package:flutter/material.dart';
import 'package:collect/collect.dart';

class TodoItem {
  final String id;
  final String title;
  final String description;
  final Moment deadline;
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.isCompleted = false,
  });

  bool get isOverdue => !isCompleted && Moment.now() > deadline;
  String get timeRemaining => deadline.timeAgo();
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final List<TodoItem> _todos = [];

  void _addTodo(TodoItem todo) {
    setState(() => _todos.add(todo));
    context.notify('Todo added: ${todo.title}');
  }

  void _toggleTodo(String id) {
    setState(() {
      final todo = _todos.firstWhere((t) => t.id == id);
      todo.isCompleted = !todo.isCompleted;
    });
  }

  void _deleteTodo(String id) {
    setState(() => _todos.removeWhere((t) => t.id == id));
    context.notify('Todo deleted');
  }

  @override
  Widget build(BuildContext context) {
    final overdue = _todos.where((t) => t.isOverdue).toList();
    final upcoming = _todos.where((t) => !t.isOverdue && !t.isCompleted).toList();
    final completed = _todos.where((t) => t.isCompleted).toList();

    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Word.primary('My Todos'),
          actions: [
            ActionIcon(
              icon: Icons.add,
              tooltip: 'Add Todo',
              onTap: () => _showAddTodoDialog(context),
            ).paddingRight(8),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            if (overdue.isNotEmpty) ...[
              Word.secondary('Overdue (${overdue.length})')
                  .paddingBottom(8),
              ...overdue.map((todo) => _buildTodoCard(todo, isOverdue: true)),
              16.height,
            ],
            if (upcoming.isNotEmpty) ...[
              Word.secondary('Upcoming (${upcoming.length})')
                  .paddingBottom(8),
              ...upcoming.map((todo) => _buildTodoCard(todo)),
              16.height,
            ],
            if (completed.isNotEmpty) ...[
              Word.secondary('Completed (${completed.length})')
                  .paddingBottom(8),
              ...completed.map((todo) => _buildTodoCard(todo, isCompleted: true)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTodoCard(TodoItem todo, {bool isOverdue = false, bool isCompleted = false}) {
    final cardColor = isOverdue
        ? AppTheme.error(context).withValues(alpha: 0.1)
        : isCompleted
            ? AppTheme.success(context).withValues(alpha: 0.1)
            : AppTheme.surface(context);

    return Card(
      color: cardColor,
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: RoundedCheckBox(
          isChecked: todo.isCompleted,
          onTap: (value) => _toggleTodo(todo.id),
        ),
        title: Word(
          todo.title,
          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description.isNotEmpty)
              Word.tertiary(todo.description).paddingTop(4),
            Word.tertiary(
              '${isOverdue ? "Overdue: " : "Due: "}${todo.timeRemaining}',
            ).paddingTop(4),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () => _deleteTodo(todo.id),
        ),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    Moment? selectedDeadline;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Word.primary('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              16.height,
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              16.height,
              ListTile(
                title: Word('Deadline'),
                subtitle: Word.tertiary(
                  selectedDeadline?.format([MM, '/', DD, '/', yyyy, space, hh, colon, mm, space, A]) ??
                      'Not set',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(365.days),
                  );

                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (time != null) {
                      setDialogState(() {
                        selectedDeadline = Moment.fromDateTime(
                          DateTime(date.year, date.month, date.day, time.hour, time.minute),
                        );
                      });
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && selectedDeadline != null) {
                  _addTodo(TodoItem(
                    id: Moment.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    description: descriptionController.text,
                    deadline: selectedDeadline!,
                  ));
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Theme Customization App

```dart
import 'package:flutter/material.dart';
import 'package:collect/collect.dart';

class ThemeCustomizerApp extends StatefulWidget {
  @override
  _ThemeCustomizerAppState createState() => _ThemeCustomizerAppState();
}

class _ThemeCustomizerAppState extends State<ThemeCustomizerApp> {
  Colour primaryColor = Colour.fromHex(hexString: '#9CAF88');
  bool isDarkMode = false;

  void _changePrimaryColor(Colour newColor) {
    setState(() => primaryColor = newColor);
  }

  ThemeData _buildTheme(Brightness brightness) {
    final baseTheme = brightness == Brightness.light
        ? AppTheme.light()
        : AppTheme.dark();

    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: primaryColor.color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Word.primary('Theme Customizer'),
          actions: [
            ActionIcon(
              icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
              tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
              onTap: () => setState(() => isDarkMode = !isDarkMode),
            ).paddingRight(8),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildColorPreview(),
            24.height,
            _buildPresetColors(),
            24.height,
            _buildComponentPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPreview() {
    return Card(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: primaryColor.color,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Word('Primary Color', color: Colors.white, fontSize: 24),
                  8.height,
                  Word(primaryColor.hex, color: Colors.white, fontSize: 16),
                  Word(primaryColor.rgb, color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Word.secondary('Color Information'),
                8.height,
                _buildColorInfo('Hex', '#${primaryColor.hex}'),
                _buildColorInfo('RGB', primaryColor.rgb),
                _buildColorInfo('Opacity', '${(primaryColor.opacity * 100).toStringAsFixed(0)}%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Word.tertiary(label),
          Word(value, fontFamily: Fonts.jetBrainsMono),
        ],
      ),
    );
  }

  Widget _buildPresetColors() {
    final presets = [
      ('Sage', '#9CAF88'),
      ('Terracotta', '#D4B5A0'),
      ('Gold', '#E6D5B8'),
      ('Coral', '#E5C4B5'),
      ('Lavender', '#CBBFD4'),
      ('Blue', '#4A90E2'),
      ('Green', '#88B584'),
      ('Purple', '#9B59B6'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Word.secondary('Preset Colors'),
        16.height,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: presets.map((preset) {
            final color = Colour.fromHex(hexString: preset.$2);
            final isSelected = color == primaryColor;

            return GestureDetector(
              onTap: () => _changePrimaryColor(color),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.textPrimary(context)
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Word(
                    preset.$1,
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildComponentPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Word.secondary('Component Preview'),
        16.height,
        ElevatedButton(
          onPressed: () => context.notify('Button pressed!'),
          child: Text('Primary Button'),
        ),
        8.height,
        TextButton(
          onPressed: () {},
          child: Text('Text Button'),
        ),
        8.height,
        TextField(
          decoration: InputDecoration(
            labelText: 'Text Field',
            hintText: 'Enter text...',
          ),
        ),
        16.height,
        RoundedCheckBox(
          text: 'Checkbox with custom theme',
          isChecked: true,
          checkedColor: primaryColor.color,
          onTap: (value) {},
        ),
      ],
    );
  }
}
```

## UI Patterns

### Responsive Card Grid

```dart
class ResponsiveCardGrid extends StatelessWidget {
  final List<String> items;

  ResponsiveCardGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, size: 40.dynamicWidth),
              8.height,
              Word(items[index]).paddingSymmetric(horizontal: 8),
            ],
          ),
        ).cornerRadiusWithClipRRect(12);
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }
}
```

### Loading States with Opacity

```dart
class LoadingCard extends StatefulWidget {
  final Future<String> dataFuture;

  LoadingCard({required this.dataFuture});

  @override
  _LoadingCardState createState() => _LoadingCardState();
}

class _LoadingCardState extends State<LoadingCard> {
  bool _isLoading = true;
  String? _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await widget.dataFuture;
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      context.fail('Failed to load data');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: _data != null
                ? Word(_data!)
                : Word.tertiary('No data'),
          ).opacity(opacity: _isLoading ? 0.3 : 1.0),

          // Loading indicator
          if (_isLoading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    ).withSize(width: 200, height: 150);
  }
}
```

### Animated Tab View

```dart
class AnimatedTabExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabView(
      tabPosition: Side.top,
      animationDuration: Duration(milliseconds: 300),
      indicator: true,
      content: TabViewContent([
        TabViewItem(
          'Home',
          view: _buildHomeTab(),
        ),
        TabViewItem(
          'Profile',
          view: _buildProfileTab(),
        ),
        TabViewItem(
          'Settings',
          view: _buildSettingsTab(),
        ),
      ]),
    );
  }

  Widget _buildHomeTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 64),
          16.height,
          Word.primary('Welcome Home!'),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
        16.height,
        Word.primary('John Doe').center(),
        Word.tertiary('john.doe@example.com').center(),
      ],
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.notifications),
          title: Word('Notifications'),
          trailing: Switch(value: true, onChanged: (v) {}),
        ),
        ListTile(
          leading: Icon(Icons.dark_mode),
          title: Word('Dark Mode'),
          trailing: Switch(value: false, onChanged: (v) {}),
        ),
      ],
    );
  }
}
```

## Data Management

### Date Formatting Utility

```dart
class DateFormatter {
  static String format(Moment moment, DateFormat format) {
    switch (format) {
      case DateFormat.short:
        return moment.format([MM, '/', DD, '/', yy]);
      case DateFormat.medium:
        return moment.format([MMM, space, D, comma, space, yyyy]);
      case DateFormat.long:
        return moment.format([mmmm, space, Do, comma, space, yyyy]);
      case DateFormat.full:
        return moment.format([dddd, comma, space, mmmm, space, Do, comma, space, yyyy]);
      case DateFormat.iso:
        return moment.format([yyyy, dash, MM, dash, DD]);
      case DateFormat.time12:
        return moment.clock;
      case DateFormat.time24:
        return moment.time;
    }
  }

  static List<String> getAllFormats(Moment moment) {
    return DateFormat.values.map((format) {
      return format(moment, format);
    }).toList();
  }
}

enum DateFormat {
  short,   // 02/03/26
  medium,  // Feb 3, 2026
  long,    // February 3rd, 2026
  full,    // Tuesday, February 3rd, 2026
  iso,     // 2026-02-03
  time12,  // 2:30:45 PM
  time24,  // 14:30:45
}
```

### Color Palette Generator

```dart
class ColorPaletteGenerator {
  static List<Colour> generateAnalogous(Colour base, {int count = 5}) {
    final hsv = base.toHSV(base);
    final colors = <Colour>[];
    final step = 30 / count;

    for (int i = 0; i < count; i++) {
      final hue = (hsv.hue + (i * step - 15)) % 360;
      colors.add(Colour.fromHSVColour(
        hsvColour: HSVColor.fromAHSV(
          hsv.alpha,
          hue,
          hsv.saturation,
          hsv.value,
        ),
      ));
    }

    return colors;
  }

  static List<Colour> generateComplementary(Colour base) {
    final hsv = base.toHSV(base);
    return [
      base,
      Colour.fromHSVColour(
        hsvColour: HSVColor.fromAHSV(
          hsv.alpha,
          (hsv.hue + 180) % 360,
          hsv.saturation,
          hsv.value,
        ),
      ),
    ];
  }

  static List<Colour> generateTriadic(Colour base) {
    final hsv = base.toHSV(base);
    return [
      base,
      Colour.fromHSVColour(
        hsvColour: HSVColor.fromAHSV(
          hsv.alpha,
          (hsv.hue + 120) % 360,
          hsv.saturation,
          hsv.value,
        ),
      ),
      Colour.fromHSVColour(
        hsvColour: HSVColor.fromAHSV(
          hsv.alpha,
          (hsv.hue + 240) % 360,
          hsv.saturation,
          hsv.value,
        ),
      ),
    ];
  }

  static List<Colour> generateShades(Colour base, {int count = 5}) {
    final colors = <Colour>[];
    for (int i = 0; i < count; i++) {
      final opacity = 1.0 - (i / (count - 1)) * 0.8;
      colors.add(base.withOpacity(opacity));
    }
    return colors;
  }
}
```

## Utilities

### String Validation Utils

```dart
class StringValidation {
  static String? validateEmail(String? email) {
    if (email.isBlank()) {
      return 'Email is required';
    }
    if (!email!.contains('@') || !email.contains('.')) {
      return 'Invalid email format';
    }
    if (!email.isAscii()) {
      return 'Email must contain only ASCII characters';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password.isBlank()) {
      return 'Password is required';
    }
    if (password!.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (password.isLowerCase() || password.isUpperCase()) {
      return 'Password must contain both upper and lowercase letters';
    }
    return null;
  }

  static String? validateUsername(String? username) {
    if (username.isBlank()) {
      return 'Username is required';
    }
    if (username!.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (!username.isAscii()) {
      return 'Username must contain only ASCII characters';
    }
    return null;
  }
}
```

### Number Formatting Utils

```dart
class NumberFormatting {
  static String formatCurrency(num amount, {String symbol = '\$'}) {
    return '$symbol${amount.toDoubleDigits(2)}';
  }

  static String formatPercentage(num value, num total) {
    if (total.isZero) return '0%';
    final percentage = value.percentageOf(total);
    return '${percentage.roundToPrecision(1)}%';
  }

  static String formatFileSize(num bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).roundToPrecision(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).roundToPrecision(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).roundToPrecision(1)}GB';
  }

  static String formatCount(num count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).roundToPrecision(1)}K';
    return '${(count / 1000000).roundToPrecision(1)}M';
  }
}
```

## Related

- [Getting Started](../getting-started.md)
- [Data Types](../datatypes/README.md)
- [Extensions](../extensions/README.md)
- [Presentation](../presentation/README.md)
