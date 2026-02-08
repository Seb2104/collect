part of '../../collect.dart';

class Menu<T> extends StatefulWidget {
  const Menu({
    super.key,
    this.enabled = true,
    this.width,
    this.menuHeight,
    this.leadingIcon,
    this.trailingIcon,
    this.showTrailingIcon = true,
    this.trailingIconFocusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.selectedTrailingIcon,
    this.enableFilter = false,
    this.enableSearch = true,
    this.keyboardType,
    this.textStyle,
    this.textAlign = TextAlign.start,
    Object? inputDecorationTheme,
    this.menuStyle,
    this.controller,
    this.initialSelection,
    this.onSelected,
    this.focusNode,
    this.requestFocusOnTap,
    this.expandedInsets,
    this.filterCallback,
    this.searchCallback,
    this.alignmentOffset,
    required this.items,
    this.inputFormatters,
    this.closeBehavior = MenuCloseBehavior.all,
    this.maxLines = 1,
    this.textInputAction,
    this.cursorHeight,
    this.restorationId,
    this.menuController,
  }) : assert(filterCallback == null || enableFilter),
       assert(
         inputDecorationTheme == null ||
             (inputDecorationTheme is InputDecorationTheme ||
                 inputDecorationTheme is InputDecorationThemeData),
       ),
       assert(trailingIconFocusNode == null || showTrailingIcon),
       _inputDecorationTheme = inputDecorationTheme;

  final bool enabled;
  final double? width;
  final double? menuHeight;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool showTrailingIcon;
  final FocusNode? trailingIconFocusNode;
  final Widget? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? selectedTrailingIcon;
  final bool enableFilter;
  final bool enableSearch;
  final TextInputType? keyboardType;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final Object? _inputDecorationTheme;
  final MenuStyle? menuStyle;
  final TextEditingController? controller;
  final T? initialSelection;
  final ValueChanged<T?>? onSelected;
  final FocusNode? focusNode;
  final bool? requestFocusOnTap;
  final List<MenuEntry<T>> items;
  final EdgeInsetsGeometry? expandedInsets;
  final FilterCallback<T>? filterCallback;
  final SearchCallback<T>? searchCallback;
  final List<TextInputFormatter>? inputFormatters;
  final Offset? alignmentOffset;
  final MenuCloseBehavior closeBehavior;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final double? cursorHeight;
  final String? restorationId;
  final MenuController? menuController;

  InputDecorationThemeData? get inputDecorationTheme {
    if (_inputDecorationTheme == null) return null;
    return _inputDecorationTheme is InputDecorationTheme
        ? _inputDecorationTheme.data
        : _inputDecorationTheme as InputDecorationThemeData;
  }

  @override
  State<Menu<T>> createState() => _MenuState<T>();
}
class _MenuState<T> extends State<Menu<T>> {
  final GlobalKey _anchorKey = GlobalKey();
  final GlobalKey _leadingKey = GlobalKey();
  final FocusNode _internalFocusNode = FocusNode();

  late List<GlobalKey> _buttonKeys;
  late MenuController _controller;
  late List<MenuEntry<T>> _filteredEntries;

  TextEditingController? _localTextController;
  FocusNode? _localTrailingIconFocusNode;
  List<Widget>? _initialMenu;

  bool _enableFilter = false;
  late bool _enableSearch;
  bool _menuHasEnabledItem = false;

  int? _currentHighlight;
  int? _selectedEntryIndex;
  double? _leadingPadding;

  TextEditingController get _textController =>
      widget.controller ?? (_localTextController ??= TextEditingController());

  FocusNode get _trailingIconFocusNode =>
      widget.trailingIconFocusNode ?? (_localTrailingIconFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _textController.addListener(_clearSelectedEntryIndex);
    _enableSearch = widget.enableSearch;
    _filteredEntries = widget.items;
    _buttonKeys = List.generate(widget.items.length, (_) => GlobalKey());
    _menuHasEnabledItem = _filteredEntries.any((e) => e.enabled);
    _controller = widget.menuController ?? MenuController();
    _initializeSelection();
    _refreshLeadingPadding();
  }

