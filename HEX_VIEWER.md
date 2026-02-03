# Hex Viewer

A Flutter widget for displaying binary data in hexadecimal format, similar to traditional hex editors.

## Features

- **Traditional hex editor layout** with offset, hex values, and ASCII columns
- **Customizable styling** for each column
- **Scrollable variant** with fixed header for large files
- **Configurable display options**:
  - Bytes per row
  - Group spacing (e.g., group by 8 bytes)
  - Show/hide offset column
  - Show/hide ASCII column
  - Custom offset width
- **Selectable text** for easy copying

## Usage

### Basic Hex Viewer

```dart
import 'dart:typed_data';
import 'package:collect/collect.dart';

final data = Uint8List.fromList([
  0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20, 0x57, // Hello, W
  0x6F, 0x72, 0x6C, 0x64, 0x21, 0x00, 0xFF, 0xFE, // orld!...
]);

HexViewer(
  data: data,
  bytesPerRow: 16,
  groupSize: 8,
)
```

**Output:**
```
00000000  48 65 6c 6c 6f 2c 20 57  6f 72 6c 64 21 00 ff fe  Hello, World!...
```

### Scrollable Hex Viewer

For larger binary files, use the scrollable variant with a fixed header:

```dart
ScrollableHexViewer(
  data: largeData,
  bytesPerRow: 16,
  groupSize: 8,
  height: 400,
)
```

### Custom Styling

```dart
HexViewer(
  data: data,
  bytesPerRow: 16,
  groupSize: 8,
  style: TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 16,
    color: Colors.greenAccent,
  ),
  offsetStyle: TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 16,
    color: Colors.amber,
    fontWeight: FontWeight.bold,
  ),
  asciiStyle: TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 16,
    color: Colors.cyanAccent,
  ),
)
```

### Without Offset or ASCII Columns

```dart
HexViewer(
  data: data,
  showOffset: false,
  showAscii: false,
  bytesPerRow: 16,
)
```

### Custom Bytes Per Row

```dart
HexViewer(
  data: data,
  bytesPerRow: 8,  // Show 8 bytes per row instead of 16
  groupSize: 4,     // Group every 4 bytes
)
```

## Parameters

### HexViewer

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `Uint8List` | required | The binary data to display |
| `bytesPerRow` | `int` | 16 | Number of bytes per row |
| `showAscii` | `bool` | true | Show ASCII representation column |
| `showOffset` | `bool` | true | Show offset column |
| `offsetWidth` | `int` | 8 | Number of hex digits for offset |
| `groupSize` | `int` | 8 | Bytes per group (adds spacing) |
| `style` | `TextStyle?` | null | Style for hex values |
| `offsetStyle` | `TextStyle?` | null | Style for offset column |
| `asciiStyle` | `TextStyle?` | null | Style for ASCII column |
| `nonPrintableChar` | `String` | '.' | Character for non-printable bytes |

### ScrollableHexViewer

Same parameters as `HexViewer` plus:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `height` | `double?` | 400 | Height of the scrollable area |

## Reading Binary Files

To use the hex viewer with files, you'll need to read the file as binary data first:

```dart
import 'dart:io';
import 'dart:typed_data';

// Read a file
final file = File('path/to/binary/file.bin');
final Uint8List data = await file.readAsBytes();

// Display in hex viewer
ScrollableHexViewer(
  data: data,
  bytesPerRow: 16,
  height: 600,
)
```

## Example

Run the example app to see the hex viewer in action:

```bash
flutter run example/hex_viewer_example.dart
```

## Use Cases

- **Binary file inspection** - View the contents of binary files
- **Network packet analysis** - Display raw packet data
- **Debugging** - Inspect binary data structures
- **Education** - Learn about binary data representation
- **Data forensics** - Examine file contents at the byte level

## Notes

- The hex viewer uses monospace fonts (JetBrainsMono by default) for proper alignment
- Non-printable ASCII characters (< 0x20 or > 0x7E) are displayed as '.' by default
- Text is selectable, making it easy to copy hex values or offsets
- The scrollable variant includes both horizontal and vertical scrollbars for large data sets
