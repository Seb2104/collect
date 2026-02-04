# Interactive Hex Editor with Data Inspector

A Flutter widget that provides an interactive hex viewer with a data inspector panel, similar to professional hex editor plugins. Click on any byte to see it interpreted as various data types with configurable endianness.

## Features

- **Interactive byte selection** - Click bytes to select them
- **Data Inspector panel** showing selected bytes as:
  - Int8, UInt8
  - Int16, UInt16
  - Int32, UInt32
  - Int64, UInt64
  - Float32, Float64
  - Binary representation
  - Octal representation
  - ASCII
  - UTF-8
- **Endianness toggle** - Switch between Little Endian and Big Endian
- **Traditional hex editor layout** - Offset, hex values, and ASCII columns
- **Selectable values** - Copy any interpreted value from the inspector
- **Scrollable interface** - Handle large binary files

## Quick Start

```dart
import 'dart:typed_data';
import 'package:collect/collect.dart';

final data = Uint8List.fromList([
  0x48, 0x65, 0x6C, 0x6C, 0x6F, // "Hello"
  0x00, 0x00, 0x00, 0x88, // Int32: 136 (little endian)
]);

InteractiveHexViewer(
  data: data,
  bytesPerRow: 16,
  groupSize: 8,
  showInspector: true,
)
```

## Components

### InteractiveHexViewer

Main widget that combines the hex view with the data inspector panel.

```dart
InteractiveHexViewer(
  data: binaryData,
  bytesPerRow: 16,
  groupSize: 8,
  showInspector: true,
  inspectorWidth: 300,
)
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `Uint8List` | required | Binary data to display |
| `bytesPerRow` | `int` | 16 | Bytes per row |
| `groupSize` | `int` | 8 | Bytes per group (spacing) |
| `showInspector` | `bool` | true | Show inspector panel |
| `inspectorWidth` | `double` | 300 | Width of inspector panel |

### DataInspector

The inspector panel that shows byte interpretations. Can be used standalone if you want to build a custom layout.

```dart
DataInspector(
  data: binaryData,
  offset: 0,
  length: 4,
  endianness: Endianness.little,
  onEndiannessChanged: (newValue) {
    // Handle endianness change
  },
)
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `data` | `Uint8List` | Source binary data |
| `offset` | `int` | Start offset of selection |
| `length` | `int` | Number of bytes selected |
| `endianness` | `Endianness` | Byte order (little/big) |
| `onEndiannessChanged` | `ValueChanged<Endianness>` | Callback for endianness changes |

## Usage Examples

### Basic Hex Editor

```dart
InteractiveHexViewer(
  data: fileBytes,
  bytesPerRow: 16,
)
```

### Without Inspector Panel

```dart
InteractiveHexViewer(
  data: fileBytes,
  showInspector: false,
  bytesPerRow: 16,
)
```

### Custom Inspector Width

```dart
InteractiveHexViewer(
  data: fileBytes,
  inspectorWidth: 400, // Wider inspector
  bytesPerRow: 16,
)
```

### Reading a File

```dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';

// Pick and display a file
final result = await FilePicker.platform.pickFiles();
if (result != null) {
  final file = File(result.files.single.path!);
  final bytes = await file.readAsBytes();

  // Show in hex editor
  InteractiveHexViewer(
    data: bytes,
    bytesPerRow: 16,
  );
}
```

## Understanding Data Types

### Integer Types

Click on a byte to see it interpreted as different integer types:

- **Int8**: Single signed byte (-128 to 127)
- **UInt8**: Single unsigned byte (0 to 255)
- **Int16**: 2 bytes, signed (-32,768 to 32,767)
- **UInt16**: 2 bytes, unsigned (0 to 65,535)
- **Int32**: 4 bytes, signed
- **UInt32**: 4 bytes, unsigned
- **Int64**: 8 bytes, signed
- **UInt64**: 8 bytes, unsigned

### Floating Point Types

- **Float32**: 4 bytes, single precision (IEEE 754)
- **Float64**: 8 bytes, double precision (IEEE 754)

### Other Representations

- **Binary**: Raw binary digits (e.g., `01001000`)
- **Octal**: Base-8 representation
- **ASCII**: Printable ASCII characters
- **UTF-8**: Unicode text interpretation

## Endianness

The inspector shows how the same bytes are interpreted differently based on byte order:

### Little Endian (Default)
Bytes are stored least-significant byte first.
Example: `0x12 0x34` → `0x3412` = 13,330

### Big Endian
Bytes are stored most-significant byte first.
Example: `0x12 0x34` → `0x1234` = 4,660

Toggle the checkbox in the inspector to switch between modes and see how values change.

## Example Data

```dart
// Create sample data with various types
final data = ByteData(16);

// Little endian values
data.setInt32(0, 42, Endian.little);        // Int32
data.setFloat32(4, 3.14159, Endian.little); // Float32
data.setInt64(8, 1234567890, Endian.little); // Int64

final bytes = data.buffer.asUint8List();

InteractiveHexViewer(data: bytes);
```

## Run the Example

The example app includes full file opening functionality:

```bash
flutter run example/hex_editor_app.dart
```

The example demonstrates:
- **Opening any file** from your system
- Selecting individual bytes
- Viewing multi-byte values
- Toggling endianness
- Different data type interpretations
- File information display
- Professional hex editor interface

## Use Cases

- **Binary file analysis** - Inspect file formats and structures
- **Network protocol debugging** - Examine packet contents
- **Data structure exploration** - Understand binary serialization
- **Reverse engineering** - Analyze unknown binary formats
- **Learning** - Understand how data is stored in memory
- **Debugging** - Inspect binary data at the byte level

## Architecture

```
InteractiveHexViewer
├── Hex View (Left)
│   ├── Header (column labels)
│   └── Scrollable Rows
│       ├── Offset column
│       ├── Hex bytes (clickable)
│       └── ASCII column
└── Data Inspector (Right)
    ├── Endianness toggle
    └── Value interpretations
        ├── Integer types
        ├── Float types
        └── Text representations
```

## Tips

1. **Select bytes carefully** - Multi-byte types need the correct number of bytes:
   - Int16/UInt16: Select 2+ bytes
   - Int32/UInt32/Float32: Select 4+ bytes
   - Int64/UInt64/Float64: Select 8+ bytes

2. **Use endianness** - When working with binary formats, check the specification to know whether data is stored as little or big endian

3. **Copy values** - All inspector values are selectable, making it easy to copy specific interpretations

4. **ASCII column** - Use this to quickly spot text strings in binary data

5. **Binary view** - Useful for understanding bit flags and packed structures

## Comparison with Original Plugin

This Flutter implementation provides similar functionality to the VSCode hex editor plugin shown in your screenshot:

✅ Offset column showing byte positions
✅ Hex values display
✅ ASCII representation column
✅ Data inspector panel
✅ Multiple data type interpretations (Int8, UInt8, Int16, Int32, Float32, Float64, etc.)
✅ Endianness toggle (Little/Big Endian)
✅ Binary, Octal, ASCII, UTF-8 representations
✅ Scrollable interface for large files
✅ Clean, professional appearance

## Future Enhancements

Possible additions for future versions:
- Range selection (select multiple bytes with drag)
- Search functionality
- Byte highlighting by color
- Jump to offset
- Export selected bytes
- Comparison mode (diff two binary files)
