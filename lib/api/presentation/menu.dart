part of '../../collect.dart';

/// A beautiful, customizable dropdown menu with search and keyboard navigation.
///
/// MenuFlow combines the best features from multiple dropdown libraries:
/// - Overlay-based positioning (no Stack required)
/// - Search/filter functionality
/// - Full keyboard navigation
/// - Hybrid theming system
/// - Clean, easy-to-use API
///
/// Example:
/// ```dart
/// MenuFlow<String>(
///   items: [
///     MenuFlowItemString(value: 'apple', label: 'Apple'),
///     MenuFlowItemString(value: 'banana', label: 'Banana'),
///   ],
///   value: selectedFruit,
///   onChanged: (value) => setState(() => selectedFruit = value),
/// )
/// ```
class Menu<T> extends StatefulWidget {
  const Menu({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.width,
    this.height,
    // Theming
    this.theme,
    this.backgroundColor,
    this.borderColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.iconColor,
    this.icon,
    this.iconSize,
    this.disableIconRotation,
    this.dropdownColor,
    this.dropdownElevation,
    this.dropdownBorderRadius,
    this.dropdownPadding,
    this.dropdownBorder,
    this.itemHeight,
    this.itemPadding,
    this.itemHighlightColor,
    this.selectedItemColor,
    this.itemTextStyle,
    this.textStyle,
    this.hintStyle,
    // Configuration
    this.config,
    this.enableSearch,
    this.searchHint,
    this.searchMatchFn,
    this.enableKeyboardNavigation,
    this.maxHeight,
    this.offset,
    this.closeOnSelect,
    // Controller
    this.controller,
    this.focusNode,
  });

  /// List of items to display in the dropdown
  final List<MenuItem<T>> items;

  /// Currently selected value
  final T? value;

  /// Callback when value changes
  final ValueChanged<T?>? onChanged;

  /// Hint text/widget to display when no value is selected
  final Widget? hint;

  /// Button width
  final double? width;

  /// Button height
  final double? height;

  // Theming properties
  final MenuTheme? theme;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderSide? border;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Color? iconColor;
  final IconData? icon;
  final double? iconSize;
  final bool? disableIconRotation;
  final Color? dropdownColor;
  final double? dropdownElevation;
  final BorderRadius? dropdownBorderRadius;
  final EdgeInsetsGeometry? dropdownPadding;
  final ShapeBorder? dropdownBorder;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final Color? itemHighlightColor;
  final Color? selectedItemColor;
  final TextStyle? itemTextStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  // Configuration properties
  final MenuConfig? config;
  final bool? enableSearch;
  final String? searchHint;
  final FilterMatchFn<T>? searchMatchFn;
  final bool? enableKeyboardNavigation;
  final double? maxHeight;
  final Offset? offset;
  final bool? closeOnSelect;

  /// Optional controller for programmatic control
  final MenuControl<T>? controller;

  /// Optional FocusNode for external focus control
  final FocusNode? focusNode;

  @override
  State<Menu<T>> createState() => _MenuState<T>();
}

class _MenuState<T> extends State<Menu<T>> {
  late final FocusNode _focusNode;
  late final LayerLink _layerLink;
  final ScrollController _scrollController = ScrollController();

  OverlayEntry? _overlayEntry;
  TextEditingController? _searchController;
  List<MenuItem<T>> _filteredItems = [];
  int _highlightedIndex = -1;
  double _iconTurns = 0;

  bool get _isOverlayVisible => _overlayEntry != null;

  @override
  void initState() {
    super.initState();
    _layerLink = LayerLink();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);

    // Initialize search controller if search is enabled
    if (_resolvedEnableSearch) {
      _searchController = TextEditingController();
      _searchController!.addListener(_updateFilteredItems);
    }

    _updateFilteredItems();

    // Register keyboard handler if enabled
    if (_resolvedEnableKeyboardNavigation) {
      HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    }

