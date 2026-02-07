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

  InputDecorationThemeData? get inputDecorationTheme {
    if (_inputDecorationTheme == null) {
      return null;
    }
    return _inputDecorationTheme is InputDecorationTheme
        ? _inputDecorationTheme.data
        : _inputDecorationTheme as InputDecorationThemeData;
  }

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

  @override
  State<Menu<T>> createState() => _MenuState<T>();
}

class _MenuState<T> extends State<Menu<T>> {
  final GlobalKey _anchorKey = GlobalKey();
  final GlobalKey _leadingKey = GlobalKey();
  late List<GlobalKey> buttonItemKeys;
  late MenuController _controller;
  bool _enableFilter = false;
  late bool _enableSearch;
  late List<MenuEntry<T>> filteredEntries;
  List<Widget>? _initialMenu;
  int? currentHighlight;
  double? leadingPadding;
  bool _menuHasEnabledItem = false;
  TextEditingController? _localTextEditingController;

  TextEditingController get _effectiveTextEditingController =>
      widget.controller ??
      (_localTextEditingController ??= TextEditingController());
  final FocusNode _internalFocudeNode = FocusNode();
  int? _selectedEntryIndex;
  late final void Function() _clearSelectedEntryIndex;

  FocusNode? _localTrailingIconButtonFocusNode;

