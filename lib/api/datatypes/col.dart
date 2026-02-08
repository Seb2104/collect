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

sealed class Col {
  const Col();
}
