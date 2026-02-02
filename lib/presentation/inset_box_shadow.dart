part of '../collect.dart';

final class InsetBoxShadow extends BoxShadow {
  const InsetBoxShadow({
    super.color,
    super.offset,
    super.blurRadius,
    super.spreadRadius = 0.0,
    super.blurStyle = BlurStyle.normal,
  });

  const InsetBoxShadow.dip({
    super.color = Colors.black,
    super.offset = Offset.zero,
    super.blurStyle = BlurStyle.outer,
    super.blurRadius = 8,
    super.spreadRadius = 3,
  });
}