    // Register controller callbacks
    widget.controller?.registerShowCallback(_showOverlay);
    widget.controller?.registerHideCallback(_hideOverlay);
    widget.controller?.selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(Menu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update filtered items if items list changed
    if (oldWidget.items != widget.items) {
      _updateFilteredItems();
    }

    // Update controller's selected value
    if (widget.controller != null && oldWidget.value != widget.value) {
      widget.controller!.selectedValue = widget.value;
    }
  }

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

  // Theme resolution getters (precedence: widget property > theme > default)
  Color get _resolvedBackgroundColor =>
      widget.backgroundColor ?? widget.theme?.backgroundColor ?? Colors.white;

  Color get _resolvedBorderColor =>
      widget.borderColor ?? widget.theme?.borderColor ?? Colors.grey.shade300;

  BorderSide get _resolvedBorder =>
      widget.border ??
          widget.theme?.border ??
          BorderSide(color: _resolvedBorderColor);

  BorderRadius get _resolvedBorderRadius =>
      widget.borderRadius ?? widget.theme?.borderRadius ?? BorderRadius.circular(8);

  EdgeInsetsGeometry get _resolvedPadding =>
      widget.padding ?? widget.theme?.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  double get _resolvedElevation =>
      widget.elevation ?? widget.theme?.elevation ?? 0;

  Color get _resolvedIconColor =>
      widget.iconColor ?? widget.theme?.iconColor ?? Colors.grey.shade700;

  IconData get _resolvedIcon =>
      widget.icon ?? widget.theme?.icon ?? Icons.arrow_drop_down;

  double get _resolvedIconSize =>
      widget.iconSize ?? widget.theme?.iconSize ?? 24;

  bool get _resolvedDisableIconRotation =>
      widget.disableIconRotation ?? widget.theme?.disableIconRotation ?? false;

  Color get _resolvedDropdownColor =>
      widget.dropdownColor ?? widget.theme?.dropdownColor ?? Colors.white;

  double get _resolvedDropdownElevation =>
      widget.dropdownElevation ?? widget.theme?.dropdownElevation ?? 8;

  BorderRadius get _resolvedDropdownBorderRadius =>
      widget.dropdownBorderRadius ??
          widget.theme?.dropdownBorderRadius ??
          BorderRadius.circular(8);

  EdgeInsetsGeometry get _resolvedDropdownPadding =>
      widget.dropdownPadding ?? widget.theme?.dropdownPadding ?? const EdgeInsets.symmetric(vertical: 8);

  ShapeBorder? get _resolvedDropdownBorder =>
      widget.dropdownBorder ?? widget.theme?.dropdownBorder;

  double get _resolvedItemHeight =>
      widget.itemHeight ?? widget.theme?.itemHeight ?? 48;

  EdgeInsetsGeometry get _resolvedItemPadding =>
      widget.itemPadding ?? widget.theme?.itemPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  Color get _resolvedItemHighlightColor =>
      widget.itemHighlightColor ??
          widget.theme?.itemHighlightColor ??
          Colors.grey.shade200;

  Color get _resolvedSelectedItemColor =>
      widget.selectedItemColor ??
          widget.theme?.selectedItemColor ??
          Colors.blue.shade50;

  TextStyle? get _resolvedItemTextStyle =>
      widget.itemTextStyle ?? widget.theme?.itemTextStyle;

  TextStyle? get _resolvedTextStyle =>
      widget.textStyle ?? widget.theme?.textStyle;

  TextStyle? get _resolvedHintStyle =>
      widget.hintStyle ?? widget.theme?.hintStyle ?? TextStyle(color: Colors.grey.shade600);

  // Config resolution getters
  bool get _resolvedEnableSearch =>
      widget.enableSearch ?? widget.config?.enableSearch ?? false;

  String get _resolvedSearchHint =>
      widget.searchHint ?? widget.config?.searchHint ?? 'Search...';

  FilterMatchFn<T> get _resolvedSearchMatchFn =>
      widget.searchMatchFn ?? widget.config?.searchMatchFn ?? defaultFilterMatch;

  bool get _resolvedEnableKeyboardNavigation =>
      widget.enableKeyboardNavigation ?? widget.config?.enableKeyboardNavigation ?? true;

  double? get _resolvedMaxHeight =>
      widget.maxHeight ?? widget.config?.maxHeight;

