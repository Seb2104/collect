part of '../../collect.dart';

/// A widget that displays binary data in hexadecimal format.
///
/// The [HexViewer] displays data in a traditional hex editor layout with:
/// - Offset column showing byte positions
/// - Hex columns showing byte values in hexadecimal
/// - ASCII column showing printable characters
///
/// Example:
/// ```dart
/// HexViewer(
///   data: Uint8List.fromList([0x48, 0x65, 0x6C, 0x6C, 0x6F]),
///   bytesPerRow: 16,
/// )
/// ```
class HexViewer extends StatelessWidget {
  const HexViewer({
    super.key,
    required this.data,
    this.bytesPerRow = 16,
    this.showAscii = true,
    this.showOffset = true,
    this.offsetWidth = 8,
    this.groupSize = 8,
    this.style,
    this.offsetStyle,
    this.asciiStyle,
    this.nonPrintableChar = '.',
  });

  /// The binary data to display
  final Uint8List data;

  /// Number of bytes to display per row
  final int bytesPerRow;

  /// Whether to show the ASCII representation column
  final bool showAscii;

  /// Whether to show the offset column
  final bool showOffset;

  /// Number of hex digits to use for offset (e.g., 8 for 32-bit offsets)
  final int offsetWidth;

  /// Number of bytes per group (adds spacing between groups)
  final int groupSize;

  /// Text style for hex values
  final TextStyle? style;

  /// Text style for offset column
  final TextStyle? offsetStyle;

  /// Text style for ASCII column
  final TextStyle? asciiStyle;

  /// Character to display for non-printable ASCII values
  final String nonPrintableChar;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 14,
      color: Theme.of(context).colorScheme.onSurface,
    );

    final hexStyle = style ?? defaultStyle;
    final offsetTextStyle =
        offsetStyle ??
        defaultStyle.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        );
    final asciiTextStyle =
        asciiStyle ??
        defaultStyle.copyWith(color: Theme.of(context).colorScheme.primary);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: SelectableText.rich(
          TextSpan(
            children: _buildTextSpans(
              hexStyle,
              offsetTextStyle,
              asciiTextStyle,
            ),
            style: hexStyle,
          ),
        ),
      ),
    );
  }

  List<InlineSpan> _buildTextSpans(
    TextStyle hexStyle,
    TextStyle offsetStyle,
    TextStyle asciiStyle,
  ) {
    final spans = <InlineSpan>[];
    final totalRows = (data.length / bytesPerRow).ceil();

    for (int row = 0; row < totalRows; row++) {
      final offset = row * bytesPerRow;
      final rowData = data.sublist(
        offset,
        math.min(offset + bytesPerRow, data.length),
      );

      // Offset column
      if (showOffset) {
        spans.add(
          TextSpan(
            text: offset.toRadixString(16).padLeft(offsetWidth, '0'),
            style: offsetStyle,
          ),
        );
        spans.add(TextSpan(text: '  ', style: hexStyle));
      }

      // Hex columns
      for (int i = 0; i < bytesPerRow; i++) {
        if (i < rowData.length) {
          spans.add(
            TextSpan(
              text: rowData[i].toRadixString(16).padLeft(2, '0'),
              style: hexStyle,
            ),
          );
        } else {
          // Padding for incomplete rows
          spans.add(TextSpan(text: '  ', style: hexStyle));
        }

        // Add space after each byte
        spans.add(TextSpan(text: ' ', style: hexStyle));

        // Add extra space between groups
        if (groupSize > 0 && (i + 1) % groupSize == 0 && i + 1 < bytesPerRow) {
          spans.add(TextSpan(text: ' ', style: hexStyle));
        }
      }

      // ASCII column
      if (showAscii) {
        spans.add(TextSpan(text: ' ', style: hexStyle));
        for (int i = 0; i < rowData.length; i++) {
          final byte = rowData[i];
          final char = _isPrintable(byte)
              ? String.fromCharCode(byte)
              : nonPrintableChar;
          spans.add(TextSpan(text: char, style: asciiStyle));
        }
      }

      // New line
      spans.add(const TextSpan(text: '\n'));
    }

    return spans;
  }

  bool _isPrintable(int byte) {
    return byte >= 0x20 && byte <= 0x7E;
  }
}

/// A scrollable hex viewer with fixed header showing column labels.
///
/// This is a more feature-rich version of [HexViewer] with a fixed header
/// and better scrolling support for large binary files.
class ScrollableHexViewer extends StatefulWidget {
  const ScrollableHexViewer({
    super.key,
    required this.data,
    this.bytesPerRow = 16,
    this.showAscii = true,
    this.showOffset = true,
    this.offsetWidth = 8,
    this.groupSize = 8,
    this.style,
    this.offsetStyle,
    this.asciiStyle,
    this.nonPrintableChar = '.',
    this.height,
  });

  final Uint8List data;
  final int bytesPerRow;
  final bool showAscii;
  final bool showOffset;
  final int offsetWidth;
  final int groupSize;
  final TextStyle? style;
  final TextStyle? offsetStyle;
  final TextStyle? asciiStyle;
  final String nonPrintableChar;
  final double? height;

  @override
  State<ScrollableHexViewer> createState() => _ScrollableHexViewerState();
}

class _ScrollableHexViewerState extends State<ScrollableHexViewer> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: Scrollbar(
              controller: _verticalController,
              thumbVisibility: true,
              child: Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                notificationPredicate: (notification) =>
                    notification.depth == 1,
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    controller: _verticalController,
                    child: HexViewer(
                      data: widget.data,
                      bytesPerRow: widget.bytesPerRow,
                      showAscii: widget.showAscii,
                      showOffset: widget.showOffset,
                      offsetWidth: widget.offsetWidth,
                      groupSize: widget.groupSize,
                      style: widget.style,
                      offsetStyle: widget.offsetStyle,
                      asciiStyle: widget.asciiStyle,
                      nonPrintableChar: widget.nonPrintableChar,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final defaultStyle = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );

    final buffer = StringBuffer();

    // Offset header
    if (widget.showOffset) {
      buffer.write('Offset'.padRight(widget.offsetWidth));
      buffer.write('  ');
    }

    // Hex column headers
    for (int i = 0; i < widget.bytesPerRow; i++) {
      buffer.write(i.toRadixString(16).padLeft(2, '0').toUpperCase());
      buffer.write(' ');

      if (widget.groupSize > 0 &&
          (i + 1) % widget.groupSize == 0 &&
          i + 1 < widget.bytesPerRow) {
        buffer.write(' ');
      }
    }

    // ASCII header
    if (widget.showAscii) {
      buffer.write(' ASCII');
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Text(buffer.toString(), style: defaultStyle),
    );
  }
}