  FocusNode get _trailingIconButtonFocusNode =>
      widget.trailingIconFocusNode ??
      (_localTrailingIconButtonFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _clearSelectedEntryIndex = () => _selectedEntryIndex = null;
    _effectiveTextEditingController.addListener(_clearSelectedEntryIndex);
    _enableSearch = widget.enableSearch;
    filteredEntries = widget.items;
    buttonItemKeys = List<GlobalKey>.generate(
      filteredEntries.length,
      (int index) => GlobalKey(),
    );
    _menuHasEnabledItem = filteredEntries.any(
      (MenuEntry<T> entry) => entry.enabled,
    );
    final int index = filteredEntries.indexWhere(
      (MenuEntry<T> entry) => entry.value == widget.initialSelection,
    );
    if (index != -1) {
      _effectiveTextEditingController.value = TextEditingValue(
        text: filteredEntries[index].label,
        selection: TextSelection.collapsed(
          offset: filteredEntries[index].label.length,
        ),
      );
      _selectedEntryIndex = index;
    }
    refreshLeadingPadding();
    _controller = widget.menuController ?? MenuController();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_clearSelectedEntryIndex);
    _localTextEditingController?.dispose();
    _localTextEditingController = null;
    _internalFocudeNode.dispose();
    _localTrailingIconButtonFocusNode?.dispose();
    _localTrailingIconButtonFocusNode = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(Menu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_clearSelectedEntryIndex);
      _localTextEditingController?.dispose();
      _localTextEditingController = null;
      _effectiveTextEditingController.addListener(_clearSelectedEntryIndex);
      _selectedEntryIndex = null;
    }
    if (oldWidget.enableFilter != widget.enableFilter) {
      if (!widget.enableFilter) {
        _enableFilter = false;
      }
    }
    if (oldWidget.enableSearch != widget.enableSearch) {
      if (!widget.enableSearch) {
        _enableSearch = widget.enableSearch;
        currentHighlight = null;
      }
    }
    if (oldWidget.items != widget.items) {
      currentHighlight = null;
      filteredEntries = widget.items;
      buttonItemKeys = List<GlobalKey>.generate(
        filteredEntries.length,
        (int index) => GlobalKey(),
      );
      _menuHasEnabledItem = filteredEntries.any(
        (MenuEntry<T> entry) => entry.enabled,
      );
      if (_selectedEntryIndex != null) {
        final T oldSelectionValue = oldWidget.items[_selectedEntryIndex!].value;
        final int index = filteredEntries.indexWhere(
          (MenuEntry<T> entry) => entry.value == oldSelectionValue,
        );
        if (index != -1) {
          _effectiveTextEditingController.value = TextEditingValue(
            text: filteredEntries[index].label,
            selection: TextSelection.collapsed(
              offset: filteredEntries[index].label.length,
            ),
          );
          _selectedEntryIndex = index;
        } else {
          _selectedEntryIndex = null;
        }
      }
    }
    if (oldWidget.leadingIcon != widget.leadingIcon) {
      refreshLeadingPadding();
    }
    if (oldWidget.initialSelection != widget.initialSelection) {
      final int index = filteredEntries.indexWhere(
        (MenuEntry<T> entry) => entry.value == widget.initialSelection,
      );
      if (index != -1) {
        _effectiveTextEditingController.value = TextEditingValue(
          text: filteredEntries[index].label,
          selection: TextSelection.collapsed(
            offset: filteredEntries[index].label.length,
          ),
        );
        _selectedEntryIndex = index;
      }
    }
    if (oldWidget.menuController != widget.menuController) {
      _controller = widget.menuController ?? MenuController();
    }
  }

  bool canRequestFocus() {
    return widget.focusNode?.canRequestFocus ??
        widget.requestFocusOnTap ??
        switch (Theme.of(context).platform) {
          TargetPlatform.iOS ||
          TargetPlatform.android ||
          TargetPlatform.fuchsia => false,
          TargetPlatform.macOS ||
          TargetPlatform.linux ||
          TargetPlatform.windows => true,
        };
  }

  void refreshLeadingPadding() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        leadingPadding = getWidth(_leadingKey);
      });
    }, debugLabel: 'DropdownMenu.refreshLeadingPadding');
  }

  void scrollToHighlight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? highlightContext =
          buttonItemKeys[currentHighlight!].currentContext;
      if (highlightContext != null) {
        Scrollable.of(
          highlightContext,
        ).position.ensureVisible(highlightContext.findRenderObject()!);
      }
    }, debugLabel: 'DropdownMenu.scrollToHighlight');
  }

  double? getWidth(GlobalKey key) {
    final BuildContext? context = key.currentContext;
    if (context != null) {
      final RenderBox box = context.findRenderObject()! as RenderBox;
      return box.hasSize ? box.size.width : null;
    }
    return null;
  }

  List<MenuEntry<T>> filter(
    List<MenuEntry<T>> entries,
    TextEditingController textEditingController,
  ) {
    final String filterText = textEditingController.text.toLowerCase();
    return entries
        .where(
          (MenuEntry<T> entry) =>
              entry.label.toLowerCase().contains(filterText),
        )
        .toList();
  }

  bool _shouldUpdateCurrentHighlight(List<MenuEntry<T>> entries) {
    final String searchText = _effectiveTextEditingController.value.text
        .toLowerCase();
    if (searchText.isEmpty) {
      return true;
    }

    if (currentHighlight == null || currentHighlight! >= entries.length) {
      return true;
    }

    if (entries[currentHighlight!].label.toLowerCase().contains(searchText)) {
      return false;
    }

    return true;
  }

  int? search(
    List<MenuEntry<T>> entries,
    TextEditingController textEditingController,
  ) {
    final String searchText = textEditingController.value.text.toLowerCase();
    if (searchText.isEmpty) {
      return null;
    }

    final int index = entries.indexWhere(
      (MenuEntry<T> entry) => entry.label.toLowerCase().contains(searchText),
    );

    return index != -1 ? index : null;
  }

  List<Widget> _buildButtons(
    List<MenuEntry<T>> filteredEntries,
    TextDirection textDirection, {
    int? focusedIndex,
    bool enableScrollToHighlight = true,
    bool excludeSemantics = false,
    bool? useMaterial3,
  }) {
    final double effectiveInputStartGap = useMaterial3 ?? false
        ? kInputStartGap
        : 0.0;
    final List<Widget> result = <Widget>[];
    for (int i = 0; i < filteredEntries.length; i++) {
      final MenuEntry<T> entry = filteredEntries[i];

      final double padding = entry.leadingIcon == null
          ? (leadingPadding ?? kDefaultHorizontalPadding)
          : kDefaultHorizontalPadding;
      ButtonStyle effectiveStyle =
          entry.style ??
          MenuItemButton.styleFrom(
            padding: EdgeInsetsDirectional.only(
              start: padding,
              end: kDefaultHorizontalPadding,
            ),
          );

      final ButtonStyle? themeStyle = MenuButtonTheme.of(context).style;

      final WidgetStateProperty<Color?>? effectiveForegroundColor =
          entry.style?.foregroundColor ?? themeStyle?.foregroundColor;
      final WidgetStateProperty<Color?>? effectiveIconColor =
          entry.style?.iconColor ?? themeStyle?.iconColor;
      final WidgetStateProperty<Color?>? effectiveOverlayColor =
          entry.style?.overlayColor ?? themeStyle?.overlayColor;
      final WidgetStateProperty<Color?>? effectiveBackgroundColor =
          entry.style?.backgroundColor ?? themeStyle?.backgroundColor;

      if (entry.enabled && i == focusedIndex) {
        final ButtonStyle defaultStyle = const MenuItemButton().defaultStyleOf(
          context,
        );

        Color? resolveFocusedColor(
          WidgetStateProperty<Color?>? colorStateProperty,
        ) {
          return colorStateProperty?.resolve(<WidgetState>{
            WidgetState.focused,
          });
        }

        final Color focusedForegroundColor = resolveFocusedColor(
          effectiveForegroundColor ?? defaultStyle.foregroundColor!,
        )!;
        final Color focusedIconColor = resolveFocusedColor(
          effectiveIconColor ?? defaultStyle.iconColor!,
        )!;
        final Color focusedOverlayColor = resolveFocusedColor(
          effectiveOverlayColor ?? defaultStyle.overlayColor!,
        )!;
        final Color focusedBackgroundColor =
            resolveFocusedColor(effectiveBackgroundColor) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);

        effectiveStyle = effectiveStyle.copyWith(
          backgroundColor: WidgetStatePropertyAll<Color>(
            focusedBackgroundColor,
          ),
          foregroundColor: WidgetStatePropertyAll<Color>(
            focusedForegroundColor,
          ),
          iconColor: WidgetStatePropertyAll<Color>(focusedIconColor),
          overlayColor: WidgetStatePropertyAll<Color>(focusedOverlayColor),
        );
      } else {
        effectiveStyle = effectiveStyle.copyWith(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          iconColor: effectiveIconColor,
          overlayColor: effectiveOverlayColor,
        );
      }

      Widget label = entry.labelWidget ?? Text(entry.label);
      if (widget.width != null) {
        final double horizontalPadding =
            padding + kDefaultHorizontalPadding + effectiveInputStartGap;
        label = ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widget.width! - horizontalPadding,
          ),
          child: label,
        );
      }

      final Widget menuItemButton = ExcludeSemantics(
        excluding: excludeSemantics,
        child: MenuItemButton(
          key: enableScrollToHighlight ? buttonItemKeys[i] : null,
          style: effectiveStyle,
          leadingIcon: entry.leadingIcon,
          trailingIcon: entry.trailingIcon,
          closeOnActivate: widget.closeBehavior == MenuCloseBehavior.all,
          onPressed: entry.enabled && widget.enabled
              ? () {
                  if (!mounted) {
                    widget.controller?.value = TextEditingValue(
                      text: entry.label,
                      selection: TextSelection.collapsed(
                        offset: entry.label.length,
                      ),
                    );
                    widget.onSelected?.call(entry.value);
                    return;
                  }
                  _effectiveTextEditingController.value = TextEditingValue(
                    text: entry.label,
                    selection: TextSelection.collapsed(
                      offset: entry.label.length,
                    ),
                  );
                  _selectedEntryIndex = i;
                  currentHighlight = widget.enableSearch ? i : null;
                  widget.onSelected?.call(entry.value);
                  _enableFilter = false;
                  if (widget.closeBehavior == MenuCloseBehavior.self) {
                    _controller.close();
                  }
                }
              : null,
          requestFocusOnHover: false,
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: effectiveInputStartGap),
            child: label,
          ),
        ),
      );
      result.add(menuItemButton);
    }

    return result;
  }

  void handleUpKeyInvoke(ArrowUpIntent _) {
    setState(() {
      if (!widget.enabled || !_menuHasEnabledItem || !_controller.isOpen) {
        return;
      }
      _enableFilter = false;
      _enableSearch = false;
      currentHighlight ??= 0;
      currentHighlight = (currentHighlight! - 1) % filteredEntries.length;
      while (!filteredEntries[currentHighlight!].enabled) {
        currentHighlight = (currentHighlight! - 1) % filteredEntries.length;
      }
      final String currentLabel = filteredEntries[currentHighlight!].label;
      _effectiveTextEditingController.value = TextEditingValue(
        text: currentLabel,
        selection: TextSelection.collapsed(offset: currentLabel.length),
      );
    });
  }

  void handleDownKeyInvoke(ArrowDownIntent _) {
    setState(() {
      if (!widget.enabled || !_menuHasEnabledItem || !_controller.isOpen) {
        return;
      }
      _enableFilter = false;
      _enableSearch = false;
      currentHighlight ??= -1;
      currentHighlight = (currentHighlight! + 1) % filteredEntries.length;
      while (!filteredEntries[currentHighlight!].enabled) {
        currentHighlight = (currentHighlight! + 1) % filteredEntries.length;
      }
      final String currentLabel = filteredEntries[currentHighlight!].label;
      _effectiveTextEditingController.value = TextEditingValue(
        text: currentLabel,
        selection: TextSelection.collapsed(offset: currentLabel.length),
      );
    });
  }

  void handlePressed(
    MenuController controller, {
    bool focusForKeyboard = true,
  }) {
    if (controller.isOpen) {
      currentHighlight = null;
      controller.close();
    } else {
      filteredEntries = widget.items;
      if (_effectiveTextEditingController.text.isNotEmpty) {
        _enableFilter = false;
      }
      controller.open();
      if (focusForKeyboard) {
        _internalFocudeNode.requestFocus();
      }
    }
    setState(() {});
  }

  void _handleEditingComplete() {
    if (currentHighlight != null) {
      final MenuEntry<T> entry = filteredEntries[currentHighlight!];
      if (entry.enabled) {
        _effectiveTextEditingController.value = TextEditingValue(
          text: entry.label,
          selection: TextSelection.collapsed(offset: entry.label.length),
        );
        _selectedEntryIndex = currentHighlight;
        widget.onSelected?.call(entry.value);
      }
    } else {
      if (_controller.isOpen) {
        widget.onSelected?.call(null);
      }
    }
    if (!widget.enableSearch) {
      currentHighlight = null;
    }
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    final bool useMaterial3 = Theme.of(context).useMaterial3;
    final TextDirection textDirection = Directionality.of(context);
    _initialMenu ??= _buildButtons(
      widget.items,
      textDirection,
      enableScrollToHighlight: false,
      excludeSemantics: true,
      useMaterial3: useMaterial3,
    );
    final DropdownMenuThemeData theme = DropdownMenuTheme.of(context);
    final DropdownMenuThemeData defaults = MenuDefaults(context);

    if (_enableFilter) {
      filteredEntries =
          widget.filterCallback?.call(
            filteredEntries,
            _effectiveTextEditingController.text,
          ) ??
          filter(widget.items, _effectiveTextEditingController);
    }
    _menuHasEnabledItem = filteredEntries.any(
      (MenuEntry<T> entry) => entry.enabled,
    );

    if (_enableSearch) {
      if (widget.searchCallback != null) {
        currentHighlight = widget.searchCallback!(
          filteredEntries,
          _effectiveTextEditingController.text,
        );
      } else {
        final bool shouldUpdateCurrentHighlight = _shouldUpdateCurrentHighlight(
          filteredEntries,
        );
        if (shouldUpdateCurrentHighlight) {
          currentHighlight = search(
            filteredEntries,
            _effectiveTextEditingController,
          );
        }
      }
      if (currentHighlight != null) {
        scrollToHighlight();
      }
    }

    final List<Widget> menu = _buildButtons(
      filteredEntries,
      textDirection,
      focusedIndex: currentHighlight,
      useMaterial3: useMaterial3,
    );

    final TextStyle? baseTextStyle =
        widget.textStyle ?? theme.textStyle ?? defaults.textStyle;
    final Color? disabledColor = theme.disabledColor ?? defaults.disabledColor;
    final TextStyle? effectiveTextStyle = widget.enabled
        ? baseTextStyle
        : baseTextStyle?.copyWith(color: disabledColor) ??
              TextStyle(color: disabledColor);

    MenuStyle? effectiveMenuStyle =
        widget.menuStyle ?? theme.menuStyle ?? defaults.menuStyle!;

    final double? anchorWidth = getWidth(_anchorKey);
    if (widget.width != null) {
      effectiveMenuStyle = effectiveMenuStyle.copyWith(
        minimumSize: WidgetStateProperty.resolveWith<Size?>((
          Set<WidgetState> states,
        ) {
          final double? effectiveMaximumWidth = effectiveMenuStyle!.maximumSize
              ?.resolve(states)
              ?.width;
          return Size(
            math.min(widget.width!, effectiveMaximumWidth ?? widget.width!),
            0.0,
          );
        }),
      );
    } else if (anchorWidth != null) {
      effectiveMenuStyle = effectiveMenuStyle.copyWith(
        minimumSize: WidgetStateProperty.resolveWith<Size?>((
          Set<WidgetState> states,
        ) {
          final double? effectiveMaximumWidth = effectiveMenuStyle!.maximumSize
              ?.resolve(states)
              ?.width;
          return Size(
            math.min(anchorWidth, effectiveMaximumWidth ?? anchorWidth),
            0.0,
          );
        }),
      );
    }

    if (widget.menuHeight != null) {
      effectiveMenuStyle = effectiveMenuStyle.copyWith(
        maximumSize: WidgetStatePropertyAll<Size>(
          Size(double.infinity, widget.menuHeight!),
        ),
      );
    }
    final InputDecorationThemeData effectiveInputDecorationTheme =
        widget.inputDecorationTheme ??
        theme.inputDecorationTheme ??
        defaults.inputDecorationTheme!;

    final MouseCursor? effectiveMouseCursor = switch (widget.enabled) {
      true =>
        canRequestFocus() ? SystemMouseCursors.text : SystemMouseCursors.click,
      false => null,
    };

    Widget menuAnchor = MenuAnchor(
      style: effectiveMenuStyle,
      alignmentOffset: widget.alignmentOffset,
      reservedPadding: EdgeInsets.zero,
      controller: _controller,
      menuChildren: menu,
      crossAxisUnconstrained: false,
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            assert(_initialMenu != null);
            final bool isCollapsed =
                widget.inputDecorationTheme?.isCollapsed ?? false;
            final Widget trailingButton = widget.showTrailingIcon
                ? IconButton(
                    focusNode: _trailingIconButtonFocusNode,
                    isSelected: controller.isOpen,
                    constraints:
                        widget.inputDecorationTheme?.suffixIconConstraints,
                    padding: isCollapsed ? EdgeInsets.zero : null,
                    icon:
                        widget.trailingIcon ??
                        const Icon(Icons.keyboard_arrow_down_sharp, size: 16),
                    selectedIcon:
                        widget.selectedTrailingIcon ??
                        const Icon(Icons.keyboard_arrow_up_sharp, size: 16),
                    onPressed: !widget.enabled
                        ? null
                        : () {
                            handlePressed(controller);
                          },
                  )
                : const SizedBox.shrink();

            final Widget leadingButton = Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.leadingIcon ?? const SizedBox.shrink(),
            );

            final Widget textField = TextField(
              key: _anchorKey,
              enabled: widget.enabled,
              mouseCursor: effectiveMouseCursor,
              focusNode: widget.focusNode,
              canRequestFocus: canRequestFocus(),
              enableInteractiveSelection: canRequestFocus(),
              readOnly: !canRequestFocus(),
              keyboardType: widget.keyboardType,
              textAlign: widget.textAlign,
              textAlignVertical: TextAlignVertical.center,
              maxLines: widget.maxLines,
              textInputAction: widget.textInputAction,
              cursorHeight: widget.cursorHeight,
              style: effectiveTextStyle,
              controller: _effectiveTextEditingController,
              onEditingComplete: _handleEditingComplete,
              onTap: !widget.enabled
                  ? null
                  : () {
                      handlePressed(
                        controller,
                        focusForKeyboard: !canRequestFocus(),
                      );
                    },
              onChanged: (String text) {
                controller.open();
                setState(() {
                  filteredEntries = widget.items;
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
                prefixIcon: widget.leadingIcon != null
                    ? SizedBox(key: _leadingKey, child: widget.leadingIcon)
                    : null,
                suffixIcon: widget.showTrailingIcon ? trailingButton : null,
              ).applyDefaults(effectiveInputDecorationTheme),
              restorationId: widget.restorationId,
            );

            final Widget body = widget.expandedInsets != null
                ? textField
                : MenuBody(
                    width: widget.width,
                    children: <Widget>[
                      textField,
                      ..._initialMenu!.map(
                        (Widget item) => ExcludeFocus(
                          excluding: !controller.isOpen,
                          child: item,
                        ),
                      ),
                      if (widget.label != null)
                        ExcludeSemantics(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: DefaultTextStyle(
                              style: effectiveTextStyle!,
                              child: widget.label!,
                            ),
                          ),
                        ),
                      trailingButton,
                      leadingButton,
                    ],
                  );

            return Shortcuts(
              shortcuts: const <ShortcutActivator, Intent>{
                SingleActivator(
                  LogicalKeyboardKey.arrowLeft,
                ): ExtendSelectionByCharacterIntent(
                  forward: false,
                  collapseSelection: true,
                ),
                SingleActivator(
                  LogicalKeyboardKey.arrowRight,
                ): ExtendSelectionByCharacterIntent(
                  forward: true,
                  collapseSelection: true,
                ),
                SingleActivator(LogicalKeyboardKey.arrowUp): ArrowUpIntent(),
                SingleActivator(LogicalKeyboardKey.arrowDown):
                    ArrowDownIntent(),
              },
              child: body,
            );
          },
    );

    if (widget.expandedInsets case final EdgeInsetsGeometry padding) {
      menuAnchor = Padding(
        padding: padding.clamp(
          EdgeInsets.zero,
          const EdgeInsets.only(
            left: double.infinity,
            right: double.infinity,
          ).add(
            const EdgeInsetsDirectional.only(
              end: double.infinity,
              start: double.infinity,
            ),
          ),
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
        ArrowUpIntent: CallbackAction<ArrowUpIntent>(
          onInvoke: handleUpKeyInvoke,
        ),
        ArrowDownIntent: CallbackAction<ArrowDownIntent>(
          onInvoke: handleDownKeyInvoke,
        ),
        EnterIntent: CallbackAction<EnterIntent>(
          onInvoke: (_) => _handleEditingComplete(),
        ),
      },
      child: Stack(
        children: <Widget>[
          Shortcuts(
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.arrowUp): ArrowUpIntent(),
              SingleActivator(LogicalKeyboardKey.arrowDown): ArrowDownIntent(),
              SingleActivator(LogicalKeyboardKey.enter): EnterIntent(),
            },
            child: Focus(
              focusNode: _internalFocudeNode,
              skipTraversal: true,
              child: const SizedBox.shrink(),
            ),
          ),
          menuAnchor,
        ],
      ),
    );
  }
}

