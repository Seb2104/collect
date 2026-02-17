part of 'menu.dart';

/// A dropdown menu widget that works with simple string items.
///
/// This is the "classic" dropdown — you click a trigger button, a list of
/// options appears below it, and you pick one. It supports search, keyboard
/// navigation, custom theming, and programmatic control via [MenuControl].
///
/// For a version that lets the user type/filter directly into a text field,
/// check out [MenuTextField] instead.
///
/// Basic usage:
/// ```dart
/// Menu(
///   items: ['Option A', 'Option B', 'Option C'],
///   value: selectedValue,
///   onChanged: (newValue) => setState(() => selectedValue = newValue),
/// )
/// ```
class MenuDropDown extends StatefulWidget {
  const MenuDropDown({
    super.key,
    required this.items,
    required this.value,
    this.onChanged,
    this.width,
    this.height,
    this.decoration,
    this.config,
    this.controller,
    this.focusNode,
  });

  /// The list of string options to show in the dropdown.
  final List<String> items;

  /// The currently selected value. Should match one of the [items].
  final String value;

  /// Called when the user picks a different item. You'll want to
  /// call setState in here to update [value].
  final ValueChanged<String>? onChanged;

  /// Width of the trigger button. If null, it sizes to fit its content.
  final double? width;

  /// Height of the trigger button. If null, it sizes to fit its content.
  final double? height;

  /// A theme object for customizing the visual appearance.
  /// Individual style props (like [backgroundColor]) override theme values.
  final MenuDecoration? decoration;

  /// Behavioral configuration (search, keyboard nav, etc).
  /// See [MenuConfig] for all the options.
  final MenuConfig? config;

  /// An optional controller for programmatic open/close/toggle.
  /// See [MenuControl] for details.
  final MenuControl? controller;

  /// An optional focus node if you need to manage focus yourself.
  final FocusNode? focusNode;

  /// Helper that converts a plain list of strings into [MenuItem] objects.
  ///
  /// Super handy when you have a simple list of strings and need to use
  /// them with [MenuTextField] (which expects MenuItems, not strings).
  static List<MenuItem> stringsToItems(List<String> strings) {
    List<MenuItem> items = [];
    for (String string in strings) {
      items.add(MenuItem(value: string));
    }
    return items;
  }

  @override
  State<MenuDropDown> createState() => _MenuDropDownState();
}

/// The internal state for [MenuDropDown].
///
/// Manages the overlay (the dropdown that appears/disappears), keyboard
/// navigation, search filtering, and all the animation bits.
class _MenuDropDownState<T> extends State<MenuDropDown> {
  /// Focus node for the trigger button — tracks whether the menu has focus.
  late final FocusNode _focusNode;

  /// Links the trigger button to the overlay so the dropdown
  /// positions itself correctly below the button.
  late final LayerLink _layerLink;

  /// Controls scrolling inside the dropdown list.
  final ScrollController _scrollController = ScrollController();

  /// The actual overlay entry — this is the dropdown panel that gets
  /// inserted into the overlay. Null when the dropdown is closed.
  OverlayEntry? _overlayEntry;

  /// Controller for the search text field (if search is enabled).
  TextEditingController? _searchController;

  /// The filtered list of items currently showing in the dropdown.
  /// When search is off or empty, this is just all the items.
  List<String> _filteredItems = [];

  /// Index of the currently keyboard-highlighted item. -1 means nothing.
  int _highlightedIndex = -1;

  /// Tracks the rotation amount for the dropdown arrow animation.
  double _iconTurns = 0;

  /// Quick check for whether the dropdown is currently showing.
  bool get _isOverlayVisible => _overlayEntry != null;

  @override
  void initState() {
    super.initState();
    _layerLink = LayerLink();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);

    if (_resolvedEnableSearch) {
      _searchController = TextEditingController();
      _searchController!.addListener(_updateFilteredItems);
    }

    _updateFilteredItems();

    if (_resolvedEnableKeyboardNavigation) {
      HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    }

