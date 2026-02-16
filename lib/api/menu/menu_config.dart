part of 'menu.dart';

/// Behavioral configuration for a [Menu] widget.
///
/// This is separate from [MenuDecoration] (which handles visuals). MenuConfig
/// is all about how the menu *behaves* — search, keyboard nav, auto-scroll,
/// sizing, etc. Think of it as the "settings" for your dropdown.
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

  /// Whether to show a search field at the top of the dropdown.
  /// When true, users can type to filter the list of items.
  final bool enableSearch;

  /// Placeholder text shown in the search field when it's empty.
  /// Only matters if [enableSearch] is true.
  final String searchHint;

  /// Custom matching logic for the search field.
  /// If you don't set this, it just does a case-insensitive "contains" check.
  final FilterMatchFn? searchMatchFn;

  /// Whether arrow keys + enter work for navigating the dropdown.
  /// Defaults to true because honestly why would you not want this.
  final bool enableKeyboardNavigation;

  /// Whether the list auto-scrolls to keep the highlighted item visible
  /// when navigating with the keyboard. Defaults to true.
  final bool autoScrollOnHighlight;

  /// Maximum height of the dropdown. If null, it defaults to 40% of
  /// the screen height so it doesn't take over the whole screen.
  final double? maxHeight;

  /// Whether selecting an item automatically closes the dropdown.
  /// Defaults to true. Set to false if you want the user to be able
  /// to select multiple things without the dropdown closing.
  final bool closeOnSelect;

  /// Positional offset of the dropdown relative to the trigger widget.
  /// Defaults to (0, 5) — so it sits just slightly below the button.
  final Offset? offset;

  /// How long the open/close animations take.
  final Duration animationDuration;

  /// The easing curve for open/close animations.
  final Curve animationCurve;

  /// Returns a copy of this config with only the specified fields changed.
  /// Everything else stays the same. Super handy for tweaking one or two
  /// things without having to rewrite the whole config.
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
