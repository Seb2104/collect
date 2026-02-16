part of 'menu.dart';

/// A text field with a dropdown menu attached — basically an autocomplete.
///
/// Unlike the regular [Menu] which is a button you click, this one is a
/// full text field where the user can type to filter results. The dropdown
/// appears below the text field and updates as they type.
///
/// Supports filtering, search highlighting, keyboard navigation (arrow keys
/// + enter), custom callbacks, and all the usual text field stuff like
/// input formatters and keyboard types.
///
/// Basic usage:
/// ```dart
/// MenuTextField(
///   items: Menu.stringsToItems(['Apple', 'Banana', 'Cherry']),
///   selected: selectedFruit,
///   onSelected: (value) => setState(() => selectedFruit = value),
/// )
/// ```
class MenuTextField<T> extends StatefulWidget {
  const MenuTextField({
    super.key,
    required this.items,
    required this.selected,
    this.initialSelection,
    this.onSelected,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.width,
    this.menuHeight,
    this.hintText,
    this.helperText,
    this.errorText,
    this.leadingIcon,
    this.trailingIcon,
    this.showTrailingIcon = true,
    this.selectedTrailingIcon,
    this.enableFilter = true,
    this.enableSearch = true,
    this.filterCallback,
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
    this.label,
  });

  /// The list of menu items to display in the dropdown.
  /// Use [Menu.stringsToItems] if you just have a plain list of strings.
  final List<MenuItem> items;

  /// The item that should be pre-selected when the widget first loads.
  /// This sets the initial text in the field and highlights the matching
  /// item in the dropdown.
  final MenuItem? initialSelection;

  /// The currently selected value as a string.
  /// This is tracked externally by the parent widget.
  final String selected;

  /// Called when the user picks an item from the dropdown.
  /// The string passed is the item's value.
  final ValueChanged<String>? onSelected;

  /// An optional text editing controller. If you provide one, you can
  /// read/write the text field value from outside. If you don't,
  /// one is created internally and disposed automatically.
  final TextEditingController? controller;

  /// An optional focus node. Same deal as the controller — provide your
  /// own if you need external focus control, otherwise we make one.
  final FocusNode? focusNode;

  /// Whether the text field is interactive. When false, it's greyed out
  /// and the dropdown won't open.
  final bool enabled;

  /// Width of the text field (and the dropdown below it).
  final double? width;

  /// Maximum height of the dropdown panel. Defaults to 40% of screen height.
  final double? menuHeight;

  /// A label widget displayed above/inside the text field (depends on decoration).
  final Widget? label;

  /// Hint text shown when the text field is empty.
  final String? hintText;

  /// Helper text shown below the text field.
  final String? helperText;

  /// Error text shown below the text field (usually in red).
  final String? errorText;

  /// An icon/widget shown at the start (left side) of the text field.
  final Widget? leadingIcon;

  /// The icon shown at the end of the text field when the dropdown is closed.
  /// Defaults to a down arrow.
  final Widget? trailingIcon;

  /// Whether to show the trailing dropdown arrow icon at all.
  final bool showTrailingIcon;

  /// The icon shown at the end when the dropdown is open.
  /// Defaults to an up arrow.
  final Widget? selectedTrailingIcon;

  /// Whether typing in the field filters the dropdown items.
  /// When true, only items matching the text are shown.
  final bool enableFilter;

  /// Whether typing in the field highlights the best matching item.
  /// This is separate from filtering — search highlights without hiding
  /// non-matching items (unless filtering is also on).
  final bool enableSearch;

  /// Custom filter logic. Gets the full item list and the current text,
  /// returns whichever items should be visible. If null, uses a simple
  /// case-insensitive "contains" check.
  final MenuFilterCallback<MenuItem>? filterCallback;

  /// Custom search logic. Gets the filtered list and the current text,
  /// returns the index of the item to highlight. If null, highlights
  /// the first item that contains the search text.
  final MenuSearchCallback<MenuItem>? searchCallback;

  /// Text alignment inside the text field.
  final TextAlign textAlign;

