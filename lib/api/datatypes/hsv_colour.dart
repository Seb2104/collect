part of '../../collect.dart';

double _getHue(
  double red,
  double green,
  double blue,
  double max,
  double delta,
) {
  late double hue;
  if (max == 0.0) {
    hue = 0.0;
  } else if (max == red) {
    hue = 60.0 * (((green - blue) / delta) % 6);
  } else if (max == green) {
    hue = 60.0 * (((blue - red) / delta) + 2);
  } else if (max == blue) {
    hue = 60.0 * (((red - green) / delta) + 4);
  }

  hue = hue.isNaN ? 0.0 : hue;
  return hue;
}

Colour _colourFromHue(
  double alpha,
  double hue,
  double chroma,
  double secondary,
  double match,
) {
  final (double red, double green, double blue) = switch (hue) {
    < 60.0 => (chroma, secondary, 0.0),
    < 120.0 => (secondary, chroma, 0.0),
    < 180.0 => (0.0, chroma, secondary),
    < 240.0 => (0.0, secondary, chroma),
    < 300.0 => (secondary, 0.0, chroma),
    _ => (chroma, 0.0, secondary),
  };
  return Colour.fromColor(
    Color.fromARGB(
      (alpha * 0xFF).round(),
      ((red + match) * 0xFF).round(),
      ((green + match) * 0xFF).round(),
      ((blue + match) * 0xFF).round(),
    ),
  );
}

class HSVColour implements HSVColor {
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
