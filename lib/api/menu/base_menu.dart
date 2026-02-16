part of 'menu.dart';

class Menu extends StatefulWidget {
  const Menu({
    super.key,
    required this.items,
    required this.value,
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

  final List<String> items;
  final String value;
  final ValueChanged<String>? onChanged;
  final Widget? hint;
  final double? width;
  final double? height;
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

  final MenuConfig? config;
  final bool? enableSearch;
  final String? searchHint;
  final FilterMatchFn? searchMatchFn;
  final bool? enableKeyboardNavigation;
  final double? maxHeight;
  final Offset? offset;
  final bool? closeOnSelect;

  final MenuControl? controller;

  final FocusNode? focusNode;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState<T> extends State<Menu> {
  late final FocusNode _focusNode;
  late final LayerLink _layerLink;
  final ScrollController _scrollController = ScrollController();

  OverlayEntry? _overlayEntry;
  TextEditingController? _searchController;
  List<String> _filteredItems = [];
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
  void didUpdateWidget(Menu oldWidget) {
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

  void _selectItem(String? value) {
    widget.onChanged?.call(value!);
    widget.controller?.selectedValue = value;

    if (_resolvedCloseOnSelect) {
      _hideOverlay();
    }
  }

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

  Widget _buildSelectedDisplay() {
    final selectedItem = _selectedItem;
    return Word(selectedItem ?? "");
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
