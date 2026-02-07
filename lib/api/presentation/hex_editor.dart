part of '../../collect.dart';

/// Endianness for multi-byte value interpretation
enum Endianness {
  little,
  big;

  String get label => switch (this) {
    Endianness.little => 'Little Endian',
    Endianness.big => 'Big Endian',
  };
}

/// Data inspector that shows a byte selection interpreted as various data types
class DataInspector extends StatelessWidget {
  const DataInspector({
    super.key,
    required this.data,
    required this.offset,
    required this.length,
    required this.endianness,
    required this.onEndiannessChanged,
  });

  final Uint8List data;
  final int offset;
  final int length;
  final Endianness endianness;
  final ValueChanged<Endianness> onEndiannessChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monoStyle = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 13,
      color: theme.colorScheme.onSurface,
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with endianness toggle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inspector',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    onEndiannessChanged(
                      endianness == Endianness.little
                          ? Endianness.big
                          : Endianness.little,
                    );
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: endianness == Endianness.little,
                        onChanged: (value) {
                          onEndiannessChanged(
                            value == true ? Endianness.little : Endianness.big,
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        endianness.label,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Inspector values
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (length > 0) ...[
                  _buildRow('Int8:', _getInt8().toString(), monoStyle),
                  _buildRow('UInt8:', _getUInt8().toString(), monoStyle),
                  if (length >= 2) ...[
                    _buildRow('Int16:', _getInt16().toString(), monoStyle),
                    _buildRow('UInt16:', _getUInt16().toString(), monoStyle),
                  ],
                  if (length >= 4) ...[
                    _buildRow('Int32:', _getInt32().toString(), monoStyle),
                    _buildRow('UInt32:', _getUInt32().toString(), monoStyle),
                    _buildRow('Float32:', _getFloat32().toString(), monoStyle),
                  ],
                  if (length >= 8) ...[
                    _buildRow('Int64:', _getInt64().toString(), monoStyle),
                    _buildRow('UInt64:', _getUInt64().toString(), monoStyle),
                    _buildRow('Float64:', _getFloat64().toString(), monoStyle),
                  ],
                  const SizedBox(height: 8),
                  _buildRow('Binary:', _getBinary(), monoStyle),
                  _buildRow('Octal:', _getOctal(), monoStyle),
                  _buildRow('ASCII:', _getAscii(), monoStyle),
                  _buildRow('UTF-8:', _getUtf8(), monoStyle),
                ] else
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select bytes to inspect',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, TextStyle valueStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: valueStyle.color!.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(child: SelectableText(value, style: valueStyle)),
        ],
      ),
    );
  }

  int _getInt8() {
    if (offset >= data.length) return 0;
    final value = data[offset];
    return value >= 128 ? value - 256 : value;
  }

  int _getUInt8() {
    if (offset >= data.length) return 0;
    return data[offset];
  }

  int _getInt16() {
    if (offset + 1 >= data.length) return 0;
    final bytes = data.sublist(offset, offset + 2);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getInt16(
      0,
      endianness == Endianness.little ? Endian.little : Endian.big,
    );
  }

  int _getUInt16() {
    if (offset + 1 >= data.length) return 0;
    final bytes = data.sublist(offset, offset + 2);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getUint16(
      0,
      endianness == Endianness.little ? Endian.little : Endian.big,
    );
  }

  int _getInt32() {
    if (offset + 3 >= data.length) return 0;
    final bytes = data.sublist(offset, offset + 4);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getInt32(
      0,
      endianness == Endianness.little ? Endian.little : Endian.big,
    );
  }

  int _getUInt32() {
    if (offset + 3 >= data.length) return 0;
    final bytes = data.sublist(offset, offset + 4);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getUint32(
      0,
      endianness == Endianness.little ? Endian.little : Endian.big,
    );
  }

  int _getInt64() {
    if (offset + 7 >= data.length) return 0;
    final bytes = data.sublist(offset, offset + 8);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getInt64(
      0,
      endianness == Endianness.little ? Endian.little : Endian.big,
    );
  }

  int _getUInt64() {
    if (offset + 7 >= data.length) return 0;
    final bytes = data.sublist(offset, offset + 8);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getUint64(
      0,
      endianness == Endianness.little ? Endian.little : Endian.big,
    );
  }

  double _getFloat32() {
    if (offset + 3 >= data.length) return 0.0;
    final bytes = data.sublist(offset, offset + 4);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getFloat32(
      0,
      endianness == Endianness.little ? Endian.little : Endian.big,
    );
  }

  double _getFloat64() {
    if (offset + 7 >= data.length) return 0.0;
    final bytes = data.sublist(offset, offset + 8);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getFloat64(
      0,
      endianness == Endianness.little ? Endian.little : Endian.big,
    );
  }

  String _getBinary() {
    final selected = data.sublist(
      offset,
      math.min(offset + length, data.length),
    );
    return selected.map((b) => b.toRadixString(2).padLeft(8, '0')).join('');
  }

  String _getOctal() {
    final selected = data.sublist(
      offset,
      math.min(offset + length, data.length),
    );
    return selected.map((b) => b.toRadixString(8)).join('');
  }

  String _getAscii() {
    final selected = data.sublist(
      offset,
      math.min(offset + length, data.length),
    );
    return selected
        .map((b) => (b >= 32 && b <= 126) ? String.fromCharCode(b) : '.')
        .join();
  }

  String _getUtf8() {
    try {
      final selected = data.sublist(
        offset,
        math.min(offset + length, data.length),
      );
      return String.fromCharCodes(selected);
    } catch (e) {
      return '<invalid UTF-8>';
    }
  }
}

