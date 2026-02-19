part of '../../menu.dart';

class MenuState {
  final MenuItem selectedItem;
  final List<MenuItem> filteredItems;
  final bool isOverlayVisible;
  final int? highlightedIndex;

  const MenuState({
    required this.selectedItem,
    required this.filteredItems,
    required this.isOverlayVisible,
    this.highlightedIndex,
  });

  MenuState copyWith({
    MenuItem? selectedItem,
    List<MenuItem>? filteredItems,
    bool? isOverlayVisible,
    int? highlightedIndex,
    bool clearHighlight = false,
  }) {
    return MenuState(
      selectedItem: selectedItem ?? this.selectedItem,
      filteredItems: filteredItems ?? this.filteredItems,
      isOverlayVisible: isOverlayVisible ?? this.isOverlayVisible,
      highlightedIndex: clearHighlight
          ? null
          : (highlightedIndex ?? this.highlightedIndex),
    );
  }
}

class MenuController extends ValueNotifier<MenuState> {
  FocusNode? _focusNode;
  OverlayEntry? _overlay;

  MenuController({required MenuState initialState, FocusNode? focusNode})
    : _focusNode = focusNode,
      super(initialState);

  void attachFocusNode(FocusNode node) {
    _focusNode = node;
  }

  bool get isOverlayVisible => _overlay != null;

  void selectItem(MenuItem item) {
    value = value.copyWith(selectedItem: item, isOverlayVisible: false);
    _focusNode?.unfocus();
    hideOverlay();
    print(item.value);
  }

  void updateFilteredItems(List<MenuItem> items) {
    value = value.copyWith(filteredItems: items);
  }

  void highlightNext() {
    final items = value.filteredItems;
    if (items.isEmpty) return;
    final current = value.highlightedIndex;
    final next = (current == null) ? 0 : (current + 1) % items.length;
    value = value.copyWith(highlightedIndex: next);
    _overlay?.markNeedsBuild();
  }

  void highlightPrevious() {
    final items = value.filteredItems;
    if (items.isEmpty) return;
    final current = value.highlightedIndex;
    final prev = (current == null || current == 0)
        ? items.length - 1
        : current - 1;
    value = value.copyWith(highlightedIndex: prev);
    _overlay?.markNeedsBuild();
  }

  void selectHighlighted() {
    final idx = value.highlightedIndex;
    if (idx != null && idx < value.filteredItems.length) {
      selectItem(value.filteredItems[idx]);
    }
  }

  void filterItems(
    List<MenuItem> allItems,
    String query, {
    MenuFilterCallback? filterCallback,
  }) {
    if (query.isEmpty) {
      value = value.copyWith(filteredItems: allItems, clearHighlight: true);
      _overlay?.markNeedsBuild();
      return;
    }

    final List<MenuItem> filtered;
    if (filterCallback != null) {
      filtered = filterCallback(allItems, query);
    } else {
      final q = query.toLowerCase();
      filtered = allItems
          .where((item) => item.label.toLowerCase().contains(q))
          .toList();
    }
    value = value.copyWith(filteredItems: filtered, clearHighlight: true);
    _overlay?.markNeedsBuild();
  }

  void searchHighlight(String query, {MenuSearchCallback? searchCallback}) {
    if (query.isEmpty) {
      value = value.copyWith(clearHighlight: true);
      _overlay?.markNeedsBuild();
      return;
    }

    int? index;
    if (searchCallback != null) {
      index = searchCallback(value.filteredItems, query);
    } else {
      final q = query.toLowerCase();
      index = value.filteredItems.indexWhere(
        (e) => e.label.toLowerCase().contains(q),
      );
      if (index == -1) index = null;
    }

    if (index != null) {
      value = value.copyWith(highlightedIndex: index);
    } else {
      value = value.copyWith(clearHighlight: true);
    }
    _overlay?.markNeedsBuild();
  }

  void showOverlay(BuildContext context, OverlayEntry Function() builder) {
    if (_overlay != null) return;

    _focusNode?.requestFocus();

    _overlay = builder();
    Overlay.of(context).insert(_overlay!);
    value = value.copyWith(isOverlayVisible: true);
  }

  void hideOverlay() {
    _overlay?.remove();
    _overlay = null;
    value = value.copyWith(isOverlayVisible: false);
  }

  void toggleOverlay(BuildContext context, OverlayEntry Function() builder) {
    if (_overlay != null) {
      hideOverlay();
    } else {
      showOverlay(context, builder);
    }
  }

  @override
  void dispose() {
    hideOverlay();
    super.dispose();
  }
}
