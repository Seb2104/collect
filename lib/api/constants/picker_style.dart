part of '../../collect.dart';

class PickerStyle {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BoxDecoration decoration;

  const PickerStyle({
    this.padding = const  EdgeInsets.all(20),
    this.margin = const EdgeInsets.all(20),
    this.decoration = const BoxDecoration(
      color: AppTheme.lightBackground,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  });
}
