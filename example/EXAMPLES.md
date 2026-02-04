# Hex Editor Examples Guide

This directory contains examples for using the hex editor/viewer widgets from the collect package.

## 1. Hex Editor App (Recommended)

**File:** `hex_editor_app.dart`

A complete, ready-to-use hex editor application with file opening capabilities.

### Features
- Open any file from your system
- Interactive byte selection
- Data inspector panel
- Endianness toggle
- File information display
- Professional UI

### Run it
```bash
flutter run example/hex_editor_app.dart
```

Or use the launcher:
```bash
# Windows
example/run_hex_editor.bat

# Linux/macOS
bash example/run_hex_editor.sh
```

### Use Cases
- Inspecting binary files
- Debugging file formats
- Learning about binary data
- Reverse engineering
- File analysis

---

## Widget Usage Examples

If you want to embed the hex viewer in your own app, here are the different ways to use it:

### Basic Hex Viewer (Read-only display)

```dart
import 'dart:typed_data';
import 'package:collect/collect.dart';

// Simple hex display
HexViewer(
  data: yourBinaryData,
  bytesPerRow: 16,
  groupSize: 8,
)
```

### Interactive Hex Viewer with Inspector

```dart
import 'dart:typed_data';
import 'package:collect/collect.dart';

// Full featured with inspector
InteractiveHexViewer(
  data: yourBinaryData,
  bytesPerRow: 16,
  groupSize: 8,
  showInspector: true,
  inspectorWidth: 320,
)
```

### Scrollable Hex Viewer

```dart
import 'dart:typed_data';
import 'package:collect/collect.dart';

// For large files with fixed header
ScrollableHexViewer(
  data: yourBinaryData,
  bytesPerRow: 16,
  height: 600,
)
```

### With File Picker Integration

```dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:collect/collect.dart';

Future<void> openAndDisplayFile() async {
  final result = await FilePicker.platform.pickFiles();

  if (result != null && result.files.single.path != null) {
    final file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();

    // Use the bytes with any hex viewer widget
    return InteractiveHexViewer(
      data: bytes,
      bytesPerRow: 16,
    );
  }
}
```

---

## Creating Your Own Hex Editor App

Here's a minimal example to get started:

```dart
import 'dart:io';
import 'dart:typed_data';
import 'package:collect/collect.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyHexEditor());

class MyHexEditor extends StatefulWidget {
  @override
  State<MyHexEditor> createState() => _MyHexEditorState();
}

class _MyHexEditorState extends State<MyHexEditor> {
  Uint8List? data;

  Future<void> openFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result?.files.single.path != null) {
      final bytes = await File(result!.files.single.path!).readAsBytes();
      setState(() => data = bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Hex Editor'),
          actions: [
            IconButton(
              icon: Icon(Icons.folder_open),
              onPressed: openFile,
            ),
          ],
        ),
        body: data == null
            ? Center(child: Text('Open a file'))
            : InteractiveHexViewer(data: data!),
      ),
    );
  }
}
```

---

## Supported Platforms

All examples work on:
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Android
- ✅ iOS
- ✅ Web

---

## Dependencies

To use file opening in your own app, add to `pubspec.yaml`:

```yaml
dependencies:
  collect: ^1.2.1
  file_picker: ^8.1.6
```

---

## Tips

1. **Performance**: The hex viewer handles large files efficiently with lazy rendering
2. **Memory**: Files are loaded entirely into memory - for very large files (>100MB), consider implementing chunked reading
3. **Inspector**: The data inspector requires selecting enough bytes for multi-byte types (2 for Int16, 4 for Int32, etc.)
4. **Endianness**: Most modern systems use Little Endian, but network protocols often use Big Endian
5. **Styling**: All widgets accept custom TextStyle parameters for theming

---

## Need Help?

- See `HEX_EDITOR.md` for detailed API documentation
- Check `HEX_VIEWER.md` for the basic viewer widget docs
- Look at `hex_editor_app.dart` source code for implementation examples
