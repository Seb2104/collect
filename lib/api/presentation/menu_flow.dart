part of '../../collect.dart';

class MenuFlow<T> extends StatefulWidget {
  const MenuFlow({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.width,
    this.height,
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
    this.config,
    this.enableSearch,
    this.searchHint,
    this.searchMatchFn,
    this.enableKeyboardNavigation,
    this.maxHeight,
    this.offset,
    this.closeOnSelect,
    this.controller,
    this.focusNode,
  });

  final List<MenuFlowItem<T>> items;

  final T? value;

  final ValueChanged<T?>? onChanged;

  final Widget? hint;

  final double? width;

  final double? height;

  final MenuFlowTheme? theme;
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

  final MenuFlowConfig? config;
  final bool? enableSearch;
  final String? searchHint;
  final FilterMatchFn<T>? searchMatchFn;
  final bool? enableKeyboardNavigation;
  final double? maxHeight;
  final Offset? offset;
  final bool? closeOnSelect;

  final MenuFlowController<T>? controller;

  final FocusNode? focusNode;

  @override
  State<MenuFlow<T>> createState() => _MenuFlowState<T>();
}

class _MenuFlowState<T> extends State<MenuFlow<T>> {
  late final FocusNode _focusNode;
  late final LayerLink _layerLink;
  final ScrollController _scrollController = ScrollController();

  OverlayEntry? _overlayEntry;
  TextEditingController? _searchController;
  List<MenuFlowItem<T>> _filteredItems = [];
  int _highlightedIndex = -1;
  double _iconTurns = 0;

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
  void didUpdateWidget(MenuFlow<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items != widget.items) {
      _updateFilteredItems();
    }

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

  Color get _resolvedBackgroundColor =>
      widget.backgroundColor ?? widget.theme?.backgroundColor ?? Colors.white;

  Color get _resolvedBorderColor =>
      widget.borderColor ?? widget.theme?.borderColor ?? Colors.grey.shade300;

  BorderSide get _resolvedBorder =>
      widget.border ??
      widget.theme?.border ??
      BorderSide(color: _resolvedBorderColor);

  BorderRadius get _resolvedBorderRadius =>
      widget.borderRadius ??
      widget.theme?.borderRadius ??
      BorderRadius.circular(8);

  EdgeInsetsGeometry get _resolvedPadding =>
      widget.padding ??
      widget.theme?.padding ??
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

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
      widget.dropdownPadding ??
      widget.theme?.dropdownPadding ??
      const EdgeInsets.symmetric(vertical: 8);

  ShapeBorder? get _resolvedDropdownBorder =>
      widget.dropdownBorder ?? widget.theme?.dropdownBorder;

  double get _resolvedItemHeight =>
      widget.itemHeight ?? widget.theme?.itemHeight ?? 48;

  EdgeInsetsGeometry get _resolvedItemPadding =>
      widget.itemPadding ??
      widget.theme?.itemPadding ??
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

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
      widget.hintStyle ??
      widget.theme?.hintStyle ??
      TextStyle(color: Colors.grey.shade600);

  bool get _resolvedEnableSearch =>
      widget.enableSearch ?? widget.config?.enableSearch ?? false;

  String get _resolvedSearchHint =>
      widget.searchHint ?? widget.config?.searchHint ?? 'Search...';

  FilterMatchFn<T> get _resolvedSearchMatchFn =>
      widget.searchMatchFn ??
      widget.config?.searchMatchFn ??
      defaultFilterMatch;

  bool get _resolvedEnableKeyboardNavigation =>
      widget.enableKeyboardNavigation ??
      widget.config?.enableKeyboardNavigation ??
      true;

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

  void _selectItem(T? value) {
    widget.onChanged?.call(value);
    widget.controller?.selectedValue = value;

    if (_resolvedCloseOnSelect) {
      _hideOverlay();
    }
  }

  MenuFlowItem<T>? get _selectedItem {
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
      return widget.hint ?? Text('Select...', style: _resolvedHintStyle);
    }

    return switch (selectedItem) {
      MenuFlowItemString<T> item => Text(
        item.label,
        style: _resolvedTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
      MenuFlowItemWidget<T> item => item.widget,
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

  Widget _buildItem(MenuFlowItem<T> item, int index) {
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
            MenuFlowItemString<T> stringItem => Text(
              stringItem.label,
              style: _resolvedItemTextStyle,
            ),
            MenuFlowItemWidget<T> widgetItem => widgetItem.widget,
          },
        ),
      ),
    );
  }
}

typedef FilterMatchFn<T> =
    bool Function(MenuFlowItem<T> item, String searchValue);

bool defaultFilterMatch<T>(MenuFlowItem<T> item, String searchValue) {
  if (item is MenuFlowItemString<T>) {
    return item.label.toLowerCase().contains(searchValue.toLowerCase());
  }
  return false;
}

class MenuFlowConfig {
  const MenuFlowConfig({
    this.enableSearch = false,
    this.searchHint = 'Search...',
    this.searchMatchFn,

    this.enableKeyboardNavigation = true,
    this.autoScrollOnHighlight = true,

    this.maxHeight,
    this.closeOnSelect = true,
    this.offset,

    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOut,
  });

  final bool enableSearch;
  final String searchHint;
  final FilterMatchFn? searchMatchFn;

  final bool enableKeyboardNavigation;
  final bool autoScrollOnHighlight;

  final double? maxHeight;
  final bool closeOnSelect;
  final Offset? offset;

  final Duration animationDuration;
  final Curve animationCurve;

  MenuFlowConfig copyWith({
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
    return MenuFlowConfig(
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

class MenuFlowController<T> extends ChangeNotifier {
  T? _selectedValue;
  bool _isOpen = false;
  VoidCallback? _showCallback;
  VoidCallback? _hideCallback;

  T? get selectedValue => _selectedValue;

  set selectedValue(T? value) {
    if (_selectedValue != value) {
      _selectedValue = value;
      notifyListeners();
    }
  }

  bool get isOpen => _isOpen;

  void setOpen(bool value) {
    if (_isOpen != value) {
      _isOpen = value;
      notifyListeners();
    }
  }

  void registerShowCallback(VoidCallback callback) {
    _showCallback = callback;
  }

  void registerHideCallback(VoidCallback callback) {
    _hideCallback = callback;
  }

  void show() {
    _showCallback?.call();
  }

  void hide() {
    _hideCallback?.call();
  }

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

sealed class MenuFlowItem<T> {
  const MenuFlowItem({required this.value});

  final T value;
}

final class MenuFlowItemString<T> extends MenuFlowItem<T> {
  const MenuFlowItemString({required super.value, required this.label});

  final String label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuFlowItemString<T> &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          label == other.label;

  @override
  int get hashCode => Object.hash(value, label);
}

final class MenuFlowItemWidget<T> extends MenuFlowItem<T> {
  const MenuFlowItemWidget({required super.value, required this.widget});

  final Widget widget;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuFlowItemWidget<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class MenuFlowTheme {
  const MenuFlowTheme({
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

    this.searchTextStyle,
    this.searchDecoration,
    this.searchFieldHeight,

    this.textStyle,
    this.hintStyle,
  });

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

  final TextStyle? searchTextStyle;
  final InputDecoration? searchDecoration;
  final double? searchFieldHeight;

  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  MenuFlowTheme copyWith({
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
    return MenuFlowTheme(
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
