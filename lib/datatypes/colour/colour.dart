part of '../../common.dart';

final class Colour<P> {
  final double alpha;
  final double red;
  final double green;
  final double blue;

  const Colour({
    required this.alpha,
    required this.red,
    required this.green,
    required this.blue,
  })
      : assert(alpha >= 0, alpha <= 1),
        assert(red >= 0, red <= 1),
        assert(green >= 0, green <= 1),
        assert(blue >= 0, blue <= 1);

  Colour withAlpha(double alpha) =>
      Colour(alpha: this.alpha, red: red, green: green, blue: blue);

  Colour withRed(double red) =>
      Colour(alpha: alpha, red: this.red, green: green, blue: blue);

  Colour withGreen(double green) =>
      Colour(alpha: alpha, red: red, green: this.green, blue: blue);

  Colour withBlue(double blue) =>
      Colour(alpha: alpha, red: red, green: green, blue: this.blue);
}