  /// Style for the text inside the text field.
  final TextStyle? textStyle;

  /// The type of keyboard to show (number pad, email, etc).
  final TextInputType? keyboardType;

  /// What the "done" button on the keyboard does (next field, submit, etc).
  final TextInputAction? textInputAction;

  /// Input formatters that restrict/transform what can be typed.
  final List<TextInputFormatter>? inputFormatters;

  /// Max number of lines for the text field. Usually 1 for a dropdown.
  final int maxLines;

  /// Custom cursor height, if you're picky about that sort of thing.
  final double? cursorHeight;

  /// Controls when the dropdown closes. See [MenuCloseBehavior].
  final MenuCloseBehavior closeBehavior;

  /// Whether tapping the text field focuses it (shows the keyboard).
  /// On mobile this defaults to false (since the dropdown handles taps),
  /// on desktop it defaults to true.
  final bool? requestFocusOnTap;

  /// Optional theme for styling the dropdown. Separate from the text field's
  /// own [inputDecoration].
  final MenuTheme? theme;

  /// Full input decoration for the text field. If null, uses a basic
  /// OutlineInputBorder with the hint/helper/error texts.
  final InputDecoration? inputDecoration;

  /// Positional offset of the dropdown relative to the text field.
  /// Defaults to (0, 5) — slightly below.
  final Offset? offset;

  @override
  State<MenuTextField<T>> createState() => _MenuTextFieldState<T>();
}

/// The internal state for [MenuTextField].
///
/// Handles the overlay (dropdown panel), text change listeners, keyboard
/// events, filtering/searching, and scrolling to highlighted items.
class _MenuTextFieldState<T> extends State<MenuTextField<T>> {
  /// The text editing controller — either the one the user passed in,
  /// or one we created ourselves.
  late final TextEditingController _textController;

  /// The focus node — same deal, either external or internally created.
  late final FocusNode _focusNode;

  /// A separate internal focus node used by the overlay.
  final FocusNode _internalFocusNode = FocusNode();

  /// Links the text field to the overlay so the dropdown positions
  /// itself correctly below.
  final LayerLink _layerLink = LayerLink();

  /// Controls scrolling inside the dropdown list.
  final ScrollController _scrollController = ScrollController();

  /// The overlay entry for the dropdown panel. Null when closed.
  OverlayEntry? _overlayEntry;

  /// The currently visible/filtered list of items in the dropdown.
  List<MenuItem> _filteredEntries = [];

  /// Index of the currently highlighted item (keyboard navigation or search).
  /// Null means nothing is highlighted.
  int? _currentHighlight;

  /// Index of the currently selected item (the one the user picked).
  int? _selectedEntryIndex;

  /// Whether the dropdown overlay is currently showing.
  bool _isOverlayVisible = false;

  /// Whether filtering is currently active. Gets toggled on/off depending
  /// on whether the user is typing vs using arrow keys.
  bool _enableFilter = false;

  /// Whether search highlighting is currently active. Same toggling as filter.
  bool _enableSearch = false;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _enableSearch = widget.enableSearch;
    _filteredEntries = widget.items;

    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

    _initializeSelection();

    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void didUpdateWidget(MenuTextField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items != widget.items) {
      _filteredEntries = widget.items;
      _currentHighlight = null;
    }