  void _initializeSelection() {
    final index = _filteredEntries.indexWhere((e) => e.value == widget.initialSelection);
    if (index != -1) {
      _updateTextController(_filteredEntries[index].label);
      _selectedEntryIndex = index;
    }
  }

  void _updateTextController(String text) {
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _clearSelectedEntryIndex() => _selectedEntryIndex = null;

  @override
  void dispose() {
    _textController.removeListener(_clearSelectedEntryIndex);
    _localTextController?.dispose();
    _internalFocusNode.dispose();
    _localTrailingIconFocusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Menu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_clearSelectedEntryIndex);
      _localTextController?.dispose();
      _localTextController = null;
      _textController.addListener(_clearSelectedEntryIndex);
      _selectedEntryIndex = null;
    }

    if (!widget.enableFilter) _enableFilter = false;
    if (!widget.enableSearch) {
      _enableSearch = false;
      _currentHighlight = null;
    }

    if (oldWidget.items != widget.items) {
      _currentHighlight = null;
      _filteredEntries = widget.items;
      _buttonKeys = List.generate(widget.items.length, (_) => GlobalKey());
      _menuHasEnabledItem = _filteredEntries.any((e) => e.enabled);
      _updateSelectionAfterItemsChange(oldWidget);
    }

    if (oldWidget.leadingIcon != widget.leadingIcon) _refreshLeadingPadding();
    if (oldWidget.initialSelection != widget.initialSelection) _initializeSelection();
    if (oldWidget.menuController != widget.menuController) {
      _controller = widget.menuController ?? MenuController();
    }
  }

  void _updateSelectionAfterItemsChange(Menu<T> oldWidget) {
    if (_selectedEntryIndex != null) {
      final oldValue = oldWidget.items[_selectedEntryIndex!].value;
      final newIndex = _filteredEntries.indexWhere((e) => e.value == oldValue);
      if (newIndex != -1) {
        _updateTextController(_filteredEntries[newIndex].label);
        _selectedEntryIndex = newIndex;
      } else {
        _selectedEntryIndex = null;
      }
    }
  }

  bool _canRequestFocus() {
    return widget.focusNode?.canRequestFocus ??
        widget.requestFocusOnTap ??
        switch (Theme.of(context).platform) {
          TargetPlatform.iOS || TargetPlatform.android || TargetPlatform.fuchsia => false,
          TargetPlatform.macOS || TargetPlatform.linux || TargetPlatform.windows => true,
        };
  }

  void _refreshLeadingPadding() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _leadingPadding = _getWidth(_leadingKey));
    }, debugLabel: 'Menu.refreshLeadingPadding');
  }

  void _scrollToHighlight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _buttonKeys[_currentHighlight!].currentContext;
      if (context != null) {
        Scrollable.of(context).position.ensureVisible(context.findRenderObject()!);
      }
    }, debugLabel: 'Menu.scrollToHighlight');
  }

  double? _getWidth(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final box = context.findRenderObject()! as RenderBox;
      return box.hasSize ? box.size.width : null;
    }
    return null;
  }

  List<MenuEntry<T>> _filterEntries(List<MenuEntry<T>> entries, String text) {
    final filterText = text.toLowerCase();
    return entries.where((e) => e.label.toLowerCase().contains(filterText)).toList();
  }

  int? _searchEntries(List<MenuEntry<T>> entries, String text) {
    final searchText = text.toLowerCase();
    if (searchText.isEmpty) return null;
    final index = entries.indexWhere((e) => e.label.toLowerCase().contains(searchText));
    return index != -1 ? index : null;
  }

  bool _shouldUpdateHighlight(List<MenuEntry<T>> entries) {
    final searchText = _textController.text.toLowerCase();
    if (searchText.isEmpty) return true;
    if (_currentHighlight == null || _currentHighlight! >= entries.length) return true;
    return !entries[_currentHighlight!].label.toLowerCase().contains(searchText);
  }

  void _handleUpKey(ArrowUpIntent _) {
    if (!widget.enabled || !_menuHasEnabledItem || !_controller.isOpen) return;

    setState(() {
      _enableFilter = false;
      _enableSearch = false;
      _currentHighlight = ((_currentHighlight ?? 0) - 1) % _filteredEntries.length;
      while (!_filteredEntries[_currentHighlight!].enabled) {
        _currentHighlight = (_currentHighlight! - 1) % _filteredEntries.length;
      }
      _updateTextController(_filteredEntries[_currentHighlight!].label);
    });
  }

  void _handleDownKey(ArrowDownIntent _) {
    if (!widget.enabled || !_menuHasEnabledItem || !_controller.isOpen) return;

    setState(() {
      _enableFilter = false;
      _enableSearch = false;
      _currentHighlight = ((_currentHighlight ?? -1) + 1) % _filteredEntries.length;
      while (!_filteredEntries[_currentHighlight!].enabled) {
        _currentHighlight = (_currentHighlight! + 1) % _filteredEntries.length;
      }
      _updateTextController(_filteredEntries[_currentHighlight!].label);
    });
  }

  void _toggleMenu({bool focusForKeyboard = true}) {
    if (_controller.isOpen) {
      _currentHighlight = null;
      _controller.close();
    } else {
      _filteredEntries = widget.items;
      if (_textController.text.isNotEmpty) _enableFilter = false;
      _controller.open();
      if (focusForKeyboard) _internalFocusNode.requestFocus();
    }
    setState(() {});
  }

  void _handleEditingComplete() {
    if (_currentHighlight != null) {
      final entry = _filteredEntries[_currentHighlight!];
      if (entry.enabled) {
        _updateTextController(entry.label);
        _selectedEntryIndex = _currentHighlight;
        widget.onSelected?.call(entry.value);
      }
    } else {
      if (_controller.isOpen) widget.onSelected?.call(null);
    }
    if (!widget.enableSearch) _currentHighlight = null;
    _controller.close();
  }

  void _selectEntry(MenuEntry<T> entry, int index) {
    if (!mounted) {
      widget.controller?.value = TextEditingValue(
        text: entry.label,
        selection: TextSelection.collapsed(offset: entry.label.length),
      );
      widget.onSelected?.call(entry.value);
      return;
    }

    _updateTextController(entry.label);
    _selectedEntryIndex = index;
    _currentHighlight = widget.enableSearch ? index : null;
    widget.onSelected?.call(entry.value);
    _enableFilter = false;

    if (widget.closeBehavior == MenuCloseBehavior.self) {
      _controller.close();
    }
  }

  Widget _buildMenuItem(MenuEntry<T> entry, int index, {
    bool isFocused = false,
    bool enableScrollToHighlight = true,
    bool excludeSemantics = false,
    required bool useMaterial3,
  }) {
    final padding = entry.leadingIcon == null
        ? (_leadingPadding ?? kDefaultHorizontalPadding)
        : kDefaultHorizontalPadding;

    ButtonStyle style = entry.style ?? MenuItemButton.styleFrom(
      padding: EdgeInsetsDirectional.only(
        start: padding,
        end: kDefaultHorizontalPadding,
      ),
    );

    if (entry.enabled && isFocused) {
      style = _applyFocusedStyle(style, entry);
    }

    Widget label = entry.labelWidget ?? Text(entry.label);
    if (widget.width != null) {
      final horizontalPadding = padding + kDefaultHorizontalPadding +
          (useMaterial3 ? kInputStartGap : 0.0);
      label = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.width! - horizontalPadding),
        child: label,
      );
    }

    return ExcludeSemantics(
      excluding: excludeSemantics,
      child: MenuItemButton(
        key: enableScrollToHighlight ? _buttonKeys[index] : null,
        style: style,
        leadingIcon: entry.leadingIcon,
        trailingIcon: entry.trailingIcon,
        closeOnActivate: widget.closeBehavior == MenuCloseBehavior.all,
        onPressed: entry.enabled && widget.enabled ? () => _selectEntry(entry, index) : null,
        requestFocusOnHover: false,
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: useMaterial3 ? kInputStartGap : 0),
          child: label,
        ),
      ),
    );
  }

  ButtonStyle _applyFocusedStyle(ButtonStyle baseStyle, MenuEntry<T> entry) {
    final themeStyle = MenuButtonTheme.of(context).style;
    final defaultStyle = const MenuItemButton().defaultStyleOf(context);

    Color? resolveFocused(WidgetStateProperty<Color?>? prop) {
      return prop?.resolve({WidgetState.focused});
    }

    final foreground = resolveFocused(entry.style?.foregroundColor ?? themeStyle?.foregroundColor ?? defaultStyle.foregroundColor!)!;
    final icon = resolveFocused(entry.style?.iconColor ?? themeStyle?.iconColor ?? defaultStyle.iconColor!)!;
    final overlay = resolveFocused(entry.style?.overlayColor ?? themeStyle?.overlayColor ?? defaultStyle.overlayColor!)!;
    final background = resolveFocused(entry.style?.backgroundColor ?? themeStyle?.backgroundColor) ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);

    return baseStyle.copyWith(
      backgroundColor: WidgetStatePropertyAll(background),
      foregroundColor: WidgetStatePropertyAll(foreground),
      iconColor: WidgetStatePropertyAll(icon),
      overlayColor: WidgetStatePropertyAll(overlay),
    );
  }

  List<Widget> _buildMenuItems({
    required List<MenuEntry<T>> entries,
    int? focusedIndex,
    bool enableScrollToHighlight = true,
    bool excludeSemantics = false,
    required bool useMaterial3,
  }) {
    return List.generate(entries.length, (i) {
      return _buildMenuItem(
        entries[i],
        i,
        isFocused: i == focusedIndex,
        enableScrollToHighlight: enableScrollToHighlight,
        excludeSemantics: excludeSemantics,
        useMaterial3: useMaterial3,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final useMaterial3 = Theme.of(context).useMaterial3;
    final textDirection = Directionality.of(context);
    final theme = DropdownMenuTheme.of(context);
    final defaults = MenuDefaults(context);

    _initialMenu ??= _buildMenuItems(
      entries: widget.items,
      enableScrollToHighlight: false,
      excludeSemantics: true,
      useMaterial3: useMaterial3,
    );

    if (_enableFilter) {
      _filteredEntries = widget.filterCallback?.call(_filteredEntries, _textController.text) ??
          _filterEntries(widget.items, _textController.text);
    }
    _menuHasEnabledItem = _filteredEntries.any((e) => e.enabled);

    if (_enableSearch) {
      if (_shouldUpdateHighlight(_filteredEntries)) {
        _currentHighlight = widget.searchCallback?.call(_filteredEntries, _textController.text) ??
            _searchEntries(_filteredEntries, _textController.text);
      }
      if (_currentHighlight != null) _scrollToHighlight();
    }

    final menuItems = _buildMenuItems(
      entries: _filteredEntries,
      focusedIndex: _currentHighlight,
      useMaterial3: useMaterial3,
    );

    final textStyle = _getEffectiveTextStyle(theme, defaults);
    final menuStyle = _getEffectiveMenuStyle(theme, defaults);
    final inputDecoration = _getEffectiveInputDecoration(theme, defaults);
    final mouseCursor = widget.enabled
        ? (_canRequestFocus() ? SystemMouseCursors.text : SystemMouseCursors.click)
        : null;

    Widget menuAnchor = MenuAnchor(
      style: menuStyle,
      alignmentOffset: widget.alignmentOffset,
      reservedPadding: EdgeInsets.zero,
      controller: _controller,
      menuChildren: menuItems,
      crossAxisUnconstrained: false,
      builder: (context, controller, child) => _buildMenuAnchorContent(
        controller,
        textStyle,
        inputDecoration,
        mouseCursor,
      ),
    );

    if (widget.expandedInsets != null) {
      menuAnchor = Padding(
        padding: widget.expandedInsets!.clamp(
          EdgeInsets.zero,
          const EdgeInsets.only(left: double.infinity, right: double.infinity)
              .add(const EdgeInsetsDirectional.only(end: double.infinity, start: double.infinity)),
        ),
        child: menuAnchor,
      );
    }

    menuAnchor = Align(
      alignment: AlignmentDirectional.topStart,
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: menuAnchor,
    );

    return Actions(
      actions: {
        ArrowUpIntent: CallbackAction<ArrowUpIntent>(onInvoke: _handleUpKey),
        ArrowDownIntent: CallbackAction<ArrowDownIntent>(onInvoke: _handleDownKey),
        EnterIntent: CallbackAction<EnterIntent>(onInvoke: (_) => _handleEditingComplete()),
      },
      child: Stack(
        children: [
          Shortcuts(
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.arrowUp): ArrowUpIntent(),
              SingleActivator(LogicalKeyboardKey.arrowDown): ArrowDownIntent(),
              SingleActivator(LogicalKeyboardKey.enter): EnterIntent(),
            },
            child: Focus(
              focusNode: _internalFocusNode,
              skipTraversal: true,
              child: const SizedBox.shrink(),
            ),
          ),
          menuAnchor,
        ],
      ),
    );
  }

  Widget _buildMenuAnchorContent(
      MenuController controller,
      TextStyle? textStyle,
      InputDecorationThemeData inputDecoration,
      MouseCursor? mouseCursor,
      ) {
    final isCollapsed = widget.inputDecorationTheme?.isCollapsed ?? false;

    final trailingButton = widget.showTrailingIcon
        ? IconButton(
      focusNode: _trailingIconFocusNode,
      isSelected: controller.isOpen,
      constraints: widget.inputDecorationTheme?.suffixIconConstraints,
      padding: isCollapsed ? EdgeInsets.zero : null,
      icon: widget.trailingIcon ?? const Icon(Icons.keyboard_arrow_down_sharp, size: 16),
      selectedIcon: widget.selectedTrailingIcon ?? const Icon(Icons.keyboard_arrow_up_sharp, size: 16),
      onPressed: widget.enabled ? () => _toggleMenu() : null,
    )
        : const SizedBox.shrink();

    final textField = TextField(
      key: _anchorKey,
      enabled: widget.enabled,
      mouseCursor: mouseCursor,
      focusNode: widget.focusNode,
      canRequestFocus: _canRequestFocus(),
      enableInteractiveSelection: _canRequestFocus(),
      readOnly: !_canRequestFocus(),
      keyboardType: widget.keyboardType,
      textAlign: widget.textAlign,
      textAlignVertical: TextAlignVertical.center,
      maxLines: widget.maxLines,
      textInputAction: widget.textInputAction,
      cursorHeight: widget.cursorHeight,
      style: textStyle,
      controller: _textController,
      onEditingComplete: _handleEditingComplete,
      onTap: widget.enabled ? () => _toggleMenu(focusForKeyboard: !_canRequestFocus()) : null,
      onChanged: (text) {
        controller.open();
        setState(() {
          _filteredEntries = widget.items;
          _enableFilter = widget.enableFilter;
          _enableSearch = widget.enableSearch;
        });
      },
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        label: widget.label,
        hintText: widget.hintText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        prefixIcon: widget.leadingIcon != null ? SizedBox(key: _leadingKey, child: widget.leadingIcon) : null,
        suffixIcon: widget.showTrailingIcon ? trailingButton : null,
      ).applyDefaults(inputDecoration),
      restorationId: widget.restorationId,
    );

    final body = widget.expandedInsets != null
        ? textField
        : MenuBody(
      width: widget.width,
      children: [
        textField,
        ..._initialMenu!.map((item) => ExcludeFocus(excluding: !controller.isOpen, child: item)),
        if (widget.label != null)
          ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: DefaultTextStyle(style: textStyle!, child: widget.label!),
            ),
          ),
        trailingButton,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.leadingIcon ?? const SizedBox.shrink(),
        ),
      ],
    );

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowLeft): ExtendSelectionByCharacterIntent(forward: false, collapseSelection: true),
        SingleActivator(LogicalKeyboardKey.arrowRight): ExtendSelectionByCharacterIntent(forward: true, collapseSelection: true),
        SingleActivator(LogicalKeyboardKey.arrowUp): ArrowUpIntent(),
        SingleActivator(LogicalKeyboardKey.arrowDown): ArrowDownIntent(),
      },
      child: body,
    );
  }

  TextStyle? _getEffectiveTextStyle(DropdownMenuThemeData theme, MenuDefaults defaults) {
    final baseStyle = widget.textStyle ?? theme.textStyle ?? defaults.textStyle;
    final disabledColor = theme.disabledColor ?? defaults.disabledColor;
    return widget.enabled
        ? baseStyle
        : baseStyle?.copyWith(color: disabledColor) ?? TextStyle(color: disabledColor);
  }

  MenuStyle _getEffectiveMenuStyle(DropdownMenuThemeData theme, MenuDefaults defaults) {
    MenuStyle style = widget.menuStyle ?? theme.menuStyle ?? defaults.menuStyle!;
    final anchorWidth = _getWidth(_anchorKey);
    final targetWidth = widget.width ?? anchorWidth;

    if (targetWidth != null) {
      style = style.copyWith(
        minimumSize: WidgetStateProperty.resolveWith((states) {
          final maxWidth = style.maximumSize?.resolve(states)?.width;
          return Size(math.min(targetWidth, maxWidth ?? targetWidth), 0.0);
        }),
      );
    }

    if (widget.menuHeight != null) {
      style = style.copyWith(
        maximumSize: WidgetStatePropertyAll(Size(double.infinity, widget.menuHeight!)),
      );
    }

    return style;
  }

  InputDecorationThemeData _getEffectiveInputDecoration(
      DropdownMenuThemeData theme,
      MenuDefaults defaults,
      ) {
    return widget.inputDecorationTheme ?? theme.inputDecorationTheme ?? defaults.inputDecorationTheme!;
  }
}
class MenuEntry<T> {
  final T value;
  final String label;
  final Widget? labelWidget;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool enabled;
  final ButtonStyle? style;

