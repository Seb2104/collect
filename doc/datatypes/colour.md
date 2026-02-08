# Colour

The `Colour` class is an advanced color management system that implements Flutter's `Color` interface while providing
extensive color manipulation, conversion, and formatting capabilities.

## Table of Contents

- [Construction](#construction)
- [Color Spaces](#color-spaces)
- [Properties](#properties)
- [Methods](#methods)
- [Examples](#examples)
- [Best Practices](#best-practices)

## Construction

### From ARGB (Default)

```dart
// All parameters optional, default to white (255, 255, 255, 255)
const white = Colour();
const black = Colour(alpha: 255, red: 0, green: 0, blue: 0);
const sage = Colour(alpha: 255, red: 156, green: 175, blue: 136);
```

### From RGB

```dart
// Alpha defaults to 255 (opaque)
const coral = Colour.fromRGB(
  red: 229,
  green: 196,
  blue: 181,
);
```

### From ARGB with Percentage Opacity

```dart
// Opacity is percentage (0-100), converted to 0-255
final semiTransparent = Colour.fromARGB(
  opacity: 50,  // 50% = 127/255
  red: 156,
  green: 175,
  blue: 136,
);
```

### From Hexadecimal

```dart
// Supports various hex formats
final fromSixDigits = Colour.fromHex(hexString: '9CAF88');    // Assumes FF alpha
final fromEightDigits = Colour.fromHex(hexString: 'FF9CAF88'); // With alpha
final fromThreeDigits = Colour.fromHex(hexString: '9CA');      // Expands to FF99CCAA
final fromFourDigits = Colour.fromHex(hexString: 'F9CA');      // Expands to FF99CCAA
final withHash = Colour.fromHex(hexString: '#9CAF88');         // Hash is stripped
```

### From HSL (Hue, Saturation, Lightness)

```dart
final hslColour = Colour.fromHSL(
  h: 92,      // Hue: 0-360 degrees
  s: 0.22,    // Saturation: 0.0-1.0
  l: 0.61,    // Lightness: 0.0-1.0
);
```

### From HSV (Hue, Saturation, Value)

```dart
final hsvColour = Colour.fromHSV(
  h: 92,      // Hue: 0-360 degrees
  s: 0.22,    // Saturation: 0.0-1.0
  v: 0.69,    // Value: 0.0-1.0
);
```

### From Flutter Color Objects

```dart
final flutterColor = Colors.blue;
final collectColour = Colour.fromColor(flutterColor);

// From HSVColor
final hsvColor = HSVColor.fromColor(Colors.blue);
final colour = Colour.fromHSVColour(hsvColour: hsvColor);

// From HSLColor
final hslColor = HSLColor.fromColor(Colors.blue);
final colour = Colour.fromHSLColour(hslColour: hslColor);
```

### From Fraction (0.0-1.0)

```dart
final fractionalColour = Colour.fromFraction(
  alpha: 1.0,  // Fully opaque
  red: 0.61,   // 156/255
  green: 0.69, // 175/255
  blue: 0.53,  // 136/255
);
```

### From Percentage (0-100)

```dart
final percentColour = Colour.fromPercent(
  a: 100,  // Fully opaque
  r: 61,   // 61% = 156/255
  g: 69,   // 69% = 175/255
  b: 53,   // 53% = 136/255
);
```

### From Base-256 String

```dart
// Used internally for compact storage
final b256String = 'ABCD'; // Each character represents 0-255
final colour = Colour.fromB256(b256String);
```

## Color Spaces

### RGB (Red, Green, Blue)

The primary color space. All colors are stored internally as ARGB values (0-255).

```dart
final colour = Colour(alpha: 255, red: 156, green: 175, blue: 136);
print(colour.red);   // 156
print(colour.green); // 175
print(colour.blue);  // 136
print(colour.alpha); // 255
```

### HSL (Hue, Saturation, Lightness)

Useful for color manipulation and creating color schemes.

```dart
final colour = Colour.fromHSL(
  h: 120,   // Green hue
  s: 0.5,   // 50% saturation
  l: 0.5,   // 50% lightness
);
```

**HSL Characteristics:**

- **Hue**: Color type (0° = red, 120° = green, 240° = blue)
- **Saturation**: Color intensity (0 = gray, 1 = full color)
- **Lightness**: Brightness (0 = black, 0.5 = pure color, 1 = white)

### HSV (Hue, Saturation, Value)

Similar to HSL but uses "value" instead of "lightness".

```dart
final colour = Colour.fromHSV(
  h: 120,   // Green hue
  s: 0.5,   // 50% saturation
  v: 0.7,   // 70% value/brightness
);
```

**HSV Characteristics:**

- **Hue**: Color type (same as HSL)
- **Saturation**: Color intensity (same as HSL)
- **Value**: Brightness (0 = black, 1 = pure color)

## Properties

### Color Components

```dart
final colour = Colour(alpha: 200, red: 156, green: 175, blue: 136);

// Integer values (0-255)
colour.alpha  // 200
colour.red    // 156
colour.green  // 175
colour.blue   // 136

// Fractional values (0.0-1.0)
colour.a  // 0.784... (200/255)
colour.r  // 0.612... (156/255)
colour.g  // 0.686... (175/255)
colour.b  // 0.533... (136/255)
```

### Opacity

```dart
final colour = Colour(alpha: 200, red: 156, green: 175, blue: 136);
colour.opacity  // 0.784... (200/255)
```

### String Representations

```dart
final colour = Colour(alpha: 200, red: 156, green: 175, blue: 136);

colour.hex   // "C89CAF88" (ARGB in hex)
colour.argb  // "200,156,175,136"
colour.rgb   // "156,175,136"
colour.toString()  // Base-256 encoded string
```

### Flutter Color Conversion

```dart
final colour = Colour.fromHex(hexString: '#9CAF88');
final flutterColor = colour.color;  // Returns Flutter Color object

// Use in widgets
Container(
  color: colour.color,
  child: Text('Hello'),
)
```

### Value and Hash

```dart
final colour = Colour(alpha: 255, red: 156, green: 175, blue: 136);

colour.value    // 0xFF9CAF88 (32-bit ARGB integer)
colour.hashCode // Same as value
```

## Methods

### Color Modification

```dart
final colour = Colour.fromHex(hexString: '#9CAF88');

// Modify individual channels
final transparent = colour.withAlpha(128);
final redder = colour.withRed(255);
final greener = colour.withGreen(255);
final bluer = colour.withBlue(255);

// Modify opacity (0.0-1.0)
final semiTransparent = colour.withOpacity(0.5);
```

### Conversion Methods

```dart
final colour = Colour.fromHex(hexString: '#9CAF88');

// To HSV
final hsvColor = colour.toHSV(colour);  // Returns HSVColor

// To Flutter types
final flutterColor = colour.color;           // Color
final argb32 = colour.toARGB32();            // 32-bit int
```

### Comparison

```dart
final colour1 = Colour.fromHex(hexString: '#9CAF88');
final colour2 = Colour.fromRGB(red: 156, green: 175, blue: 136);

colour1 == colour2  // true (same ARGB values)
```

## Examples

### Creating a Color Palette

```dart
class MyColorPalette {
  // Primary colors
  static final primary = Colour.fromHex(hexString: '#9CAF88');
  static final primaryLight = Colour.fromHSL(
    h: 92,
    s: 0.22,
    l: 0.75,  // Lighter
  );
  static final primaryDark = Colour.fromHSL(
    h: 92,
    s: 0.22,
    l: 0.45,  // Darker
  );

  // Semantic colors
  static final success = Colour.fromHex(hexString: '#88B584');
  static final warning = Colour.fromHex(hexString: '#E5BD8F');
  static final error = Colour.fromHex(hexString: '#D49490');

  // Grayscale
  static final black = Colour.fromPercent(a: 100, r: 0, g: 0, b: 0);
  static final white = Colour.fromPercent(a: 100, r: 100, g: 100, b: 100);
  static final gray = Colour.fromPercent(a: 100, r: 50, g: 50, b: 50);
}
```

### Color Picker Value Handling

```dart
class ColorPickerDemo extends StatefulWidget {
  @override
  _ColorPickerDemoState createState() => _ColorPickerDemoState();
}

class _ColorPickerDemoState extends State<ColorPickerDemo> {
  Colour selectedColour = Colour.fromHex(hexString: '#9CAF88');

  void _showColorPicker() async {
    // Use any color picker package
    final Color? picked = await showDialog<Color>(
      context: context,
      builder: (context) => ColorPickerDialog(
        initialColor: selectedColour.color,
      ),
    );

    if (picked != null) {
      setState(() {
        selectedColour = Colour.fromColor(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          color: selectedColour.color,
        ),
        Text('Hex: ${selectedColour.hex}'),
        Text('RGB: ${selectedColour.rgb}'),
        ElevatedButton(
          onPressed: _showColorPicker,
          child: Text('Pick Color'),
        ),
      ],
    );
  }
}
```

### Saving/Loading Colors

```dart
import 'package:shared_preferences/shared_preferences.dart';

class ColorPreferences {
  static const String _key = 'user_theme_color';

  // Save color as hex string
  static Future<void> saveColor(Colour colour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, colour.hex);
  }

  // Load color from hex string
  static Future<Colour> loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    final hexString = prefs.getString(_key) ?? 'FF9CAF88';
    return Colour.fromHex(hexString: hexString);
  }

  // Alternative: Save as RGB values
  static Future<void> saveColorRGB(Colour colour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('color_alpha', colour.alpha);
    await prefs.setInt('color_red', colour.red);
    await prefs.setInt('color_green', colour.green);
    await prefs.setInt('color_blue', colour.blue);
  }

  static Future<Colour> loadColorRGB() async {
    final prefs = await SharedPreferences.getInstance();
    return Colour(
      alpha: prefs.getInt('color_alpha') ?? 255,
      red: prefs.getInt('color_red') ?? 156,
      green: prefs.getInt('color_green') ?? 175,
      blue: prefs.getInt('color_blue') ?? 136,
    );
  }
}
```

### Dynamic Theme Colors

```dart
class DynamicThemeProvider extends ChangeNotifier {
  Colour _primaryColour = Colour.fromHex(hexString: '#9CAF88');

  Colour get primaryColour => _primaryColour;

  void setPrimaryColour(Colour colour) {
    _primaryColour = colour;
    notifyListeners();
  }

  // Generate complementary color
  Colour get complementaryColour {
    final hsv = _primaryColour.toHSV(_primaryColour);
    return Colour.fromHSV(
      h: (hsv.hue + 180) % 360,  // Opposite on color wheel
      s: hsv.saturation,
      v: hsv.value,
    );
  }

  // Generate lighter shade
  Colour getLighterShade(double amount) {
    return _primaryColour.withOpacity(_primaryColour.opacity - amount);
  }

  // Generate darker shade
  Colour getDarkerShade(double amount) {
    final hsv = _primaryColour.toHSV(_primaryColour);
    return Colour.fromHSVColour(
      hsvColour: HSVColor.fromAHSV(
        hsv.alpha,
        hsv.hue,
        hsv.saturation,
        (hsv.value - amount).clamp(0.0, 1.0),
      ),
    );
  }
}
```

### Gradient with Colours

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colour.fromHex(hexString: '#9CAF88').color,
        Colour.fromHex(hexString: '#E6D5B8').color,
      ],
    ),
  ),
  child: Text('Gradient Background'),
)
```

### Color Interpolation

```dart
Colour interpolate(Colour start, Colour end, double t) {
  return Colour(
    alpha: (start.alpha + (end.alpha - start.alpha) * t).round(),
    red: (start.red + (end.red - start.red) * t).round(),
    green: (start.green + (end.green - start.green) * t).round(),
    blue: (start.blue + (end.blue - start.blue) * t).round(),
  );
}

// Usage
final start = Colour.fromHex(hexString: '#9CAF88');
final end = Colour.fromHex(hexString: '#D49490');
final middle = interpolate(start, end, 0.5);  // 50% between start and end
```

## Best Practices

### Storage

```dart
// ✅ Good: Store as hex string (compact and readable)
final hex = colour.hex;
await prefs.setString('color', hex);

// ✅ Good: Store as separate int values (precise)
await prefs.setInt('color_value', colour.value);

// ❌ Avoid: Storing the entire object
// (unnecessary complexity)
```

### Conversion

```dart
// ✅ Good: Convert once and reuse
final flutterColor = colour.color;
return Container(
  color: flutterColor,
  child: Text('Text', style: TextStyle(color: flutterColor)),
);

// ❌ Avoid: Converting multiple times
return Container(
  color: colour.color,  // Conversion 1
  child: Text('Text', style: TextStyle(color: colour.color)),  // Conversion 2
);
```

### Performance

```dart
// ✅ Good: Cache formatted strings
class ColorDisplay {
  final Colour colour;
  late final String hexDisplay = colour.hex;
  late final String rgbDisplay = colour.rgb;

  ColorDisplay(this.colour);
}

// ❌ Avoid: Formatting repeatedly in build
Widget build(BuildContext context) {
  return Text(colour.hex);  // Formats every build
}
```

### Color Space Selection

```dart
// Use RGB for:
// - Storage and transmission
// - Direct manipulation of channels
// - Working with existing RGB values

final rgbColour = Colour.fromRGB(red: 156, green: 175, blue: 136);

// Use HSL/HSV for:
// - Creating color schemes
// - Adjusting brightness/saturation
// - Color picker interfaces

final lighterShade = Colour.fromHSL(
  h: baseHue,
  s: baseSaturation,
  l: baseLightness + 0.1,  // 10% lighter
);
```

## Related

- [AppTheme](../presentation/app_theme.md) - Uses Colour for theme system
- [Constants/Colours](../constants/colours.md) - Predefined color constants
- [Extensions/BuildContext](../extensions/build_context.md) - Theme color access