typedef FilterCallback<T> =
    List<MenuEntry<T>> Function(List<MenuEntry<T>> entries, String filter);

typedef SearchCallback<T> =
    int? Function(List<MenuEntry<T>> entries, String query);

class MenuBody extends MultiChildRenderObjectWidget {
  const MenuBody({super.key, super.children, this.width});

  final double? width;

  @override
  RenderMenuBody createRenderObject(BuildContext context) {
    return RenderMenuBody(width: width);
  }

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
    if (_width == value) {
      return;
    }
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
    final BoxConstraints constraints = this.constraints;
    double maxWidth = 0.0;
    double? maxHeight;
    RenderBox? child = firstChild;

    final double intrinsicWidth =
        width ?? getMaxIntrinsicWidth(constraints.maxHeight);
    final double widthConstraint = math.min(
      intrinsicWidth,
      constraints.maxWidth,
    );
    final BoxConstraints innerConstraints = BoxConstraints(
      maxWidth: widthConstraint,
      maxHeight: getMaxIntrinsicHeight(widthConstraint),
    );
    while (child != null) {
      if (child == firstChild) {
        child.layout(innerConstraints, parentUsesSize: true);
        maxHeight ??= child.size.height;
        final MenuBodyParentData childParentData =
            child.parentData! as MenuBodyParentData;
        assert(child.parentData == childParentData);
        child = childParentData.nextSibling;
        continue;
      }
      child.layout(innerConstraints, parentUsesSize: true);
      final MenuBodyParentData childParentData =
          child.parentData! as MenuBodyParentData;
      childParentData.offset = Offset.zero;
      maxWidth = math.max(maxWidth, child.size.width);
      maxHeight ??= child.size.height;
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }

