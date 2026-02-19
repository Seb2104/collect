part of '../filtered_menu.dart';
class MenuEntry<T> {
  const MenuEntry({
    required this.value,
    required this.label,
    this.labelWidget,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
    this.style,
  });

  final T value;

  final String label;

  final Widget? labelWidget;

  final Widget? leadingIcon;

  final Widget? trailingIcon;

  final bool enabled;

  final ButtonStyle? style;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MenuEntry<T> &&
              runtimeType == other.runtimeType &&
              value == other.value &&
              label == other.label;

  @override
  int get hashCode => Object.hash(value, label);
}
