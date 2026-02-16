part of 'menu.dart';

class MenuConfig {
  const MenuConfig({
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
