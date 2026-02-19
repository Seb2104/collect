part of '../menu.dart';

enum Aligned { left, center, right }

class ItemConfig {
  final EdgeInsetsGeometry padding;
  final Aligned alignment;
  final Colour backgroundColour;
  final BorderRadius borderRadius;
  final Border border;
  final double elevation;

  const ItemConfig({
    this.padding = const EdgeInsetsGeometry.all(10),
    this.alignment = Aligned.center,
    this.backgroundColour = Colours.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.border = const Border(),
    this.elevation = 5,
  });
}
