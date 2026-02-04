# Quick Start: Hex Editor

Get started with the hex editor in 30 seconds!

## 🚀 Run the App

```bash
cd example
flutter run hex_editor_app.dart
```

Or on Windows specifically:
```bash
flutter run -d windows hex_editor_app.dart
```

## 📁 Open a File

1. Click the **folder icon** in the top right
2. Select any file from your system
3. The hex view will display with the inspector panel

## 🔍 Inspect Bytes

1. Click any byte in the hex view
2. See it interpreted as multiple data types in the inspector:
   - Int8, UInt8, Int16, Int32, Int64
   - Float32, Float64
   - Binary, Octal, ASCII, UTF-8

## 🔄 Toggle Endianness

Click the **Little Endian** checkbox in the inspector to switch between:
- **Little Endian** (default) - least significant byte first
- **Big Endian** - most significant byte first

Watch how the same bytes produce different values!

## 📋 Copy Values

All values in the inspector are selectable - just click and copy!

## 💡 That's It!

You now have a fully functional hex editor that works just like professional tools.

---

## Want to Embed in Your App?

Add to your code:

```dart
import 'package:collect/collect.dart';
import 'dart:typed_data';

// In your widget:
InteractiveHexViewer(
  data: yourBinaryData,
  bytesPerRow: 16,
)
```

See `example/EXAMPLES.md` for more usage examples.

---

## File Support

The hex editor can open **any file type**:
- ✅ Executables (.exe, .dll)
- ✅ Images (.png, .jpg, .gif)
- ✅ Documents (.pdf, .docx)
- ✅ Archives (.zip, .rar)
- ✅ Databases (.db, .sqlite)
- ✅ And literally anything else!

---

## Platform Support

Works on:
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Android
- ✅ iOS
- ✅ Web

---

**Need more details?** Check out:
- `HEX_EDITOR.md` - Full API documentation
- `example/README.md` - Example documentation
- `example/EXAMPLES.md` - Usage examples
