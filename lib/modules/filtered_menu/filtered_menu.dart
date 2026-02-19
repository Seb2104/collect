library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'src/data.dart';
part 'src/menu_entry.dart';

class FilteredMenu<T> extends StatefulWidget {
  const FilteredMenu({
    super.key,
    required this.entries,
    this.initialSelection,
    this.onSelected,
    this.focusNode,
    this.width,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.leadingIcon,
    this.trailingIcon,
    this.showTrailingIcon = true,
    this.selectedTrailingIcon,
    this.searchCallback,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.cursorHeight,
    this.closeBehavior = MenuCloseBehavior.all,
    this.requestFocusOnTap,
    this.theme,
    this.inputDecoration,
    this.offset,
  });

  final List<MenuEntry<T>> entries;
  final T? initialSelection;
  final ValueChanged<T?>? onSelected;
  final FocusNode? focusNode;
  final double? width;
  final Widget? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool showTrailingIcon;
  final Widget? selectedTrailingIcon;
  final MenuEntrySearchCallback<MenuEntry<T>>? searchCallback;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final double? cursorHeight;
  final MenuCloseBehavior closeBehavior;
  final bool? requestFocusOnTap;
  final MenuTheme? theme;
  final InputDecoration? inputDecoration;
  final Offset? offset;

  @override
  State<FilteredMenu<T>> createState() => _FilteredMenuState<T>();
}

