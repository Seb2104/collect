part of '../collect.dart';

class AppTheme {
  static const Color primarySage = Color(0xFF9CAF88);
  static const Color primarySageDark = Color(0xFF7A8F6D);
  static const Color secondaryTerracotta = Color(0xFFD4B5A0);
  static const Color accentGold = Color(0xFFE6D5B8);
  static const Color softCoral = Color(0xFFE5C4B5);
  static const Color dustyRose = Color(0xFFFF6767);
  static const Color lavenderMist = Color(0xFFCBBFD4);
  static const Color accentSuccess = Color(0xFF88B584);
  static const Color accentWarning = Color(0xFFE5BD8F);
  static const Color accentError = Color(0xFFD49490);

  static const Color lightBackground = Color(0xFFF5F3EE);
  static const Color lightSurface = Color(0xFFFFFDFA);
  static const Color lightSurfaceVariant = Color(0xFFF8F5F0);
  static const Color lightSurfaceElevated = Color(0xFFFFFFFE);
  static const Color lightTextPrimary = Color(0xFF3A3731);
  static const Color lightTextSecondary = Color(0xFF6B6560);
  static const Color lightTextTertiary = Color(0xFF9D9691);
  static const Color lightBorder = Color(0xFFE8E3DC);
  static const Color lightBorderSubtle = Color(0xFFF0EDE7);
  static const Color lightDivider = Color(0xFFE5DFD7);
  static const Color lightHover = Color(0xFFFAF7F3);
  static const Color lightFocus = Color(0xFFF0EDE7);

  static const Color darkBackground = Color(0xFF2A2825);
  static const Color darkSurface = Color(0xFF1F1D1A);
  static const Color darkSurfaceVariant = Color(0xFF38352F);
  static const Color darkSurfaceElevated = Color(0xFF423F38);
  static const Color darkTextPrimary = Color(0xFFF8F6F3);
  static const Color darkTextSecondary = Color(0xFFC8C1B8);
  static const Color darkTextTertiary = Color(0xFF9E9892);
  static const Color darkBorder = Color(0xFF504B43);
  static const Color darkBorderSubtle = Color(0xFF423F38);
  static const Color darkDivider = Color(0xFF45413A);
  static const Color darkHover = Color(0xFF38352F);
  static const Color darkFocus = Color(0xFF423F38);

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primarySage,
        primaryContainer: Color(0xFF4D5E4A),
        secondary: secondaryTerracotta,
        secondaryContainer: Color(0xFF7D6359),
        tertiary: lavenderMist,
        tertiaryContainer: Color(0xFF6B6474),
        surface: darkSurface,
        surfaceContainerHighest: darkSurfaceVariant,
        error: accentError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
        onError: Colors.white,
        outline: darkBorder,
        shadow: Color(0x33000000),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Color(0x33000000),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySage,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: const Color(0x33000000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primarySage,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primarySage, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentError),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: const TextStyle(color: darkTextSecondary),
        labelStyle: const TextStyle(color: darkTextSecondary),
      ),
      dividerTheme: const DividerThemeData(
        color: darkDivider,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static Color success(BuildContext context) => accentGold;

  static Color warning(BuildContext context) => softCoral;

  static Color error(BuildContext context) => accentError;

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextPrimary
        : darkTextPrimary;
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextSecondary
        : darkTextSecondary;
  }

  static Color textTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextTertiary
        : darkTextTertiary;
  }

  static Color surfaceElevated(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightSurfaceElevated
        : darkSurfaceElevated;
  }

  static Color borderSubtle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBorderSubtle
        : darkBorderSubtle;
  }

  static Color hover(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightHover
        : darkHover;
  }

  static Color focus(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightFocus
        : darkFocus;
  }

  static Color border(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBorder
        : darkBorder;
  }

  static Color surfaceVariant(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightSurfaceVariant
        : darkSurfaceVariant;
  }

  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightSurface
        : darkSurface;
  }

  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBackground
        : darkBackground;
  }

  static Color divider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightDivider
        : darkDivider;
  }

  static const Color lightTableCellBackground = Color(0xFFFFFFFE);
  static const Color lightTableCellHover = Color(0xFFFAF7F3);
  static const Color lightTableCellFocus = Color(0xFFF0EDE7);
  static const Color lightTableCellSelected = Color(0xFFE8F0E5);
  static const Color lightTableHeaderBackground = Color(0xFFF8F5F0);
  static const Color lightTableHeaderText = Color(0xFF3A3731);
  static const Color lightTableBorderHover = Color(0xFFD4CFC5);
  static const Color lightTableAlternateRow = Color(0xFFFCFAF7);
  static const Color lightTableResizeHandle = Color(0xFF9CAF88);
  static const Color lightTableResizeHandleHover = Color(0xFF7A8F6D);
  static const Color lightTableShadow = Color(0x0A3A3531);
  static const Color lightTableBorder = Colors.transparent;

  static const Color darkTableCellBackground = Color(0xFF2A2825);
  static const Color darkTableCellHover = Color(0xFF38352F);
  static const Color darkTableCellFocus = Color(0xFF423F38);
  static const Color darkTableCellSelected = Color(0xFF4D5E4A);
  static const Color darkTableHeaderBackground = Color(0xFF38352F);
  static const Color darkTableHeaderText = Color(0xFFF8F6F3);
  static const Color darkTableBorder = Colors.transparent;
  static const Color darkTableBorderHover = Color(0xFF6B6560);
  static const Color darkTableAlternateRow = Color(0xFF32302D);
  static const Color darkTableResizeHandle = Color(0xFF9CAF88);
  static const Color darkTableResizeHandleHover = Color(0xFFAABD98);
  static const Color darkTableShadow = Color(0x33000000);

  static Color tableCellBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableCellBackground
        : darkTableCellBackground;
  }

  static Color tableCellHover(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableCellHover
        : darkTableCellHover;
  }

  static Color tableCellFocus(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableCellFocus
        : darkTableCellFocus;
  }

  static Color tableCellSelected(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableCellSelected
        : darkTableCellSelected;
  }

  static Color tableHeaderBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableHeaderBackground
        : darkTableHeaderBackground;
  }

  static Color tableHeaderText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableHeaderText
        : darkTableHeaderText;
  }

  static Color tableBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableBorder
        : darkTableBorder;
  }

  static Color tableBorderHover(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableBorderHover
        : darkTableBorderHover;
  }

  static Color tableAlternateRow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableAlternateRow
        : darkTableAlternateRow;
  }

  static Color tableResizeHandle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableResizeHandle
        : darkTableResizeHandle;
  }

  static Color tableResizeHandleHover(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableResizeHandleHover
        : darkTableResizeHandleHover;
  }

  static Color tableShadow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableShadow
        : darkTableShadow;
  }
}
