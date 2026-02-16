import 'dart:math';

import 'package:flutter/material.dart';

import '../../collect.dart';

/// Shared gesture handling utilities for colour pickers
class ColourPickerGestureUtils {
  /// Converts a global position to local normalized coordinates [0-1]
  ///
  /// Returns null if the context has no render box
  static Offset? globalToLocalNormalized(
    Offset globalPosition,
    BuildContext context,
    double width,
    double height,
  ) {
    RenderBox? getBox = context.findRenderObject() as RenderBox?;
    if (getBox == null) return null;

    Offset localOffset = getBox.globalToLocal(globalPosition);
    double horizontal = localOffset.dx.clamp(0.0, width);
    double vertical = localOffset.dy.clamp(0.0, height);

    return Offset(horizontal / width, 1 - vertical / height);
  }

  /// Converts a normalized position to polar coordinates for wheel/ring pickers
  ///
  /// Returns (hue, distance) where:
  /// - hue is in degrees [0-360]
  /// - distance is normalized [0-1]
  static ({double hue, double distance}) toPolarCoordinates(
    Offset normalizedPosition,
    double width,
    double height,
  ) {
    double horizontal = normalizedPosition.dx * width;
    double vertical = (1 - normalizedPosition.dy) * height;

    Offset center = Offset(width / 2, height / 2);
    double radio = width <= height ? width / 2 : height / 2;

    double dist =
        sqrt(pow(horizontal - center.dx, 2) + pow(vertical - center.dy, 2)) /
        radio;
    double rad =
        (atan2(horizontal - center.dx, vertical - center.dy) / pi + 1) /
        2 *
        360;

    double hue = ((rad + 90) % 360).clamp(0, 360);
    double distance = dist.clamp(0, 1);

    return (hue: hue, distance: distance);
  }
}

/// Gesture detector for rectangular colour palettes
///
/// Handles pan gestures and converts them to normalized coordinates
class RectanglePaletteGestureDetector extends StatelessWidget {
  const RectanglePaletteGestureDetector({
    super.key,
    required this.onColorChanged,
    required this.paletteType,
    required this.hsvColor,
    required this.child,
  });

  final ValueChanged<HSVColour> onColorChanged;
  final PaletteType paletteType;
  final HSVColour hsvColor;
  final Widget child;

  void _handleColorChange(double horizontal, double vertical) {
    switch (paletteType) {
      case PaletteType.hsv:
      case PaletteType.hsvWithHue:
        onColorChanged(hsvColor.withSaturation(horizontal).withValue(vertical));
        break;
      case PaletteType.hsvWithSaturation:
        onColorChanged(hsvColor.withHue(horizontal * 360).withValue(vertical));
        break;
      case PaletteType.hsvWithValue:
        onColorChanged(
          hsvColor.withHue(horizontal * 360).withSaturation(vertical),
        );
        break;
      case PaletteType.hsl:
      case PaletteType.hslWithHue:
        onColorChanged(
          hslToHsv(
            hsvToHsl(
              hsvColor,
            ).withSaturation(horizontal).withLightness(vertical),
          ),
        );
        break;
      case PaletteType.hslWithSaturation:
        onColorChanged(
          hslToHsv(
            hsvToHsl(
              hsvColor,
            ).withHue(horizontal * 360).withLightness(vertical),
          ),
        );
        break;
      case PaletteType.hslWithLightness:
        onColorChanged(
          hslToHsv(
            hsvToHsl(
              hsvColor,
            ).withHue(horizontal * 360).withSaturation(vertical),
          ),
        );
        break;
      case PaletteType.rgbWithRed:
        onColorChanged(
          HSVColour.fromColor(
            hsvColor
                .toColor()
                .withBlue((horizontal * 255).round())
                .withGreen((vertical * 255).round()),
          ),
        );
        break;
      case PaletteType.rgbWithGreen:
        onColorChanged(
          HSVColour.fromColor(
            hsvColor
                .toColor()
                .withBlue((horizontal * 255).round())
                .withRed((vertical * 255).round()),
          ),
        );
        break;
      case PaletteType.rgbWithBlue:
        onColorChanged(
          HSVColour.fromColor(
            hsvColor
                .toColor()
                .withRed((horizontal * 255).round())
                .withGreen((vertical * 255).round()),
          ),
        );
        break;
      default:
        break;
    }
  }

