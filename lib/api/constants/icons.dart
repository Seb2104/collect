// ignore_for_file: constant_identifier_names

part of '../../collect.dart';

class ReCollectIcons {
  ReCollectIcons._();

  static const _kFontFam = 'ReCollectIcons';
  static const String? _kFontPkg = null;

  static const IconData text_colour = IconData(
    0xe901,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );

  static const IconData format_colour_fill = IconData(
    0xe900,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );

  static const IconData insert_column_left = IconData(
    0xe908,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );

  static const IconData insert_column_right = IconData(
    0xe907,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );

  static const IconData insert_row_above = IconData(
    0xe906,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );

  static const IconData insert_row_below = IconData(
    0xe905,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );

  static const IconData remove_column_left = IconData(
    0xe909,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );

  static const IconData remove_column_right = IconData(
    0xe90a,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );

  static const IconData remove_row_above = IconData(
    0xe90b,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );

  static const IconData remove_row_below = IconData(
    0xe90c,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );

  static Widget get fontColour =>
      Icon(text_colour, size: 64, color: Color(0xFFFFFFFF));

  static Widget get backgroundColour =>
      Icon(format_colour_fill, size: 64, color: Color(0xFFFFFFFF));

  static Widget get insertColumnLeft =>
      Icon(insert_column_left, size: 64, color: Color(0xFFFFFFFF));

  static Widget get insertColumnRight =>
      Icon(insert_column_right, size: 64, color: Color(0xFFFFFFFF));

  static Widget get insertRowBelow =>
      Icon(insert_row_below, size: 64, color: Color(0xFFFFFFFF));

  static Widget get insertRowAbove =>
      Icon(insert_row_above, size: 64, color: Color(0xFFFFFFFF));
}
