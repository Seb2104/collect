part of 'menu.dart';

class MenuItemConfig {
  final Widget? leadingIcon;

  final Widget? trailingIcon;

  final bool enabled;

  final ButtonStyle style;

  const MenuItemConfig({
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
    this.style = const ButtonStyle(),
  });
}

class MenuItem {
  final String value;
  final MenuItemConfig config;

  const MenuItem({
    required this.value,
    this.config = const MenuItemConfig(),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItem &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => Object.hash(value, config);
}