    assert(maxHeight != null);
    maxWidth = math.max(kMinimumWidth, maxWidth);
    size = constraints.constrain(Size(width ?? maxWidth, maxHeight!));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = firstChild;
    if (child != null) {
      final MenuBodyParentData childParentData =
          child.parentData! as MenuBodyParentData;
      context.paintChild(child, offset + childParentData.offset);
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final BoxConstraints constraints = this.constraints;
    double maxWidth = 0.0;
    double? maxHeight;
    RenderBox? child = firstChild;
    final double intrinsicWidth =
        width ?? getMaxIntrinsicWidth(constraints.maxHeight);
    final double widthConstraint = math.min(
      intrinsicWidth,
      constraints.maxWidth,
    );
    final BoxConstraints innerConstraints = BoxConstraints(
      maxWidth: widthConstraint,
      maxHeight: getMaxIntrinsicHeight(widthConstraint),
    );

    while (child != null) {
      if (child == firstChild) {
        final Size childSize = child.getDryLayout(innerConstraints);
        maxHeight ??= childSize.height;
        final MenuBodyParentData childParentData =
            child.parentData! as MenuBodyParentData;
        assert(child.parentData == childParentData);
        child = childParentData.nextSibling;
        continue;
      }
      final Size childSize = child.getDryLayout(innerConstraints);
      final MenuBodyParentData childParentData =
          child.parentData! as MenuBodyParentData;
      childParentData.offset = Offset.zero;
      maxWidth = math.max(maxWidth, childSize.width);
      maxHeight ??= childSize.height;
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }

    assert(maxHeight != null);
    maxWidth = math.max(kMinimumWidth, maxWidth);
    return constraints.constrain(Size(width ?? maxWidth, maxHeight!));
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    RenderBox? child = firstChild;
    double width = 0;
    while (child != null) {
      if (child == firstChild) {
        final MenuBodyParentData childParentData =
            child.parentData! as MenuBodyParentData;
        child = childParentData.nextSibling;
        continue;
      }
      final double minIntrinsicWidth = child.getMinIntrinsicWidth(height);
      if (child == lastChild) {
        width += minIntrinsicWidth;
      }
      if (child == childBefore(lastChild!)) {
        width += minIntrinsicWidth;
      }
      width = math.max(width, minIntrinsicWidth);
      final MenuBodyParentData childParentData =
          child.parentData! as MenuBodyParentData;
      child = childParentData.nextSibling;
    }

    return math.max(width, kMinimumWidth);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    RenderBox? child = firstChild;
    double width = 0;
    while (child != null) {
      if (child == firstChild) {
        final MenuBodyParentData childParentData =
            child.parentData! as MenuBodyParentData;
        child = childParentData.nextSibling;
        continue;
      }
      final double maxIntrinsicWidth = child.getMaxIntrinsicWidth(height);
      if (child == lastChild) {
        width += maxIntrinsicWidth;
      }
      if (child == childBefore(lastChild!)) {
        width += maxIntrinsicWidth;
      }
      width = math.max(width, maxIntrinsicWidth);
      final MenuBodyParentData childParentData =
          child.parentData! as MenuBodyParentData;
      child = childParentData.nextSibling;
    }

    return math.max(width, kMinimumWidth);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final RenderBox? child = firstChild;
    double width = 0;
    if (child != null) {
      width = math.max(width, child.getMinIntrinsicHeight(width));
    }
    return width;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final RenderBox? child = firstChild;
    double width = 0;
    if (child != null) {
      width = math.max(width, child.getMaxIntrinsicHeight(width));
    }
    return width;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final RenderBox? child = firstChild;
    if (child != null) {
      final MenuBodyParentData childParentData =
          child.parentData! as MenuBodyParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    visitChildren((RenderObject renderObjectChild) {
      final RenderBox child = renderObjectChild as RenderBox;
      if (child == firstChild) {
        visitor(renderObjectChild);
      }
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
        disabledColor: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: 0.38),
      );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);

  @override
  TextStyle? get textStyle => _theme.textTheme.bodyLarge;

  @override
  MenuStyle get menuStyle {
    return const MenuStyle(
      minimumSize: WidgetStatePropertyAll<Size>(Size(kMinimumWidth, 0.0)),
      maximumSize: WidgetStatePropertyAll<Size>(Size.infinite),
      visualDensity: VisualDensity.standard,
    );
  }

  @override
  InputDecorationThemeData get inputDecorationTheme {
    return const InputDecorationThemeData(border: OutlineInputBorder());
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
