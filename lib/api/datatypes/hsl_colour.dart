part of '../../collect.dart';

class HSLColour implements HSLColor {
  const HSLColour.fromAHSL(
    this.alpha,
    this.hue,
    this.saturation,
    this.lightness,
  ) : assert(alpha >= 0.0),
      assert(alpha <= 1.0),
      assert(hue >= 0.0),
      assert(hue <= 360.0),
      assert(saturation >= 0.0),
      assert(saturation <= 1.0),
      assert(lightness >= 0.0),
      assert(lightness <= 1.0);

  const HSLColour({
    this.alpha = 1.0,
    this.hue = 360,
    this.saturation = 1.0,
    this.lightness = 1,
  });

  factory HSLColour.fromColor(Color color) {
    final double red = color.red / 0xFF;
    final double green = color.green / 0xFF;
    final double blue = color.blue / 0xFF;

    final double max = math.max(red, math.max(green, blue));
    final double min = math.min(red, math.min(green, blue));
    final double delta = max - min;

    final double alpha = color.alpha / 0xFF;
    final double hue = _getHue(red, green, blue, max, delta);
    final double lightness = (max + min) / 2.0;
    final double saturation = min == max
        ? 0.0
        : clampDouble(delta / (1.0 - (2.0 * lightness - 1.0).abs()), 0.0, 1.0);
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  factory HSLColour.fromColour(Colour color) {
    final double red = color.red / 0xFF;
    final double green = color.green / 0xFF;
    final double blue = color.blue / 0xFF;

    final double max = math.max(red, math.max(green, blue));
    final double min = math.min(red, math.min(green, blue));
    final double delta = max - min;

    final double alpha = color.alpha / 0xFF;
    final double hue = _getHue(red, green, blue, max, delta);
    final double lightness = (max + min) / 2.0;
    final double saturation = min == max
        ? 0.0
        : clampDouble(delta / (1.0 - (2.0 * lightness - 1.0).abs()), 0.0, 1.0);
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  @override
  final double alpha;

  @override
  final double hue;

  @override
  final double saturation;

  @override
  final double lightness;

  @override
  HSLColour withAlpha(double alpha) {
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  @override
  HSLColour withHue(double hue) {
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  @override
  HSLColour withSaturation(double saturation) {
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  @override
  HSLColour withLightness(double lightness) {
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  Colour toColour() {
    final double chroma = (1.0 - (2.0 * lightness - 1.0).abs()) * saturation;
    final double secondary =
        chroma * (1.0 - (((hue / 60.0) % 2.0) - 1.0).abs());
    final double match = lightness - chroma / 2.0;

    return _colourFromHue(alpha, hue, chroma, secondary, match);
  }

  @override
  Color toColor() {
    final double chroma = (1.0 - (2.0 * lightness - 1.0).abs()) * saturation;
    final double secondary =
        chroma * (1.0 - (((hue / 60.0) % 2.0) - 1.0).abs());
    final double match = lightness - chroma / 2.0;

    return _colorFromHue(alpha, hue, chroma, secondary, match);
  }

  HSLColour _scaleAlpha(double factor) {
    return withAlpha(alpha * factor);
  }

  static HSLColour? lerp(HSLColour? a, HSLColour? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return b!._scaleAlpha(t);
    }
    if (b == null) {
      return a._scaleAlpha(1.0 - t);
    }
    return HSLColour.fromAHSL(
      clampDouble(lerpDouble(a.alpha, b.alpha, t)!, 0.0, 1.0),
      lerpDouble(a.hue, b.hue, t)! % 360.0,
      clampDouble(lerpDouble(a.saturation, b.saturation, t)!, 0.0, 1.0),
      clampDouble(lerpDouble(a.lightness, b.lightness, t)!, 0.0, 1.0),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is HSLColour &&
        other.alpha == alpha &&
        other.hue == hue &&
        other.saturation == saturation &&
        other.lightness == lightness;
  }

  @override
  int get hashCode => Object.hash(alpha, hue, saturation, lightness);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'HSLColour')}($alpha, $hue, $saturation, $lightness)';
}

extension Hslcolour on HSLColor {
  HSLColour get toHSLColour {
    return HSLColour(
      alpha: alpha,
      hue: hue,
      lightness: lightness,
      saturation: saturation,
    );
  }
}