/// Interactive hex viewer with selectable bytes and data inspector
class InteractiveHexViewer extends StatefulWidget {
  const InteractiveHexViewer({
    super.key,
    required this.data,
    this.bytesPerRow = 16,
    this.groupSize = 8,
    this.showInspector = true,
    this.inspectorWidth = 300,
  });

  final Uint8List data;
  final int bytesPerRow;
  final int groupSize;
  final bool showInspector;
  final double inspectorWidth;

  @override
  State<InteractiveHexViewer> createState() => _InteractiveHexViewerState();
}

class _InteractiveHexViewerState extends State<InteractiveHexViewer> {
  int? _selectionStart;
  int? _selectionEnd;
  Endianness _endianness = Endianness.little;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectByte(int index) {
    setState(() {
      _selectionStart = index;
      _selectionEnd = index;
    });
  }

  void _extendSelection(int index) {
    if (_selectionStart == null) {
      _selectByte(index);
      return;
    }

    setState(() {
      _selectionEnd = index;
    });
  }

  int get _selectedOffset {
    if (_selectionStart == null) return 0;
    return math.min(_selectionStart!, _selectionEnd ?? _selectionStart!);
  }

  int get _selectedLength {
    if (_selectionStart == null) return 0;
    return (_selectionEnd ?? _selectionStart!) - _selectionStart! + 1;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showInspector) {
      return _buildHexView();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildHexView()),
        const SizedBox(width: 16),
        SizedBox(
          width: widget.inspectorWidth,
          child: DataInspector(
            data: widget.data,
            offset: _selectedOffset,
            length: _selectedLength.abs(),
            endianness: _endianness,
            onEndiannessChanged: (value) {
              setState(() {
                _endianness = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHexView() {
    final theme = Theme.of(context);
    final totalRows = (widget.data.length / widget.bytesPerRow).ceil();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        totalRows,
                        (row) => _buildRow(row),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final headerStyle = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text('Offset', style: headerStyle)),
          Row(
            children: [
              for (int i = 0; i < widget.bytesPerRow; i++) ...[
                SizedBox(
                  width: 24,
                  child: Text(
                    i.toRadixString(16).padLeft(2, '0').toUpperCase(),
                    style: headerStyle,
                  ),
                ),
                if (widget.groupSize > 0 &&
                    (i + 1) % widget.groupSize == 0 &&
                    i + 1 < widget.bytesPerRow)
                  const SizedBox(width: 8)
                else
                  const SizedBox(width: 4),
              ],
            ],
          ),
          const SizedBox(width: 16),
          Text('ASCII', style: headerStyle),
        ],
      ),
    );
  }

  Widget _buildRow(int row) {
    final theme = Theme.of(context);
    final offset = row * widget.bytesPerRow;
    final rowData = widget.data.sublist(
      offset,
      math.min(offset + widget.bytesPerRow, widget.data.length),
    );

    final style = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 13,
      color: theme.colorScheme.onSurface,
    );

    final offsetStyle = style.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Offset
            SizedBox(
              width: 80,
              child: Text(
                offset.toRadixString(16).padLeft(8, '0'),
                style: offsetStyle,
              ),
            ),
            // Hex bytes
            Row(
              children: [
                for (int i = 0; i < widget.bytesPerRow; i++) ...[
                  if (i < rowData.length)
                    _buildByteWidget(offset + i, rowData[i], theme, style)
                  else
                    SizedBox(width: 24, child: Text('  ', style: style)),
                  if (widget.groupSize > 0 &&
                      (i + 1) % widget.groupSize == 0 &&
                      i + 1 < widget.bytesPerRow)
                    const SizedBox(width: 8)
                  else
                    const SizedBox(width: 4),
                ],
              ],
            ),
            const SizedBox(width: 16),
            // ASCII
            SizedBox(
              width: widget.bytesPerRow * 8.0,
              child: Text(
                rowData
                    .map(
                      (b) =>
                          (b >= 32 && b <= 126) ? String.fromCharCode(b) : '.',
                    )
                    .join(),
                style: style.copyWith(color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildByteWidget(
    int byteIndex,
    int byteValue,
    ThemeData theme,
    TextStyle style,
  ) {
    final isSelected = _isSelected(byteIndex);

    return GestureDetector(
      onTap: () => _selectByte(byteIndex),
      onLongPress: () => _extendSelection(byteIndex),
      child: Container(
        width: 24,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          byteValue.toRadixString(16).padLeft(2, '0'),
          style: style.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  bool _isSelected(int index) {
    if (_selectionStart == null) return false;
    final start = math.min(_selectionStart!, _selectionEnd ?? _selectionStart!);
    final end = math.max(_selectionStart!, _selectionEnd ?? _selectionStart!);
    return index >= start && index <= end;
  }
}