  void _handleGesture(
    Offset position,
    BuildContext context,
    double height,
    double width,
  ) {
    final normalized = ColourPickerGestureUtils.globalToLocalNormalized(
      position,
      context,
      width,
      height,
    );
    if (normalized != null) {
      _handleColorChange(normalized.dx, normalized.dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return RawGestureDetector(
          gestures: {
            AlwaysWinPanGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  AlwaysWinPanGestureRecognizer
                >(() => AlwaysWinPanGestureRecognizer(), (
                  AlwaysWinPanGestureRecognizer instance,
                ) {
                  instance
                    ..onDown = ((details) => _handleGesture(
                      details.globalPosition,
                      context,
                      height,
                      width,
                    ))
                    ..onUpdate = ((details) => _handleGesture(
                      details.globalPosition,
                      context,
                      height,
                      width,
                    ));
                }),
          },
          child: child,
        );
      },
    );
  }
}

/// Gesture detector for wheel colour pickers
///
/// Handles pan gestures and converts them to polar coordinates (hue + saturation)
class WheelGestureDetector extends StatelessWidget {
  const WheelGestureDetector({
    super.key,
    required this.onColorChanged,
    required this.hsvColor,
    required this.child,
  });

  final ValueChanged<HSVColour> onColorChanged;
  final HSVColour hsvColor;
  final Widget child;

  void _handleGesture(
    Offset position,
    BuildContext context,
    double height,
    double width,
  ) {
    final normalized = ColourPickerGestureUtils.globalToLocalNormalized(
      position,
      context,
      width,
      height,
    );
    if (normalized != null) {
      final polar = ColourPickerGestureUtils.toPolarCoordinates(
        normalized,
        width,
        height,
      );
      onColorChanged(
        hsvColor.withHue(polar.hue).withSaturation(polar.distance),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return RawGestureDetector(
          gestures: {
            AlwaysWinPanGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  AlwaysWinPanGestureRecognizer
                >(() => AlwaysWinPanGestureRecognizer(), (
                  AlwaysWinPanGestureRecognizer instance,
                ) {
                  instance
                    ..onDown = ((details) => _handleGesture(
                      details.globalPosition,
                      context,
                      height,
                      width,
                    ))
                    ..onUpdate = ((details) => _handleGesture(
                      details.globalPosition,
                      context,
                      height,
                      width,
                    ));
                }),
          },
          child: child,
        );
      },
    );
  }
}

/// Gesture detector for hue ring pickers
///
/// Only updates hue, distance must be within ring bounds
class HueRingGestureDetector extends StatelessWidget {
  const HueRingGestureDetector({
    super.key,
    required this.onColorChanged,
    required this.hsvColor,
    required this.child,
  });

  final ValueChanged<HSVColour> onColorChanged;
  final HSVColour hsvColor;
  final Widget child;

  void _handleGesture(
    Offset position,
    BuildContext context,
    double height,
    double width,
  ) {
    final normalized = ColourPickerGestureUtils.globalToLocalNormalized(
      position,
      context,
      width,
      height,
    );
    if (normalized != null) {
      final polar = ColourPickerGestureUtils.toPolarCoordinates(
        normalized,
        width,
        height,
      );
      // Only respond to gestures within the ring area
      if (polar.distance > 0.7 && polar.distance < 1.3) {
        onColorChanged(hsvColor.withHue(polar.hue));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (details) =>
              _handleGesture(details.position, context, height, width),
          onPointerMove: (details) =>
              _handleGesture(details.position, context, height, width),
          child: child,
        );
      },
    );
  }
}

/// Gesture detector for simple HSV palettes (saturation/value only)
///
/// Similar to RectanglePaletteGestureDetector but only updates saturation and value
class SimpleHSVGestureDetector extends StatelessWidget {
  const SimpleHSVGestureDetector({
    super.key,
    required this.onColorChanged,
    required this.hsvColor,
    required this.child,
  });

  final ValueChanged<HSVColour> onColorChanged;
  final HSVColour hsvColor;
  final Widget child;

  void _handleGesture(
    Offset position,
    BuildContext context,
    double height,
    double width,
  ) {
    final normalized = ColourPickerGestureUtils.globalToLocalNormalized(
      position,
      context,
      width,
      height,
    );
    if (normalized != null) {
      onColorChanged(
        HSVColour.fromHSVColor(
          hsvColor.withSaturation(normalized.dx).withValue(normalized.dy),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (details) =>
              _handleGesture(details.position, context, height, width),
          onPointerMove: (details) =>
              _handleGesture(details.position, context, height, width),
          child: child,
        );
      },
    );
  }
}
