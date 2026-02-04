# Hex Editor Examples

## Hex Editor App

A fully functional hex editor application with file opening capabilities.

### Features

- **Open any file** - Click the folder icon or the "Open File" button
- **File information** - View file name, path, and size
- **Interactive hex viewer** - Click bytes to inspect them
- **Data inspector** - See selected bytes as Int8, Int16, Int32, Float32, etc.
- **Endianness toggle** - Switch between Little Endian and Big Endian
- **Professional interface** - Clean, modern UI with Material 3 design

### Running the App

```bash
flutter run example/hex_editor_app.dart
```

Or on Windows:

```bash
flutter run -d windows example/hex_editor_app.dart
```

### Usage

1. **Open a file**: Click the folder icon in the app bar
2. **Browse**: Navigate to any binary file (executables, images, documents, etc.)
3. **Inspect**: Click on any byte in the hex view to see it in the inspector
4. **Toggle endianness**: Use the checkbox in the inspector to switch between little and big endian
5. **View file info**: Click the info icon to see detailed file information
6. **Close file**: Click the X icon to close the current file

### Supported Files

The hex editor can open any file type:
- Executables (.exe, .dll, .so)
- Images (.png, .jpg, .gif, .ico)
- Documents (.pdf, .docx, .xlsx)
- Archives (.zip, .rar, .7z)
- Database files (.db, .sqlite)
- Custom binary formats
- Text files (.txt, .json, .xml)
- And literally any other file!

### Tips

- Large files are handled efficiently with scrolling
- The inspector shows multiple data type interpretations simultaneously
- All values in the inspector are selectable for copying
- Use the endianness toggle to understand how multi-byte values are stored
- The ASCII column helps identify text strings in binary data

### Platform Support

This example works on:
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Android
- ✅ iOS
- ✅ Web (with file picker support)
