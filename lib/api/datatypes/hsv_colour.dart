part of '../../collect.dart';

class HSVColour extends Col implements HSVColor {
  @override
  final double alpha;

  @override
  final double hue;

  @override
  final double saturation;

  @override
  final double value;

  const HSVColour({
    this.alpha = 1.0,
    this.hue = 360,
    this.saturation = 1.0,
    this.value = 1,
  });

  const HSVColour.fromAHSV(this.alpha, this.hue, this.saturation, this.value)
    : assert(alpha >= 0.0),
      assert(alpha <= 1.0),
      assert(hue >= 0.0),
      assert(hue <= 360.0),
      assert(saturation >= 0.0),
      assert(saturation <= 1.0),
      assert(value >= 0.0),
      assert(value <= 1.0);

  factory HSVColour.fromColor(Color color) {
    final double red = color.red / 0xFF;
    final double green = color.green / 0xFF;
    final double blue = color.blue / 0xFF;

    final double max = math.max(red, math.max(green, blue));
    final double min = math.min(red, math.min(green, blue));
    final double delta = max - min;

    final double alpha = color.alpha / 0xFF;
    final double hue = _getHue(red, green, blue, max, delta);
    final double saturation = max == 0.0 ? 0.0 : delta / max;

    return HSVColour.fromAHSV(alpha, hue, saturation, max);
  }

  HSVColour.fromHSVColor(HSVColor hsvColor)
    : alpha = hsvColor.alpha,
      hue = hsvColor.hue,
      saturation = hsvColor.saturation,
      value = hsvColor.value;

  @override
  Color toColor() {
    throw UnimplementedError();
  }

  @override
  HSVColor withAlpha(double alpha) {
    throw UnimplementedError();
  }

  @override
  HSVColor withHue(double hue) {
    throw UnimplementedError();
  }

  @override
  HSVColor withSaturation(double saturation) {
    throw UnimplementedError();
  }

  @override
  HSVColor withValue(double value) {
    throw UnimplementedError();
  }
}

extension Hsvcolour on HSVColor {
  HSVColour get toHSVColour {
    return HSVColour(
      alpha: alpha,
      hue: hue,
      saturation: saturation,
      value: value,
    );
  }
}
