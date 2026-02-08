import 'package:flutter/material.dart';

import '../../collect.dart';

class TrackPainter extends CustomPainter {
  const TrackPainter(this.trackType, this.hsvColor);

  final TrackType trackType;
  final HSVColour hsvColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    if (trackType == TrackType.alpha) {
      final Size chessSize = Size(size.height / 2, size.height / 2);
      Paint chessPaintB = Paint()..color = const Color(0xffcccccc);
      Paint chessPaintW = Paint()..color = Colors.white;
      List.generate((size.height / chessSize.height).round(), (int y) {
        List.generate((size.width / chessSize.width).round(), (int x) {
          canvas.drawRect(
            Offset(chessSize.width * x, chessSize.width * y) & chessSize,
            (x + y) % 2 != 0 ? chessPaintW : chessPaintB,
          );
        });
      });
    }

    switch (trackType) {
      case TrackType.hue:
        final List<Color> colors = [
          const HSVColour.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.saturation:
        final List<Color> colors = [
          HSVColour.fromAHSV(1.0, hsvColor.hue, 0.0, 1.0).toColor(),
          HSVColour.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.saturationForHSL:
        final List<Color> colors = [
          HSLColour.fromAHSL(1.0, hsvColor.hue, 0.0, 0.5).toColour(),
          HSLColour.fromAHSL(1.0, hsvColor.hue, 1.0, 0.5).toColour(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.value:
        final List<Color> colors = [
          HSVColour.fromAHSV(1.0, hsvColor.hue, 1.0, 0.0).toColor(),
          HSVColour.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.lightness:
        final List<Color> colors = [
          HSLColour.fromAHSL(1.0, hsvColor.hue, 1.0, 0.0).toColour(),
          HSLColour.fromAHSL(1.0, hsvColor.hue, 1.0, 0.5).toColour(),
          HSLColour.fromAHSL(1.0, hsvColor.hue, 1.0, 1.0).toColour(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.red:
        final List<Color> colors = [
          hsvColor.toColor().withRed(0).withOpacity(1.0),
          hsvColor.toColor().withRed(255).withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.green:
        final List<Color> colors = [
          hsvColor.toColor().withGreen(0).withOpacity(1.0),
          hsvColor.toColor().withGreen(255).withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.blue:
        final List<Color> colors = [
          hsvColor.toColor().withBlue(0).withOpacity(1.0),
          hsvColor.toColor().withBlue(255).withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.alpha:
        final List<Color> colors = [
          hsvColor.toColor().withOpacity(0.0),
          hsvColor.toColor().withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ThumbPainter extends CustomPainter {
  const ThumbPainter({this.thumbColor, this.fullThumbColor = false});

  final Color? thumbColor;
  final bool fullThumbColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(
      Path()..addOval(
        Rect.fromCircle(
          center: const Offset(0.5, 2.0),
          radius: size.width * 1.8,
        ),
      ),
      Colors.black,
      3.0,
      true,
    );
    canvas.drawCircle(
      Offset(0.0, size.height * 0.4),
      size.height,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    if (thumbColor != null) {
      canvas.drawCircle(
        Offset(0.0, size.height * 0.4),
        size.height * (fullThumbColor ? 1.0 : 0.65),
        Paint()
          ..color = thumbColor!
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
