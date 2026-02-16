part of 'menu.dart';


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