    if (oldWidget.initialSelection != widget.initialSelection) {
      _initializeSelection();
    }
  }

  /// Tears down all the listeners and disposes controllers we own.
  /// Only disposes the text controller and focus node if we created them
  /// (not if the user passed them in — that's their job).
  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _textController.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _overlayEntry?.remove();
    _scrollController.dispose();
    _internalFocusNode.dispose();

    if (widget.controller == null) {
      _textController.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  /// Sets up the initial selection — finds the matching item in the list,
  /// sets the text field value, and marks that item as selected.
  void _initializeSelection() {
    if (widget.initialSelection != null) {
      final index = widget.items.indexWhere(
        (e) => e.value == widget.initialSelection,
      );
      if (index != -1) {
        _updateTextController(widget.items[index].value);
        _selectedEntryIndex = index;
      }
    }
  }

  /// Updates the text controller's value and moves the cursor to the end.
  /// Using TextEditingValue directly instead of just setting .text so we
  /// can control the cursor position.
  void _updateTextController(String text) {
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// Called whenever the text in the field changes.
  /// Only does anything if the dropdown is actually showing — otherwise
  /// we don't need to filter or search.
  void _onTextChanged() {
    if (_isOverlayVisible) {
      setState(() {
        _enableFilter = widget.enableFilter;
        _enableSearch = widget.enableSearch;
        _updateFilteredEntries();
      });
    }
  }

  /// Called when focus changes on the text field.
  /// If focus is lost and close behavior is "all", we close the dropdown.
  void _onFocusChanged() {
    if (!_focusNode.hasFocus && _isOverlayVisible) {
      if (widget.closeBehavior == MenuCloseBehavior.all) {
        _hideOverlay();
      }
    }
  }

  /// The main filtering/searching logic.
  ///
  /// First, if filtering is enabled, it narrows down the items list based
  /// on the current text (using either the custom filterCallback or a
  /// default case-insensitive contains check).
  ///
  /// Then, if search is enabled, it finds the best matching item in the
  /// (possibly filtered) list and highlights it.
  void _updateFilteredEntries() {
    final text = _textController.text;

    if (_enableFilter && text.isNotEmpty) {
      if (widget.filterCallback != null) {
        _filteredEntries = widget.filterCallback!(widget.items, text);
      } else {
        _filteredEntries = widget.items
            .where((e) => e.value.toLowerCase().contains(text.toLowerCase()))
            .toList();
      }
    } else {
      _filteredEntries = widget.items;
    }

    if (_enableSearch && text.isNotEmpty) {
      if (widget.searchCallback != null) {
        _currentHighlight = widget.searchCallback!(_filteredEntries, text);
      } else {
        final searchText = text.toLowerCase();
        final index = _filteredEntries.indexWhere(
          (e) => e.value.toLowerCase().contains(searchText),
        );
        _currentHighlight = index != -1 ? index : null;
      }

      if (_currentHighlight != null) {
        _scrollToHighlight();
      }
    }
  }

  /// Global keyboard event handler for arrow keys, enter, and escape.
  /// Only active when the dropdown is showing. Returns true if the
  /// event was consumed (so nothing else processes it).
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

  /// Moves the highlight down one item, skipping disabled items.
  /// Also turns off filter/search so the full list stays visible
  /// while navigating with keys. Updates the text field to show
  /// the highlighted item's value.
  void _highlightNext() {
    setState(() {
      _enableFilter = false;
      _enableSearch = false;

      if (_filteredEntries.isEmpty) {
        _currentHighlight = null;
        return;
      }

      int next = ((_currentHighlight ?? -1) + 1) % _filteredEntries.length;

      while (!_filteredEntries[next].config.enabled) {
        next = (next + 1) % _filteredEntries.length;
        if (next == _currentHighlight) break;
      }

      _currentHighlight = next;
      if (_filteredEntries[next].config.enabled) {
        _updateTextController(_filteredEntries[next].value);
      }
    });
    _scrollToHighlight();
  }

  /// Moves the highlight up one item, skipping disabled items.
  /// Same idea as [_highlightNext] but going backwards.
  void _highlightPrevious() {
    setState(() {
      _enableFilter = false;
      _enableSearch = false;

      if (_filteredEntries.isEmpty) {
        _currentHighlight = null;
        return;
      }

      int prev = _currentHighlight ?? 0;
      prev = (prev - 1) % _filteredEntries.length;
      if (prev < 0) prev = _filteredEntries.length - 1;

      while (!_filteredEntries[prev].config.enabled) {
        prev = prev - 1;
        if (prev < 0) prev = _filteredEntries.length - 1;
        if (prev == _currentHighlight) break;
      }

      _currentHighlight = prev;
      if (_filteredEntries[prev].config.enabled) {
        _updateTextController(_filteredEntries[prev].value);
      }
    });
    _scrollToHighlight();
  }

  /// Handles the enter key — selects whatever item is currently highlighted.
  /// Does nothing if nothing is highlighted or the highlighted item is disabled.
  void _handleEnter() {
    if (_currentHighlight != null &&
        _currentHighlight! < _filteredEntries.length) {
      final entry = _filteredEntries[_currentHighlight!];
      if (entry.config.enabled) {
        _selectEntry(entry, _currentHighlight!);
      }
    }
  }

  /// Scrolls the dropdown list to make sure the highlighted item is visible.
  ///
  /// Uses a post-frame callback because we need the layout to be complete
  /// before we can calculate scroll positions. The null check inside the
  /// callback is important — by the time it runs, the highlight might
  /// have been cleared (e.g. if the overlay was closed in the meantime).
  void _scrollToHighlight() {
    if (_currentHighlight == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentHighlight == null) return;
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

  /// Toggles the dropdown — opens it if closed, closes it if open.
  void _toggleOverlay() {
    if (_isOverlayVisible) {
      _hideOverlay();
    } else {
      _showOverlay();
    }
  }

  /// Opens the dropdown overlay.
  /// Resets the filtered list to all items and clears any previous filtering.
  void _showOverlay() {
    if (_isOverlayVisible || !widget.enabled) return;

    setState(() {
      _filteredEntries = widget.items;
      _enableFilter = false;
      _isOverlayVisible = true;
    });

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _internalFocusNode.requestFocus();
  }

  /// Closes the dropdown overlay and resets the highlight.
  void _hideOverlay() {
    if (!_isOverlayVisible) return;

    setState(() {
      _isOverlayVisible = false;
      _currentHighlight = null;
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Handles when the user selects an item (either by tapping or pressing enter).
  ///
  /// Updates the text field, marks the item as selected, fires the callback,
  /// and closes the dropdown if the close behavior says to.
  void _selectEntry(MenuItem entry, int index) {
    _updateTextController(entry.value);
    _selectedEntryIndex = index;
    _currentHighlight = widget.enableSearch ? index : null;
    widget.onSelected?.call(entry.value);

    if (widget.closeBehavior == MenuCloseBehavior.self ||
        widget.closeBehavior == MenuCloseBehavior.all) {
      _hideOverlay();
    }
  }

  /// Figures out whether the text field should be focusable on tap.
  /// On mobile platforms, defaults to false (since the dropdown handles input).
  /// On desktop, defaults to true (since you'd expect to be able to type).
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
          enabled: widget.enabled,
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
          onTap: widget.enabled ? _toggleOverlay : null,
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
                            onPressed: widget.enabled ? _toggleOverlay : null,
                          )
                        : null,
                  ),
        ),
      ),
    );
  }

  /// Creates the overlay entry — the floating dropdown panel.
  ///
  /// Uses CompositedTransformFollower to anchor itself to the text field,
  /// wraps everything in a GestureDetector so tapping outside closes it,
  /// and contains a scrollable list of filtered items.
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
                        maxHeight:
                            widget.menuHeight ??
                            MediaQuery.of(context).size.height * 0.4,
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

  /// Builds a single item row in the dropdown.
  ///
  /// Handles the highlight color (keyboard nav), selected color (currently
  /// picked item), leading/trailing icons from the item config, and
  /// greyed-out text for disabled items.
  Widget _buildItem(MenuItem entry, int index) {
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
        onTap: entry.config.enabled ? () => _selectEntry(entry, index) : null,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (entry.config.leadingIcon != null) ...[
                entry.config.leadingIcon!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  entry.value,
                  style: widget.textStyle?.copyWith(
                    color: entry.config.enabled
                        ? null
                        : Theme.of(context).disabledColor,
                  ),
                ),
              ),
              if (entry.config.trailingIcon != null) ...[
                const SizedBox(width: 12),
                entry.config.trailingIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