  Offset get _resolvedOffset =>
      widget.offset ?? widget.config?.offset ?? const Offset(0, 5);

  bool get _resolvedCloseOnSelect =>
      widget.closeOnSelect ?? widget.config?.closeOnSelect ?? true;

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _toggleOverlay() {
    if (_isOverlayVisible) {
      _hideOverlay();
      _focusNode.unfocus();
    } else {
      _showOverlay();
      _focusNode.requestFocus();
    }
  }

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

  void _updateFilteredItems() {
    if (!_resolvedEnableSearch || _searchController == null || _searchController!.text.isEmpty) {
      _filteredItems = widget.items;
    } else {
      _filteredItems = widget.items
          .where((item) => _resolvedSearchMatchFn(item, _searchController!.text))
          .toList();
    }

    // Reset highlight when filtered items change
    if (_highlightedIndex >= _filteredItems.length) {
      _highlightedIndex = -1;
    }

    if (mounted) {
      setState(() {});
    }
  }

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

    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      if (_highlightedIndex >= 0 && _highlightedIndex < _filteredItems.length) {
        _selectItem(_filteredItems[_highlightedIndex].value);
      }
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
      if (_filteredItems.isEmpty) {
        _highlightedIndex = -1;
      } else {
        _highlightedIndex = (_highlightedIndex + 1) % _filteredItems.length;
      }
    });
    _scrollToHighlighted();
  }

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

  void _scrollToHighlighted() {
    if (_highlightedIndex < 0) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final itemHeight = _resolvedItemHeight;
        final offset = _highlightedIndex * itemHeight;
        final viewportHeight = _scrollController.position.viewportDimension;
        final currentScroll = _scrollController.offset;

        // Scroll if item is outside visible area
        if (offset < currentScroll || offset + itemHeight > currentScroll + viewportHeight) {
          _scrollController.animateTo(
            offset - (viewportHeight / 2) + (itemHeight / 2),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void _selectItem(T? value) {
    widget.onChanged?.call(value);
    widget.controller?.selectedValue = value;

    if (_resolvedCloseOnSelect) {
      _hideOverlay();
    }
  }

  MenuItem<T>? get _selectedItem {
    if (widget.value == null) return null;
    try {
      return widget.items.firstWhere((item) => item.value == widget.value);
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildSelectedDisplay()),
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

  Widget _buildSelectedDisplay() {
    final selectedItem = _selectedItem;

    if (selectedItem == null) {
      return widget.hint ??
          Text(
            'Select...',
            style: _resolvedHintStyle,
          );
    }

    return switch (selectedItem) {
      MenuItemString<T> item => Text(
        item.label,
        style: _resolvedTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
      MenuItemWidget<T> item => item.widget,
    };
  }

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
                    shape: _resolvedDropdownBorder ??
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

  Widget _buildMenuContent() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: _resolvedMaxHeight ?? MediaQuery.of(context).size.height * 0.4,
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
                itemBuilder: (context, index) => _buildItem(_filteredItems[index], index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: _resolvedSearchHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        autofocus: false,
      ),
    );
  }

  Widget _buildItem(MenuItem<T> item, int index) {
    final isHighlighted = index == _highlightedIndex;
    final isSelected = item.value == widget.value;

    return Material(
      color: isHighlighted
          ? _resolvedItemHighlightColor
          : isSelected
          ? _resolvedSelectedItemColor
          : Colors.transparent,
      child: InkWell(
        onTap: () => _selectItem(item.value),
        child: Container(
          height: _resolvedItemHeight,
          padding: _resolvedItemPadding,
          alignment: Alignment.centerLeft,
          child: switch (item) {
            MenuItemString<T> stringItem => Text(
              stringItem.label,
              style: _resolvedItemTextStyle,
            ),
            MenuItemWidget<T> widgetItem => widgetItem.widget,
          },
        ),
      ),
    );
  }
}


/// Controller for programmatic control of MenuFlow dropdown.
/// Provides methods to show/hide the dropdown and access selected value.
class MenuControl<T> extends ChangeNotifier {
  T? _selectedValue;
  bool _isOpen = false;
  VoidCallback? _showCallback;
  VoidCallback? _hideCallback;

  /// Gets the currently selected value
  T? get selectedValue => _selectedValue;

  /// Sets the selected value and notifies listeners
  set selectedValue(T? value) {
    if (_selectedValue != value) {
      _selectedValue = value;
      notifyListeners();
    }
  }

  /// Returns true if the dropdown is currently open
  bool get isOpen => _isOpen;

  /// Internal method to update open state
  void setOpen(bool value) {
    if (_isOpen != value) {
      _isOpen = value;
      notifyListeners();
    }
  }

  /// Internal method to register show callback
  void registerShowCallback(VoidCallback callback) {
    _showCallback = callback;
  }

  /// Internal method to register hide callback
  void registerHideCallback(VoidCallback callback) {
    _hideCallback = callback;
  }

  /// Shows the dropdown menu
  void show() {
    _showCallback?.call();
  }

  /// Hides the dropdown menu
  void hide() {
    _hideCallback?.call();
  }

  /// Toggles the dropdown menu (show if hidden, hide if shown)
  void toggle() {
    if (_isOpen) {
      hide();
    } else {
      show();
    }
  }

  @override
  void dispose() {
    _showCallback = null;
    _hideCallback = null;
    super.dispose();
  }
}

/// Type definition for custom filter matching function
typedef FilterMatchFn<T> = bool Function(
    MenuItem<T> item,
    String searchValue,
    );

/// Default filter match function for string-based items (case-insensitive)
bool defaultFilterMatch<T>(MenuItem<T> item, String searchValue) {
  if (item is MenuItemString<T>) {
    return item.label.toLowerCase().contains(searchValue.toLowerCase());
  }
  return false;
}

/// Configuration class for MenuFlow behavior settings.
/// Controls features like search, keyboard navigation, and dropdown behavior.
class MenuConfig {
  const MenuConfig({
    // Search configuration
    this.enableSearch = false,
    this.searchHint = 'Search...',
    this.searchMatchFn,

    // Keyboard navigation
    this.enableKeyboardNavigation = true,
    this.autoScrollOnHighlight = true,

    // Behavior
    this.maxHeight,
    this.closeOnSelect = true,
    this.offset,

    // Animation
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOut,
  });

  // Search configuration
  final bool enableSearch;
  final String searchHint;
  final FilterMatchFn? searchMatchFn;

  // Keyboard navigation
  final bool enableKeyboardNavigation;
  final bool autoScrollOnHighlight;

  // Behavior
  final double? maxHeight;
  final bool closeOnSelect;
  final Offset? offset;

  // Animation
  final Duration animationDuration;
  final Curve animationCurve;

  /// Creates a copy of this config with the given fields replaced with new values.
  MenuConfig copyWith({
    bool? enableSearch,
    String? searchHint,
    FilterMatchFn? searchMatchFn,
    bool? enableKeyboardNavigation,
    bool? autoScrollOnHighlight,
    double? maxHeight,
    bool? closeOnSelect,
    Offset? offset,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return MenuConfig(
      enableSearch: enableSearch ?? this.enableSearch,
      searchHint: searchHint ?? this.searchHint,
      searchMatchFn: searchMatchFn ?? this.searchMatchFn,
      enableKeyboardNavigation:
      enableKeyboardNavigation ?? this.enableKeyboardNavigation,
      autoScrollOnHighlight:
      autoScrollOnHighlight ?? this.autoScrollOnHighlight,
      maxHeight: maxHeight ?? this.maxHeight,
      closeOnSelect: closeOnSelect ?? this.closeOnSelect,
      offset: offset ?? this.offset,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}

/// Defines when the dropdown menu should close after an action.
enum MenuCloseBehavior {
  /// Close the menu when any item is selected or when clicking outside
  all,

  /// Close the menu only when an item is selected (not when clicking outside)
  self,

  /// Don't automatically close the menu
  none,
}

/// Type definition for custom filter callback
typedef MenuFilterCallback<T> = List<T> Function(List<T> entries, String filter);

/// Type definition for custom search callback (returns index of match)
typedef MenuSearchCallback<T> = int? Function(List<T> entries, String query);

/// Theme data class for MenuFlow styling.
/// Provides a centralized way to configure the appearance of the dropdown.
class MenuTheme {
  const MenuTheme({
    // Button styling
    this.backgroundColor,
    this.borderColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.elevation,

    // Icon styling
    this.iconColor,
    this.icon,
    this.iconSize,
    this.disableIconRotation,

    // Dropdown styling
    this.dropdownColor,
    this.dropdownElevation,
    this.dropdownBorderRadius,
    this.dropdownPadding,
    this.dropdownBorder,

    // Item styling
    this.itemHeight,
    this.itemPadding,
    this.itemHighlightColor,
    this.selectedItemColor,
    this.itemTextStyle,

    // Search styling
    this.searchTextStyle,
    this.searchDecoration,
    this.searchFieldHeight,

    // Text styling
    this.textStyle,
    this.hintStyle,
  });

  // Button styling
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderSide? border;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  // Icon styling
  final Color? iconColor;
  final IconData? icon;
  final double? iconSize;
  final bool? disableIconRotation;

  // Dropdown styling
  final Color? dropdownColor;
  final double? dropdownElevation;
  final BorderRadius? dropdownBorderRadius;
  final EdgeInsetsGeometry? dropdownPadding;
  final ShapeBorder? dropdownBorder;

  // Item styling
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final Color? itemHighlightColor;
  final Color? selectedItemColor;
  final TextStyle? itemTextStyle;

  // Search styling
  final TextStyle? searchTextStyle;
  final InputDecoration? searchDecoration;
  final double? searchFieldHeight;

  // Text styling
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  /// Creates a copy of this theme with the given fields replaced with new values.
  MenuTheme copyWith({
    Color? backgroundColor,
    Color? borderColor,
    BorderSide? border,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    double? elevation,
    Color? iconColor,
    IconData? icon,
    double? iconSize,
    bool? disableIconRotation,
    Color? dropdownColor,
    double? dropdownElevation,
    BorderRadius? dropdownBorderRadius,
    EdgeInsetsGeometry? dropdownPadding,
    ShapeBorder? dropdownBorder,
    double? itemHeight,
    EdgeInsetsGeometry? itemPadding,
    Color? itemHighlightColor,
    Color? selectedItemColor,
    TextStyle? itemTextStyle,
    TextStyle? searchTextStyle,
    InputDecoration? searchDecoration,
    double? searchFieldHeight,
    TextStyle? textStyle,
    TextStyle? hintStyle,
  }) {
    return MenuTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      elevation: elevation ?? this.elevation,
      iconColor: iconColor ?? this.iconColor,
      icon: icon ?? this.icon,
      iconSize: iconSize ?? this.iconSize,
      disableIconRotation: disableIconRotation ?? this.disableIconRotation,
      dropdownColor: dropdownColor ?? this.dropdownColor,
      dropdownElevation: dropdownElevation ?? this.dropdownElevation,
      dropdownBorderRadius: dropdownBorderRadius ?? this.dropdownBorderRadius,
      dropdownPadding: dropdownPadding ?? this.dropdownPadding,
      dropdownBorder: dropdownBorder ?? this.dropdownBorder,
      itemHeight: itemHeight ?? this.itemHeight,
      itemPadding: itemPadding ?? this.itemPadding,
      itemHighlightColor: itemHighlightColor ?? this.itemHighlightColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      searchTextStyle: searchTextStyle ?? this.searchTextStyle,
      searchDecoration: searchDecoration ?? this.searchDecoration,
      searchFieldHeight: searchFieldHeight ?? this.searchFieldHeight,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
    );
  }
}

/// A TextField-based dropdown menu with MenuFlow's modern overlay system.
///
/// Features:
/// - Type to filter/search items
/// - Form field integration (label, helper text, error text)
/// - Leading and trailing icons
/// - Custom styling per item
/// - Enabled/disabled state
/// - Custom filter and search callbacks
/// - Configurable close behavior
///
/// Example:
/// ```dart
/// MenuFlowTextField<String>(
///   entries: [
///     MenuFlowEntry(value: 'apple', label: 'Apple'),
///     MenuFlowEntry(value: 'banana', label: 'Banana'),
///   ],
///   label: Text('Fruit'),
///   onSelected: (value) => print(value),
/// )
/// ```
class MenuTextField<T> extends StatefulWidget {
  const MenuTextField({
    super.key,
    required this.entries,
    this.initialSelection,
    this.onSelected,
    this.controller,
    this.focusNode,
    // Appearance
    this.enabled = true,
    this.width,
    this.menuHeight,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.leadingIcon,
    this.trailingIcon,
    this.showTrailingIcon = true,
    this.selectedTrailingIcon,
    // Filtering/Search
    this.enableFilter = true,
    this.enableSearch = true,
    this.filterCallback,
    this.searchCallback,
    // Text field properties
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.cursorHeight,
    // Behavior
    this.closeBehavior = MenuCloseBehavior.all,
    this.requestFocusOnTap,
    // Theming
    this.theme,
    this.inputDecoration,
    // Positioning
    this.offset,
  });

  /// List of menu entries
  final List<MenuEntry<T>> entries;

  /// Initial selected value
  final T? initialSelection;

  /// Callback when an entry is selected
  final ValueChanged<T?>? onSelected;

  /// Optional text controller
  final TextEditingController? controller;

  /// Optional focus node
  final FocusNode? focusNode;

  // Appearance
  final bool enabled;
  final double? width;
  final double? menuHeight;
  final Widget? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool showTrailingIcon;
  final Widget? selectedTrailingIcon;

  // Filtering/Search
  final bool enableFilter;
  final bool enableSearch;
  final MenuFilterCallback<MenuEntry<T>>? filterCallback;
  final MenuSearchCallback<MenuEntry<T>>? searchCallback;

  // Text field properties
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final double? cursorHeight;

  // Behavior
  final MenuCloseBehavior closeBehavior;
  final bool? requestFocusOnTap;

  // Theming
  final MenuTheme? theme;
  final InputDecoration? inputDecoration;

  // Positioning
  final Offset? offset;

  @override
  State<MenuTextField<T>> createState() => _MenuTextFieldState<T>();
}

class _MenuTextFieldState<T> extends State<MenuTextField<T>> {
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
  bool _enableFilter = false;
  bool _enableSearch = false;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _enableSearch = widget.enableSearch;
    _filteredEntries = widget.entries;

    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

    _initializeSelection();

    // Register keyboard handler
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void didUpdateWidget(MenuTextField<T> oldWidget) {
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

    if (widget.controller == null) {
      _textController.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  void _initializeSelection() {
    if (widget.initialSelection != null) {
      final index = widget.entries.indexWhere((e) => e.value == widget.initialSelection);
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
        _enableFilter = widget.enableFilter;
        _enableSearch = widget.enableSearch;
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

    if (_enableFilter && text.isNotEmpty) {
      if (widget.filterCallback != null) {
        _filteredEntries = widget.filterCallback!(widget.entries, text);
      } else {
        _filteredEntries = widget.entries
            .where((e) => e.label.toLowerCase().contains(text.toLowerCase()))
            .toList();
      }
    } else {
      _filteredEntries = widget.entries;
    }

    // Update highlight
    if (_enableSearch && text.isNotEmpty) {
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
    if (!_isOverlayVisible || !widget.enabled) return false;
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

    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
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
      _enableFilter = false;
      _enableSearch = false;

      if (_filteredEntries.isEmpty) {
        _currentHighlight = null;
        return;
      }

      int next = ((_currentHighlight ?? -1) + 1) % _filteredEntries.length;

      // Skip disabled entries
      while (!_filteredEntries[next].enabled) {
        next = (next + 1) % _filteredEntries.length;
        // Prevent infinite loop if all entries are disabled
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
      _enableFilter = false;
      _enableSearch = false;

      if (_filteredEntries.isEmpty) {
        _currentHighlight = null;
        return;
      }

      int prev = _currentHighlight ?? 0;
      prev = (prev - 1) % _filteredEntries.length;
      if (prev < 0) prev = _filteredEntries.length - 1;

      // Skip disabled entries
      while (!_filteredEntries[prev].enabled) {
        prev = prev - 1;
        if (prev < 0) prev = _filteredEntries.length - 1;
        // Prevent infinite loop if all entries are disabled
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
    if (_currentHighlight != null && _currentHighlight! < _filteredEntries.length) {
      final entry = _filteredEntries[_currentHighlight!];
      if (entry.enabled) {
        _selectEntry(entry, _currentHighlight!);
      }
    }
  }

  void _scrollToHighlight() {
    if (_currentHighlight == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _currentHighlight! < _filteredEntries.length) {
        final itemHeight = 48.0; // Default item height
        final offset = _currentHighlight! * itemHeight;
        final viewportHeight = _scrollController.position.viewportDimension;
        final currentScroll = _scrollController.offset;

        if (offset < currentScroll || offset + itemHeight > currentScroll + viewportHeight) {
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
    if (_isOverlayVisible || !widget.enabled) return;

    setState(() {
      _filteredEntries = widget.entries;
      _enableFilter = false;
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
    _currentHighlight = widget.enableSearch ? index : null;
    widget.onSelected?.call(entry.value);

    if (widget.closeBehavior == MenuCloseBehavior.self ||
        widget.closeBehavior == MenuCloseBehavior.all) {
      _hideOverlay();
    }
  }

  bool _canRequestFocus() {
    return widget.requestFocusOnTap ??
        switch (Theme.of(context).platform) {
          TargetPlatform.iOS || TargetPlatform.android || TargetPlatform.fuchsia => false,
          TargetPlatform.macOS || TargetPlatform.linux || TargetPlatform.windows => true,
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
          decoration: (widget.inputDecoration ??
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
                  ? (widget.selectedTrailingIcon ?? const Icon(Icons.arrow_drop_up))
                  : (widget.trailingIcon ?? const Icon(Icons.arrow_drop_down)),
              onPressed: widget.enabled ? _toggleOverlay : null,
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
                        maxHeight: widget.menuHeight ?? MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _filteredEntries.length,
                        itemBuilder: (context, index) => _buildItem(_filteredEntries[index], index),
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
                child: entry.labelWidget ??
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

/// Base class for MenuFlow items using sealed class pattern for type safety.
/// Items can be either string-based or widget-based.
sealed class MenuItem<T> {
  const MenuItem({required this.value});

  /// The actual value associated with this item
  final T value;
}

/// A menu item that displays a simple text label
final class MenuItemString<T> extends MenuItem<T> {
  const MenuItemString({
    required super.value,
    required this.label,
  });

  /// The text label to display for this item
  final String label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MenuItemString<T> &&
              runtimeType == other.runtimeType &&
              value == other.value &&
              label == other.label;

  @override
  int get hashCode => Object.hash(value, label);
}

/// A menu item that displays a custom widget
final class MenuItemWidget<T> extends MenuItem<T> {
  const MenuItemWidget({
    required super.value,
    required this.widget,
  });

  /// The custom widget to display for this item
  final Widget widget;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MenuItemWidget<T> &&
              runtimeType == other.runtimeType &&
              value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Enhanced menu entry for MenuFlowTextField with additional customization options.
///
/// Supports custom widgets, icons, and styling for individual items.
class MenuEntry<T> {
  const MenuEntry({
    required this.value,
    required this.label,
    this.labelWidget,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
    this.style,
  });

  /// The value associated with this entry
  final T value;

  /// The text label for this entry (used for searching/filtering)
  final String label;

  /// Optional custom widget to display instead of the text label
  final Widget? labelWidget;

  /// Optional leading icon
  final Widget? leadingIcon;

  /// Optional trailing icon
  final Widget? trailingIcon;

  /// Whether this entry is enabled (can be selected)
  final bool enabled;

  /// Optional custom button style for this entry
  final ButtonStyle? style;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MenuEntry<T> &&
              runtimeType == other.runtimeType &&
              value == other.value &&
              label == other.label;

  @override
  int get hashCode => Object.hash(value, label);
}