class _FilteredMenuState<T> extends State<FilteredMenu<T>> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  final FocusNode _internalFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();

  OverlayEntry? _overlayEntry;
  List<MenuEntry<T>> _filteredEntries = [];
  int? _currentHighlight;
  int? _selectedEntryIndex;
  bool _isOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _filteredEntries = widget.entries;

    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

    _initializeSelection();

    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void didUpdateWidget(FilteredMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.entries != widget.entries) {
      _filteredEntries = widget.entries;
      _currentHighlight = null;
    }

    if (oldWidget.initialSelection != widget.initialSelection) {
      _initializeSelection();
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _textController.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _overlayEntry?.remove();
    _scrollController.dispose();
    _internalFocusNode.dispose();

    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  void _initializeSelection() {
    if (widget.initialSelection != null) {
      final index = widget.entries.indexWhere(
        (e) => e.value == widget.initialSelection,
      );
      if (index != -1) {
        _updateTextController(widget.entries[index].label);
        _selectedEntryIndex = index;
      }
    }
  }

  void _updateTextController(String text) {
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _onTextChanged() {
    if (_isOverlayVisible) {
      setState(() {
        _updateFilteredEntries();
      });
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && _isOverlayVisible) {
      if (widget.closeBehavior == MenuCloseBehavior.all) {
        _hideOverlay();
      }
    }
  }

  void _updateFilteredEntries() {
    final text = _textController.text;

    if (text.isNotEmpty) {
      if (widget.searchCallback != null) {
        _currentHighlight = widget.searchCallback!(_filteredEntries, text);
      } else {
        final searchText = text.toLowerCase();
        final index = _filteredEntries.indexWhere(
          (e) => e.label.toLowerCase().contains(searchText),
        );
        _currentHighlight = index != -1 ? index : null;
      }

      if (_currentHighlight != null) {
        _scrollToHighlight();
      }
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (!_isOverlayVisible) return false;
    if (event is! KeyDownEvent) return false;

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowDown) {
      _highlightNext();
      return true;
    }

    if (key == LogicalKeyboardKey.arrowUp) {
      _highlightPrevious();
      return true;
    }

    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _handleEnter();
      return true;
    }

    if (key == LogicalKeyboardKey.escape) {
      _hideOverlay();
      return true;
    }

    return false;
  }

  void _highlightNext() {
    setState(() {
      if (_filteredEntries.isEmpty) {
        _currentHighlight = null;
        return;
      }

      int next = ((_currentHighlight ?? -1) + 1) % _filteredEntries.length;

      while (!_filteredEntries[next].enabled) {
        next = (next + 1) % _filteredEntries.length;
        if (next == _currentHighlight) break;
      }

      _currentHighlight = next;
      if (_filteredEntries[next].enabled) {
        _updateTextController(_filteredEntries[next].label);
      }
    });
    _scrollToHighlight();
  }

  void _highlightPrevious() {
    setState(() {
      if (_filteredEntries.isEmpty) {
        _currentHighlight = null;
        return;
      }

      int prev = _currentHighlight ?? 0;
      prev = (prev - 1) % _filteredEntries.length;
      if (prev < 0) prev = _filteredEntries.length - 1;

      while (!_filteredEntries[prev].enabled) {
        prev = prev - 1;
        if (prev < 0) prev = _filteredEntries.length - 1;
        if (prev == _currentHighlight) break;
      }

      _currentHighlight = prev;
      if (_filteredEntries[prev].enabled) {
        _updateTextController(_filteredEntries[prev].label);
      }
    });
    _scrollToHighlight();
  }

  void _handleEnter() {
    if (_currentHighlight != null &&
        _currentHighlight! < _filteredEntries.length) {
      final entry = _filteredEntries[_currentHighlight!];
      if (entry.enabled) {
        _selectEntry(entry, _currentHighlight!);
      }
    }
  }

  void _scrollToHighlight() {
    if (_currentHighlight == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _currentHighlight! < _filteredEntries.length) {
        final itemHeight = 48.0;
        final offset = _currentHighlight! * itemHeight;
        final viewportHeight = _scrollController.position.viewportDimension;
        final currentScroll = _scrollController.offset;

        if (offset < currentScroll ||
            offset + itemHeight > currentScroll + viewportHeight) {
          _scrollController.animateTo(
            offset - (viewportHeight / 2) + (itemHeight / 2),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void _toggleOverlay() {
    if (_isOverlayVisible) {
      _hideOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (_isOverlayVisible) return;

    setState(() {
      _filteredEntries = widget.entries;
      _isOverlayVisible = true;
    });

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _internalFocusNode.requestFocus();
  }

  void _hideOverlay() {
    if (!_isOverlayVisible) return;

    setState(() {
      _isOverlayVisible = false;
      _currentHighlight = null;
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectEntry(MenuEntry<T> entry, int index) {
    _updateTextController(entry.label);
    _selectedEntryIndex = index;
    _currentHighlight = index;
    widget.onSelected?.call(entry.value);

    if (widget.closeBehavior == MenuCloseBehavior.self ||
        widget.closeBehavior == MenuCloseBehavior.all) {
      _hideOverlay();
    }
  }

  bool _canRequestFocus() {
    return widget.requestFocusOnTap ??
        switch (Theme.of(context).platform) {
          TargetPlatform.iOS ||
          TargetPlatform.android ||
          TargetPlatform.fuchsia => false,
          TargetPlatform.macOS ||
          TargetPlatform.linux ||
          TargetPlatform.windows => true,
        };
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: widget.width,
        child: TextField(
          controller: _textController,
          focusNode: _focusNode,
          canRequestFocus: _canRequestFocus(),
          enableInteractiveSelection: _canRequestFocus(),
          readOnly: !_canRequestFocus(),
          keyboardType: widget.keyboardType,
          textAlign: widget.textAlign,
          textAlignVertical: TextAlignVertical.center,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          cursorHeight: widget.cursorHeight,
          style: widget.textStyle,
          inputFormatters: widget.inputFormatters,
          onTap: _toggleOverlay,
          onChanged: (text) {
            if (!_isOverlayVisible) {
              _showOverlay();
            }
          },
          decoration:
              (widget.inputDecoration ??
                      InputDecoration(
                        border: const OutlineInputBorder(),
                        label: widget.label,
                        hintText: widget.hintText,
                        helperText: widget.helperText,
                        errorText: widget.errorText,
                      ))
                  .copyWith(
                    prefixIcon: widget.leadingIcon,
                    suffixIcon: widget.showTrailingIcon
                        ? IconButton(
                            icon: _isOverlayVisible
                                ? (widget.selectedTrailingIcon ??
                                      const Icon(Icons.arrow_drop_up))
                                : (widget.trailingIcon ??
                                      const Icon(Icons.arrow_drop_down)),
                            onPressed: _toggleOverlay,
                          )
                        : null,
                  ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          if (widget.closeBehavior == MenuCloseBehavior.all) {
            _hideOverlay();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: SizedBox.expand(
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                offset: widget.offset ?? const Offset(0, 5),
                showWhenUnlinked: false,
                child: SizedBox(
                  width: widget.width ?? size.width,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _filteredEntries.length,
                        itemBuilder: (context, index) =>
                            _buildItem(_filteredEntries[index], index),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(MenuEntry<T> entry, int index) {
    final isHighlighted = index == _currentHighlight;
    final isSelected = index == _selectedEntryIndex;

    Color? backgroundColor;
    if (isHighlighted) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.12);
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.08);
    }

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: entry.enabled ? () => _selectEntry(entry, index) : null,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (entry.leadingIcon != null) ...[
                entry.leadingIcon!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child:
                    entry.labelWidget ??
                    Text(
                      entry.label,
                      style: widget.textStyle?.copyWith(
                        color: entry.enabled
                            ? null
                            : Theme.of(context).disabledColor,
                      ),
                    ),
              ),
              if (entry.trailingIcon != null) ...[
                const SizedBox(width: 12),
                entry.trailingIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
