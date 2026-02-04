# Hex Editor Features

## 🎯 Main Features

### 1. File Opening
- Click folder icon or "Open File" button
- Browse and select any file type
- Instant loading and display
- File size and path information

### 2. Hex View Layout

```
Offset    00 01 02 03 04 05 06 07  08 09 0A 0B 0C 0D 0E 0F  ASCII
00000000  54 58 00 BC 44 82 69 00  00 00 00 AD 28 82 69 00  TX..D.i.....(..
00000010  00 00 00 00 00 00 00 04  F0 9F 93 84 00 01 00 00  ................
00000020  00 00 01 09 62 6C 6F 00  01 72 61 67 72 61 70 68  ....blo..ragraph
```

**Layout:**
- **Offset column** - Shows byte position (hexadecimal)
- **Hex bytes** - The actual data in hex format (grouped by 8)
- **ASCII column** - Printable characters (or `.` for non-printable)

### 3. Interactive Selection
Click any byte in the hex view to select it. The inspector updates instantly.

### 4. Data Inspector Panel

Located on the right side, shows selected byte(s) as:

```
┌─────────────────────────────┐
│ Inspector                   │
│ ☑ Little Endian             │
├─────────────────────────────┤
│ Int8:     88                │
│ UInt8:    88                │
│                             │
│ Int16:    21592             │
│ UInt16:   21592             │
│                             │
│ Int32:    5788760           │
│ UInt32:   5788760           │
│                             │
│ Int64:    7602714695205...  │
│ UInt64:   7602714695205...  │
│                             │
│ Float32:  8.11178e-39       │
│ Float64:  1.74795349150...  │
│                             │
│ Binary:   01011000          │
│ Octal:    130               │
│ ASCII:    X                 │
│ UTF-8:    XTX               │
└─────────────────────────────┘
```

### 5. Endianness Toggle

**Little Endian (default):**
- Bytes: `[0x12, 0x34]`
- As Int16: `0x3412` = 13,330

**Big Endian:**
- Bytes: `[0x12, 0x34]`
- As Int16: `0x1234` = 4,660

Toggle the checkbox to see the difference!

### 6. File Information

Click the info icon (ⓘ) to see:
- File name
- Full path
- Size (formatted: KB/MB/GB)
- Byte count

### 7. Selectable Values
- All inspector values are selectable
- Click and drag to select
- Ctrl+C to copy
- Perfect for documentation or analysis

---

## 🎨 User Interface

### App Bar
```
┌────────────────────────────────────────────┐
│  Hex Editor          [ⓘ] [✕] [📁]          │
└────────────────────────────────────────────┘
```
- **Title** - Shows current file name
- **ⓘ** - File information
- **✕** - Close current file
- **📁** - Open new file

### File Info Card
```
┌────────────────────────────────────────────┐
│ 📄  example.bin                            │
│     245.5 KB • 251392 bytes                │
└────────────────────────────────────────────┘
```

### Main View
```
┌─────────────────────┬──────────────┐
│                     │              │
│   Hex View          │  Inspector   │
│   (scrollable)      │  Panel       │
│                     │              │
│                     │              │
└─────────────────────┴──────────────┘
```

---

## 🔥 Use Cases

### 1. Binary File Analysis
Open executables, DLLs, or system files to understand their structure.

### 2. Image Format Research
See the header and metadata of image files (PNG, JPEG, GIF).

### 3. Data Recovery
Examine corrupted files to find recoverable data.

### 4. Reverse Engineering
Analyze unknown file formats and protocols.

### 5. Learning
Understand how different data types are stored in memory.

### 6. Debugging
Inspect binary output from your programs.

### 7. Network Analysis
View packet captures and network data.

### 8. Game Modding
Examine and understand game file formats.

---

## ⚡ Performance

- **Fast loading** - Files load quickly
- **Smooth scrolling** - Efficient rendering
- **Memory efficient** - Only visible rows rendered
- **Large file support** - Handles files up to system memory

---

## 🎯 Keyboard Shortcuts

(Future enhancement - not implemented yet)

Planned shortcuts:
- `Ctrl+O` - Open file
- `Ctrl+W` - Close file
- `Ctrl+I` - Toggle inspector
- `Ctrl+E` - Toggle endianness
- `Ctrl+G` - Go to offset
- `Ctrl+F` - Find bytes

---

## 🔮 Future Enhancements

Possible additions:
- [ ] Search/find functionality
- [ ] Go to offset
- [ ] Byte highlighting
- [ ] Range selection (drag to select multiple bytes)
- [ ] Export selected bytes
- [ ] Compare two files (diff view)
- [ ] Bookmarks
- [ ] Custom data structure templates
- [ ] Keyboard navigation
- [ ] Edit mode (not just viewing)

---

## 💡 Tips & Tricks

1. **Finding text strings**: Look at the ASCII column for readable text
2. **Understanding structures**: Use the inspector to see how multi-byte values align
3. **Endianness debugging**: Toggle endianness when values don't make sense
4. **Copy hex values**: Select bytes in hex view for hex representation
5. **Copy interpretations**: Click values in inspector to copy specific interpretations
6. **Large files**: Use scrollbar to jump to specific sections
7. **Binary patterns**: Check the Binary view to see bit-level patterns

---

## 📚 Learning Resources

### Understanding Hex
- Each hex digit = 4 bits
- Two hex digits = 1 byte
- `0x` prefix denotes hexadecimal

### Common Hex Values
- `0x00` - Null byte
- `0xFF` - All bits set (255)
- `0x20-0x7E` - Printable ASCII
- `0x0A` - Line feed (LF)
- `0x0D` - Carriage return (CR)

### File Magic Numbers
- PNG: `89 50 4E 47` (.PNG)
- JPEG: `FF D8 FF`
- ZIP: `50 4B 03 04` (PK..)
- EXE: `4D 5A` (MZ)
- PDF: `25 50 44 46` (%PDF)

Use the hex editor to verify file types by checking their magic numbers!
