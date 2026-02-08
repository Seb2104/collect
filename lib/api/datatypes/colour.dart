part of '../../collect.dart';

class Colour extends Col implements Color {
  @override
  final int alpha;
  @override
  final int red;
  @override
  final int green;
  @override
  final int blue;

  HSVColour get hsv {
    final double red = color.r / 0xFF;
    final double green = color.g / 0xFF;
    final double blue = color.b / 0xFF;

    final double max = math.max(red, math.max(green, blue));
    final double min = math.min(red, math.min(green, blue));
    final double delta = max - min;

    final double alpha = color.a / 0xFF;
    final double hue = _getHue(red, green, blue, max, delta);
    final double saturation = max == 0.0 ? 0.0 : delta / max;

    return HSVColour.fromAHSV(alpha, hue, saturation, max);
  }

  HSLColour get hsl {
    final double red = color.r / 0xFF;
    final double green = color.g / 0xFF;
    final double blue = color.b / 0xFF;

    final double max = math.max(red, math.max(green, blue));
    final double min = math.min(red, math.min(green, blue));
    final double delta = max - min;

    final double alpha = color.a / 0xFF;
    final double hue = _getHue(red, green, blue, max, delta);
    final double lightness = (max + min) / 2.0;
    final double saturation = min == max
        ? 0.0
        : delta /
              (1.0 - (2.0 * lightness - 1.0).abs()).clamp(0.0, double.infinity);
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  @override
  int toARGB32() {
    return _floatToInt8(a) << 24 |
        _floatToInt8(r) << 16 |
        _floatToInt8(g) << 8 |
        _floatToInt8(b) << 0;
  }

  @override
  int get hashCode => value;

  @override
  int get value =>
      ((alpha & 0xff) << 24) |
      ((red & 0xff) << 16) |
      ((green & 0xff) << 8) |
      ((blue & 0xff) << 0);

  int _floatToInt8(double x) {
    return (x * 255.0).round().clamp(0, 255);
  }

  @override
  double computeLuminance() {
    return 0;
  }

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  double get r => red / 255;

  @override
  double get g => green / 255;

  @override
  double get b => blue / 255;

  Color get color => Color.fromARGB(alpha, red, green, blue);

  String get hex =>
      Radix.hex(alpha) + Radix.hex(red) + Radix.hex(green) + Radix.hex(blue);

  String get b256 => alpha.b256 + red.b256 + green.b256 + blue.b256;

  String get argb => '$alpha,$red,$green,$blue';

  String get rgb => '$red,$green,$blue';

  @override
  double get opacity => alpha / 255;

  @override
  double get a => alpha / 255;

  // HSVColor-like properties
  double get hue => hsv.hue;

  double get saturation => hsv.saturation;

  double get hsvValue => hsv.value;

  // HSLColor-like property
  double get lightness => hsl.lightness;

  const Colour({
    this.alpha = 255,
    this.red = 255,
    this.green = 255,
    this.blue = 255,
  }) : assert(alpha >= 0, alpha <= 100),
       assert(red >= 0, red <= 255),
       assert(green >= 0, green <= 255),
       assert(blue >= 0, blue <= 255);

  const Colour.fromRGB({
    required this.red,
    required this.green,
    required this.blue,
  }) : alpha = 255,
       assert(red >= 0, red <= 255),
       assert(green >= 0, green <= 255),
       assert(blue >= 0, blue <= 255);

  /// Alpha is clamped between 0 and 100 and is a percentage
  factory Colour.fromARGB({
    double opacity = 100,
    int red = 255,
    int green = 255,
    int blue = 255,
  }) {
    return Colour(
      alpha: Radix.percentToColourValue(opacity.clamp(0, 100)),
      red: red.clamp(0, 255),
      green: green.clamp(0, 255),
      blue: blue.clamp(0, 255),
    );
  }

  Colour.fromB256(String data)
    : alpha = Radix.base(data[0], Bases.b256) as int,
      red = Radix.base(data[1], Bases.b256) as int,
      green = Radix.base(data[2], Bases.b256) as int,
      blue = Radix.base(data[3], Bases.b256) as int;

  Colour.fromPercent({
    double a = 100,
    double r = 100,
    double g = 100,
    double b = 100,
  }) : alpha = Radix.percentToColourValue(a.clamp(0, 100)),
       red = Radix.percentToColourValue(r.clamp(0, 100)),
       green = Radix.percentToColourValue(g.clamp(0, 100)),
       blue = Radix.percentToColourValue(b.clamp(0, 100));

  Colour.fromFraction({
    double alpha = 1.0,
    double red = 1.0,
    double green = 1.0,
    double blue = 1.0,
  }) : alpha = Radix.fractionToColourValue(alpha.clamp(0.0, 1.0)),
       red = Radix.fractionToColourValue(red.clamp(0.0, 1.0)),
       green = Radix.fractionToColourValue(green.clamp(0.0, 1.0)),
       blue = Radix.fractionToColourValue(blue.clamp(0.0, 1.0));

  factory Colour.fromHex({required String hexString}) {
    String hex = hexString.replaceAll('#', '').toUpperCase();

    if (hex.length == 6) {
      hex = 'FF$hex';
    } else if (hex.length == 3) {
      hex = 'FF${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
    } else if (hex.length == 4) {
      hex =
          '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}${hex[3]}${hex[3]}';
    }

    return Colour(
      alpha: Radix.base(hex.substring(0, 2), Bases.b16),
      red: Radix.base(hex.substring(2, 4), Bases.b16),
      green: Radix.base(hex.substring(4, 6), Bases.b16),
      blue: Radix.base(hex.substring(6, 8), Bases.b16),
    );
  }

  Colour.fromColor(Color color)
    : alpha = Radix.fractionToColourValue(color.a),
      red = Radix.fractionToColourValue(color.r),
      green = Radix.fractionToColourValue(color.g),
      blue = Radix.fractionToColourValue(color.b);

  factory Colour.fromHSL({
    required double h,
    required double s,
    required double l,
  }) {
    double red, green, blue;

    double normalizedH = h / 360.0;

    if (s == 0) {
      red = green = blue = l;
    } else {
      double q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      double p = 2 * l - q;

      red = _hueToRgb(p, q, normalizedH + 1 / 3);
      green = _hueToRgb(p, q, normalizedH);
      blue = _hueToRgb(p, q, normalizedH - 1 / 3);
      return Colour(
        alpha: 255,
        red: red.round(),
        green: green.round(),
        blue: blue.round(),
      );
    }

    return Colour.fromARGB(
      opacity: 100.0,
      red: (red * 255).round(),
      green: (green * 255).round(),
      blue: (blue * 255).round(),
    );
  }

  factory Colour.fromHSVColour({required HSVColor hsvColour}) {
    return Colour.fromHSV(
      h: hsvColour.hue,
      s: hsvColour.saturation,
      v: hsvColour.value,
    );
  }

  factory Colour.fromHSLColour({required HSLColor hslColour}) {
    return Colour.fromHSL(
      h: hslColour.hue,
      s: hslColour.saturation,
      l: hslColour.lightness,
    );
  }

  factory Colour.fromHSV({
    double a = 1.0,
    required double h,
    required double s,
    required double v,
  }) {
    double red, green, blue;

    if (s == 0) {
      red = green = blue = v;
    } else {
      final double sector = h / 60;
      final int i = sector.floor();
      final double f = sector - i;
      final double p = v * (1 - s);
      final double q = v * (1 - s * f);
      final double t = v * (1 - s * (1 - f));

      switch (i % 6) {
        case 0:
          red = v;
          green = t;
          blue = p;
          break;
        case 1:
          red = q;
          green = v;
          blue = p;
          break;
        case 2:
          red = p;
          green = v;
          blue = t;
          break;
        case 3:
          red = p;
          green = q;
          blue = v;
          break;
        case 4:
          red = t;
          green = p;
          blue = v;
          break;
        case 5:
          red = v;
          green = p;
          blue = q;
          break;
        default:
          red = green = blue = 0;
      }
    }

    return Colour(
      alpha: (a * 255).round(),
      red: (red * 255).round(),
      green: (green * 255).round(),
      blue: (blue * 255).round(),
    );
  }

  @override
  Colour withAlpha(int alpha) =>
      Colour(alpha: alpha, red: red, green: green, blue: blue);

  @override
  Colour withRed(int red) =>
      Colour(alpha: alpha, red: red, green: green, blue: blue);

  @override
  Colour withGreen(int green) =>
      Colour(alpha: alpha, red: red, green: green, blue: blue);

  @override
  Colour withBlue(int blue) {
    return Colour(alpha: alpha, red: red, green: green, blue: blue);
  }

  // HSVColor-like methods
  Colour withHue(double hue) {
    return Colour.fromHSVColour(
      hsvColour: HSVColor.fromAHSV(a, hue, saturation, hsvValue),
    );
  }

  Colour withSaturation(double saturation) {
    return Colour.fromHSVColour(
      hsvColour: HSVColor.fromAHSV(a, hue, saturation, hsvValue),
    );
  }

  Colour withHsvValue(double value) {
    return Colour.fromHSVColour(
      hsvColour: HSVColor.fromAHSV(a, hue, saturation, value),
    );
  }

  // HSLColor-like methods
  Colour withLightness(double lightness) {
    return Colour.fromHSLColour(
      hslColour: HSLColour.fromAHSL(a, hue, saturation, lightness),
    );
  }

  // Implicit conversions to HSVColor and HSLColor
  HSVColor toHSVColor() => hsv;

  HSLColor toHSLColor() => hsl;

  String print() => b256;

  @override
  String toString() {
    return '${Radix.base(alpha, Bases.decimal)}${Radix.base(red, Bases.decimal)}${Radix.base(green, Bases.decimal)}${Radix.base(blue, Bases.decimal)}';
  }

  static double _hueToRgb(double p, double q, double t) {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1 / 6) return p + (q - p) * 6 * t;
    if (t < 1 / 2) return q;
    if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
    return p;
  }

  static double _getHue(
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

    /// Set hue to 0.0 when red == green == blue.
    hue = hue.isNaN ? 0.0 : hue;
    return hue;
  }

  @override
  Colour withOpacity(double opacity) => withAlpha((255.0 * opacity).round());

  @override
  ColorSpace get colorSpace => ColorSpace.sRGB;

  @override
  Colour withValues({
    double? alpha,
    double? red,
    double? green,
    double? blue,
    ColorSpace? colorSpace,
  }) {
    return Colour();
  }
}