  const MenuEntry({
    required this.value,
    required this.label,
    this.labelWidget,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
    this.style,
  });
}



typedef FilterCallback<T> = List<MenuEntry<T>> Function(List<MenuEntry<T>> entries, String filter);
typedef SearchCallback<T> = int? Function(List<MenuEntry<T>> entries, String query);

class MenuBody extends MultiChildRenderObjectWidget {
  const MenuBody({super.key, super.children, this.width});

  final double? width;

  @override
  RenderMenuBody createRenderObject(BuildContext context) => RenderMenuBody(width: width);

  @override
  void updateRenderObject(BuildContext context, RenderMenuBody renderObject) {
    renderObject.width = width;
  }
}

class MenuBodyParentData extends ContainerBoxParentData<RenderBox> {}

class RenderMenuBody extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MenuBodyParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MenuBodyParentData> {
  RenderMenuBody({double? width}) : _width = width;

  double? get width => _width;
  double? _width;

  set width(double? value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MenuBodyParentData) {
      child.parentData = MenuBodyParentData();
    }
  }

  @override
  void performLayout() {
    final constraints = this.constraints;
    double maxWidth = 0.0;
    double? maxHeight;
    RenderBox? child = firstChild;

    final intrinsicWidth = width ?? getMaxIntrinsicWidth(constraints.maxHeight);
    final widthConstraint = math.min(intrinsicWidth, constraints.maxWidth);
    final innerConstraints = BoxConstraints(
      maxWidth: widthConstraint,
      maxHeight: getMaxIntrinsicHeight(widthConstraint),
    );

    while (child != null) {
      child.layout(innerConstraints, parentUsesSize: true);
      final childParentData = child.parentData! as MenuBodyParentData;

      if (child == firstChild) {
        maxHeight ??= child.size.height;
      } else {
        childParentData.offset = Offset.zero;
        maxWidth = math.max(maxWidth, child.size.width);
        maxHeight ??= child.size.height;
      }

      child = childParentData.nextSibling;
    }

    maxWidth = math.max(kMinimumWidth, maxWidth);
    size = constraints.constrain(Size(width ?? maxWidth, maxHeight!));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = firstChild;
    if (child != null) {
      final childParentData = child.parentData! as MenuBodyParentData;
      context.paintChild(child, offset + childParentData.offset);
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    double maxWidth = 0.0;
    double? maxHeight;
    RenderBox? child = firstChild;

    final intrinsicWidth = width ?? getMaxIntrinsicWidth(constraints.maxHeight);
    final widthConstraint = math.min(intrinsicWidth, constraints.maxWidth);
    final innerConstraints = BoxConstraints(
      maxWidth: widthConstraint,
      maxHeight: getMaxIntrinsicHeight(widthConstraint),
    );

    while (child != null) {
      final childSize = child.getDryLayout(innerConstraints);
      final childParentData = child.parentData! as MenuBodyParentData;

      if (child == firstChild) {
        maxHeight ??= childSize.height;
      } else {
        maxWidth = math.max(maxWidth, childSize.width);
        maxHeight ??= childSize.height;
      }

      child = childParentData.nextSibling;
    }

    maxWidth = math.max(kMinimumWidth, maxWidth);
    return constraints.constrain(Size(width ?? maxWidth, maxHeight!));
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    RenderBox? child = firstChild;
    double width = 0;

    while (child != null) {
      final childParentData = child.parentData! as MenuBodyParentData;
      if (child != firstChild) {
        final minWidth = child.getMinIntrinsicWidth(height);
        if (child == lastChild || child == childBefore(lastChild!)) {
          width += minWidth;
        }
        width = math.max(width, minWidth);
      }
      child = childParentData.nextSibling;
    }

    return math.max(width, kMinimumWidth);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    RenderBox? child = firstChild;
    double width = 0;

    while (child != null) {
      final childParentData = child.parentData! as MenuBodyParentData;
      if (child != firstChild) {
        final maxWidth = child.getMaxIntrinsicWidth(height);
        if (child == lastChild || child == childBefore(lastChild!)) {
          width += maxWidth;
        }
        width = math.max(width, maxWidth);
      }
      child = childParentData.nextSibling;
    }

    return math.max(width, kMinimumWidth);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final child = firstChild;
    return child != null ? child.getMinIntrinsicHeight(width) : 0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final child = firstChild;
    return child != null ? child.getMaxIntrinsicHeight(width) : 0;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final child = firstChild;
    if (child != null) {
      final childParentData = child.parentData! as MenuBodyParentData;
      return result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (result, transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
    }
    return false;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    visitChildren((renderObjectChild) {
      if (renderObjectChild == firstChild) visitor(renderObjectChild);
    });
  }
}

class ArrowUpIntent extends Intent {
  const ArrowUpIntent();
}

class ArrowDownIntent extends Intent {
  const ArrowDownIntent();
}

class EnterIntent extends Intent {
  const EnterIntent();
}

const double kMinimumWidth = 112.0;
const double kDefaultHorizontalPadding = 12.0;
const double kInputStartGap = 4.0;

enum MenuCloseBehavior { all, self, none }

class MenuDefaults extends DropdownMenuThemeData {
  MenuDefaults(this.context)
    : super(
        disabledColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
      );

  final BuildContext context;

  @override
  TextStyle? get textStyle => Theme.of(context).textTheme.bodyLarge;

  @override
  MenuStyle get menuStyle {
    return const MenuStyle(
      minimumSize: WidgetStatePropertyAll(Size(kMinimumWidth, 0.0)),
      maximumSize: WidgetStatePropertyAll(Size.infinite),
      visualDensity: VisualDensity.standard,
    );
  }

  @override
  InputDecorationThemeData get inputDecorationTheme {
    return const InputDecorationThemeData(border: OutlineInputBorder());
  }
}


