part of 'menu.dart';

/// Visual theming for the [Menu] widget.
///
/// This is purely about how stuff looks — colors, borders, spacing, etc.
/// For behavioral stuff (search, keyboard nav, animations), see [MenuConfig].
///
/// Every property is nullable so you can just set the ones you care about
/// and let the defaults handle the rest. The Menu widget resolves these
/// with a priority chain: direct widget prop > theme > hardcoded default.
class MenuTheme {
  const MenuTheme({
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

  // -- Trigger button styling --

  /// Background color of the menu trigger button (the thing you click to open it).
  final Color? backgroundColor;

  /// Border color of the trigger button.
  final Color? borderColor;

  /// Full border side definition for the trigger button.
  /// Overrides [borderColor] if both are set.
  final BorderSide? border;

  /// Corner rounding for the trigger button.
  final BorderRadius? borderRadius;

  /// Internal padding of the trigger button.
  final EdgeInsetsGeometry? padding;

  /// Shadow elevation of the trigger button. 0 means flat/no shadow.
  final double? elevation;

  // -- Dropdown arrow icon --

  /// Color of the little arrow icon on the trigger button.
  final Color? iconColor;

  /// Which icon to use for the dropdown arrow. Defaults to arrow_drop_down.
  final IconData? icon;

  /// Size of the dropdown arrow icon.
  final double? iconSize;

  /// If true, the arrow icon won't do the little rotation animation
  /// when the dropdown opens/closes. Some people find it annoying.
  final bool? disableIconRotation;

  // -- Dropdown panel styling --

  /// Background color of the dropdown panel that appears below the trigger.
  final Color? dropdownColor;

  /// Shadow elevation of the dropdown panel.
  final double? dropdownElevation;

  /// Corner rounding for the dropdown panel.
  final BorderRadius? dropdownBorderRadius;

  /// Internal padding of the dropdown panel (around the list of items).
  final EdgeInsetsGeometry? dropdownPadding;

  /// Custom border/shape for the dropdown panel. If you need something
  /// fancier than just rounded corners, use this.
  final ShapeBorder? dropdownBorder;

  // -- Individual item styling --

  /// Height of each item row in the dropdown.
  final double? itemHeight;

  /// Padding inside each item row.
  final EdgeInsetsGeometry? itemPadding;

  /// Background color when an item is highlighted (keyboard navigation).
  final Color? itemHighlightColor;

  /// Background color for the currently selected item.
  final Color? selectedItemColor;

  /// Text style for item labels in the dropdown.
  final TextStyle? itemTextStyle;

  // -- Search field styling --

  /// Text style for the search input field (if search is enabled).
  final TextStyle? searchTextStyle;

  /// Full InputDecoration for the search field, if you want total control.
  final InputDecoration? searchDecoration;

  /// Height of the search field.
  final double? searchFieldHeight;

  // -- Trigger button text styling --

  /// Text style for the selected value shown on the trigger button.
  final TextStyle? textStyle;

  /// Text style for the hint text when nothing is selected.
  final TextStyle? hintStyle;

  /// Returns a copy of this theme with only the specified fields changed.
  /// Handy for making small tweaks without rebuilding the whole thing.
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