    widget.controller?.registerShowCallback(_showOverlay);
    widget.controller?.registerHideCallback(_hideOverlay);
    widget.controller?.selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(MenuDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items != widget.items) {
      _updateFilteredItems();
    }

    if (widget.controller != null && oldWidget.value != widget.value) {
      widget.controller!.selectedValue = widget.value;
    }
  }

  /// Cleans up everything — removes keyboard handler, disposes controllers,
  /// removes the overlay if it's still up, etc.
  @override
  void dispose() {
    if (_resolvedEnableKeyboardNavigation) {
      HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    }
    _overlayEntry?.remove();
    _searchController?.dispose();
    _scrollController.dispose();
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  // -- Resolved properties --
  // Each of these resolves a value through the priority chain:
  // direct widget prop > theme > config > hardcoded default.
  // This way you can set things at any level and it just works.

  /// Resolved background color for the trigger button.
  Color get _resolvedBackgroundColor =>
      widget.decoration?.backgroundColor ??
      widget.decoration?.backgroundColor ??
      Colors.white;

  /// Resolved border color for the trigger button.
  Color get _resolvedBorderColor =>
      widget.decoration?.borderColor ??
      widget.decoration?.borderColor ??
      Colors.grey.shade300;

  /// Resolved border side for the trigger button.
  BorderSide get _resolvedBorder =>
      widget.decoration?.border ??
      widget.decoration?.border ??
      BorderSide(color: _resolvedBorderColor);

  /// Resolved corner radius for the trigger button.
  BorderRadius get _resolvedBorderRadius =>
      widget.decoration?.borderRadius ??
      widget.decoration?.borderRadius ??
      BorderRadius.circular(8);

  /// Resolved padding for the trigger button.
  EdgeInsetsGeometry get _resolvedPadding =>
      widget.decoration?.padding ??
      widget.decoration?.padding ??
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  /// Resolved elevation for the trigger button.
  double get _resolvedElevation =>
      widget.decoration?.elevation ?? widget.decoration?.elevation ?? 0;

  /// Resolved icon color for the dropdown arrow.
  Color get _resolvedIconColor =>
      widget.decoration?.iconColor ??
      widget.decoration?.iconColor ??
      Colors.grey.shade700;

  /// Resolved icon for the dropdown arrow.
  IconData get _resolvedIcon =>
      widget.decoration?.icon ??
      widget.decoration?.icon ??
      Icons.arrow_drop_down;

  /// Resolved icon size for the dropdown arrow.
  double get _resolvedIconSize =>
      widget.decoration?.iconSize ?? widget.decoration?.iconSize ?? 24;

  /// Whether the icon rotation animation is disabled.
  bool get _resolvedDisableIconRotation =>
      widget.decoration?.disableIconRotation ??
      widget.decoration?.disableIconRotation ??
      false;

  /// Resolved background color for the dropdown panel.
  Color get _resolvedDropdownColor =>
      widget.decoration?.dropdownColor ??
      widget.decoration?.dropdownColor ??
      Colors.white;

  /// Resolved elevation for the dropdown panel.
  double get _resolvedDropdownElevation =>
      widget.decoration?.dropdownElevation ??
      widget.decoration?.dropdownElevation ??
      8;

  /// Resolved corner radius for the dropdown panel.
  BorderRadius get _resolvedDropdownBorderRadius =>
      widget.decoration?.dropdownBorderRadius ??
      widget.decoration?.dropdownBorderRadius ??
      BorderRadius.circular(8);

  /// Resolved padding for the dropdown panel.
  EdgeInsetsGeometry get _resolvedDropdownPadding =>
      widget.decoration?.dropdownPadding ??
      widget.decoration?.dropdownPadding ??
      const EdgeInsets.symmetric(vertical: 8);

  /// Resolved border/shape for the dropdown panel.
  ShapeBorder? get _resolvedDropdownBorder =>
      widget.decoration?.dropdownBorder ?? widget.decoration?.dropdownBorder;

  /// Resolved height for each item row.
  double get _resolvedItemHeight => widget.decoration?.itemHeight ?? 48;

  /// Resolved padding for each item row.
  EdgeInsetsGeometry get _resolvedItemPadding =>
      widget.decoration?.itemPadding ??
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  /// Resolved highlight color for keyboard-navigated items.
  Color get _resolvedItemHighlightColor =>
      widget.decoration?.itemHighlightColor ?? Colors.grey.shade200;

  /// Resolved background color for the selected item.
  Color get _resolvedSelectedItemColor =>
      widget.decoration?.selectedItemColor ?? Colors.blue.shade50;

  /// Whether search is enabled (resolved from widget prop or config).
  bool get _resolvedEnableSearch => widget.config?.enableSearch ?? false;

  /// Resolved search hint text.
  String get _resolvedSearchHint => widget.config?.searchHint ?? 'Search...';

  /// Resolved search match function.
  FilterMatchFn<T> get _resolvedSearchMatchFn =>
      widget.config?.searchMatchFn ?? defaultFilterMatch;

  /// Whether keyboard navigation is enabled.
  bool get _resolvedEnableKeyboardNavigation =>
      widget.config?.enableKeyboardNavigation ?? true;

  /// Resolved max height for the dropdown panel.
  double? get _resolvedMaxHeight => widget.config?.maxHeight;

  /// Resolved offset for the dropdown position.
  Offset get _resolvedOffset => widget.config?.offset ?? const Offset(0, 5);

  /// When the trigger button gains focus, open the dropdown.
  /// When it loses focus, close it.
  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  /// Toggles the dropdown open/closed and manages focus accordingly.
  void _toggleOverlay() {
    if (_isOverlayVisible) {
      _hideOverlay();
      _focusNode.unfocus();
    } else {
      _showOverlay();
      _focusNode.requestFocus();
    }
  }

  /// Opens the dropdown overlay.
  /// Also kicks off the arrow icon rotation animation.
  void _showOverlay() {
    if (_isOverlayVisible) return;

    setState(() {
      if (!_resolvedDisableIconRotation) {
        _iconTurns += 0.5;
      }
    });

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    widget.controller?.setOpen(true);
  }

  /// Closes the dropdown overlay.
  /// Resets the arrow rotation, clears the highlight, and wipes the search.
  void _hideOverlay() {
    if (!_isOverlayVisible) return;

    setState(() {
      if (!_resolvedDisableIconRotation) {
        _iconTurns -= 0.5;
      }
      _highlightedIndex = -1;
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchController?.clear();
    widget.controller?.setOpen(false);
  }

  /// Re-filters the items list based on the current search text.
  /// If search is off or the search field is empty, just shows everything.
  void _updateFilteredItems() {
    if (!_resolvedEnableSearch ||
        _searchController == null ||
        _searchController!.text.isEmpty) {
      _filteredItems = widget.items;
    } else {
      _filteredItems = widget.items
          .where(
            (item) => _resolvedSearchMatchFn(item, _searchController!.text),
          )
          .toList();
    }

    if (_highlightedIndex >= _filteredItems.length) {
      _highlightedIndex = -1;
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Handles keyboard events for arrow navigation, enter to select,
  /// and escape to close. Returns true if the event was consumed.
  bool _handleKeyEvent(KeyEvent event) {
    if (!_isOverlayVisible || !_resolvedEnableKeyboardNavigation) return false;
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
      if (_highlightedIndex >= 0 && _highlightedIndex < _filteredItems.length) {
        _selectItem(_filteredItems[_highlightedIndex]);
      }
      return true;
    }

    if (key == LogicalKeyboardKey.escape) {
      _hideOverlay();
      return true;
    }

    return false;
  }

  /// Moves the keyboard highlight down one item, wrapping around at the end.
  void _highlightNext() {
    setState(() {
      if (_filteredItems.isEmpty) {
        _highlightedIndex = -1;
      } else {
        _highlightedIndex = (_highlightedIndex + 1) % _filteredItems.length;
      }
    });
    _scrollToHighlighted();
  }

  /// Moves the keyboard highlight up one item, wrapping around at the top.
  void _highlightPrevious() {
    setState(() {
      if (_filteredItems.isEmpty) {
        _highlightedIndex = -1;
      } else if (_highlightedIndex <= 0) {
        _highlightedIndex = _filteredItems.length - 1;
      } else {
        _highlightedIndex--;
      }
    });
    _scrollToHighlighted();
  }

  /// Scrolls the dropdown list so the highlighted item is visible.
  /// Uses a post-frame callback because we need the layout to be done first.
  void _scrollToHighlighted() {
    if (_highlightedIndex < 0) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final itemHeight = _resolvedItemHeight;
        final offset = _highlightedIndex * itemHeight;
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

  /// Handles when a user picks an item — fires the callback,
  /// updates the controller, and closes the dropdown if configured to.
  void _selectItem(String? value) {
    widget.onChanged?.call(value!);
    widget.controller?.selectedValue = value;

    if (widget.config!.closeOnSelect) {
      _hideOverlay();
    }
  }

  /// Finds the currently selected item in the items list.
  /// Returns null if the current value doesn't match any item.
  String? get _selectedItem {
    try {
      return widget.items.firstWhere((item) => item == widget.value);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Material(
            color: _resolvedBackgroundColor,
            elevation: _resolvedElevation,
            shape: RoundedRectangleBorder(
              side: _resolvedBorder,
              borderRadius: _resolvedBorderRadius,
            ),
            child: InkWell(
              onTap: _toggleOverlay,
              borderRadius: _resolvedBorderRadius,
              child: Padding(
                padding: _resolvedPadding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: _buildSelectedDisplay(),
                    ),
                    _buildIcon(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the text that shows the currently selected value on the trigger button.
  Widget _buildSelectedDisplay() {
    final selectedItem = _selectedItem;
    return Word(selectedItem ?? "");
  }

  /// Builds the dropdown arrow icon with its rotation animation.
  Widget _buildIcon() {
    return AnimatedRotation(
      turns: _iconTurns,
      duration: const Duration(milliseconds: 200),
      child: Icon(
        _resolvedIcon,
        color: _resolvedIconColor,
        size: _resolvedIconSize,
      ),
    );
  }

  /// Creates the overlay entry — this is the actual floating dropdown panel.
  /// It uses CompositedTransformFollower to stick to the trigger button,
  /// and wraps everything in a GestureDetector so tapping outside closes it.
  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _focusNode.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SizedBox.expand(
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                offset: _resolvedOffset,
                showWhenUnlinked: false,
                child: SizedBox(
                  width: widget.width ?? size.width,
                  child: Material(
                    elevation: _resolvedDropdownElevation,
                    shape:
                        _resolvedDropdownBorder ??
                        RoundedRectangleBorder(
                          borderRadius: _resolvedDropdownBorderRadius,
                        ),
                    color: _resolvedDropdownColor,
                    child: _buildMenuContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the inside of the dropdown — the search field (if enabled)
  /// plus the scrollable list of items.
  Widget _buildMenuContent() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight:
            _resolvedMaxHeight ?? MediaQuery.of(context).size.height * 0.4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_resolvedEnableSearch) _buildSearchField(),
          Flexible(
            child: Padding(
              padding: _resolvedDropdownPadding,
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) =>
                    _buildItem(_filteredItems[index], index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the search text field at the top of the dropdown.
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: _resolvedSearchHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        autofocus: false,
      ),
    );
  }

  /// Builds a single item row in the dropdown list.
  /// Handles highlight and selected background colors.
  Widget _buildItem(String item, int index) {
    final isHighlighted = index == _highlightedIndex;
    final isSelected = item == widget.value;

    return Material(
      color: isHighlighted
          ? _resolvedItemHighlightColor
          : isSelected
          ? _resolvedSelectedItemColor
          : Colors.transparent,
      child: InkWell(
        onTap: () => _selectItem(item),
        child: Container(
          height: _resolvedItemHeight,
          padding: _resolvedItemPadding,
          alignment: Alignment.centerLeft,
          child: Word(item),
        ),
      ),
    );
  }
}
