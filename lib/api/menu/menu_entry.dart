part of 'menu.dart';

/// Extra configuration for how a [MenuItem] looks and behaves in the dropdown.
///
/// This is where you set icons, disable items, or style individual entries.
/// Every [MenuItem] gets one of these — if you don't provide one, it just
/// uses sensible defaults (no icons, enabled, default button style).
class MenuItemConfig {
  /// An icon or widget that shows up on the left side of the menu item.
  final Widget? leadingIcon;

  /// An icon or widget that shows up on the right side of the menu item.
  final Widget? trailingIcon;

  /// Whether the user can actually tap/select this item.
  /// Disabled items show up greyed out and don't respond to taps.
  final bool enabled;

  /// The button style for this specific item. Lets you customize
  /// the look of individual items if you need to.
  final ButtonStyle style;

  const MenuItemConfig({
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
    this.style = const ButtonStyle(),
  });
}

/// Represents a single item in the menu dropdown.
///
/// At its core, a menu item is just a string [value] (the text that gets
/// displayed and returned when selected) plus an optional [config] for
/// extra stuff like icons and enabled/disabled state.
///
/// Two MenuItems are considered equal if they have the same [value],
/// so you can compare them without worrying about config differences.
class MenuItem {
  /// The actual text content of this menu item.
  /// This is what gets displayed in the dropdown and what gets
  /// returned when the user selects it.
  final String value;

  /// Optional configuration for icons, enabled state, and styling.
  /// Defaults to a plain enabled item with no icons.
  final MenuItemConfig config;

  const MenuItem({
    required this.value,
    this.config = const MenuItemConfig(),
  });

  /// Two MenuItems are equal if they have the same value string.
  /// We don't compare configs here — just the text content.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItem &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => Object.hash(value, config);
}
