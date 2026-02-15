import 'package:flutter/material.dart';

import '../../collect.dart';

/// Painter for HSV palette with variable hue
/// Shows a square with saturation on X-axis and value on Y-axis
class HSVWithHueColorPainter extends CustomPainter {
  const HSVWithHueColorPainter(this.hsvColor, {this.pointerColor});

  final HSVColour hsvColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, Colors.black],
    );
    final Gradient gradientH = LinearGradient(
      colors: [
        Colors.white,
        HSVColour.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..blendMode = BlendMode.multiply
        ..shader = gradientH.createShader(rect),
    );

    canvas.drawCircle(
      Offset(
        size.width * hsvColor.saturation,
        size.height * (1 - hsvColor.value),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hsvColor.toColor())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..blendMode = BlendMode.luminosity
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Painter for HSV palette with variable saturation
/// Shows a square with hue on X-axis and value on Y-axis
class HSVWithSaturationColorPainter extends CustomPainter {
  const HSVWithSaturationColorPainter(this.hsvColor, {this.pointerColor});

  final HSVColour hsvColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black],
    );
    final List<Color> colors = [
      HSVColour.fromAHSV(1.0, 0.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 60.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 120.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 180.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 240.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 300.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 360.0, hsvColor.saturation, 1.0).toColor(),
    ];
    final Gradient gradientH = LinearGradient(colors: colors);
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));

    canvas.drawCircle(
      Offset(
        size.width * hsvColor.hue / 360,
        size.height * (1 - hsvColor.value),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hsvColor.toColor())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Painter for HSV palette with variable value
/// Shows a square with hue on X-axis and saturation on Y-axis
class HSVWithValueColorPainter extends CustomPainter {
  const HSVWithValueColorPainter(this.hsvColor, {this.pointerColor});

  final HSVColour hsvColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.white],
    );
    final List<Color> colors = [
      const HSVColour.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
    ];
    final Gradient gradientH = LinearGradient(colors: colors);
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()..color = Colors.black.withOpacity(1 - hsvColor.value),
    );

    canvas.drawCircle(
      Offset(
        size.width * hsvColor.hue / 360,
        size.height * (1 - hsvColor.saturation),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hsvColor.toColor())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Painter for HSL palette with variable hue
/// Shows a square with saturation on X-axis and lightness on Y-axis
class HSLWithHueColorPainter extends CustomPainter {
  const HSLWithHueColorPainter(this.hslColor, {this.pointerColor});

  final HSLColour hslColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradientH = LinearGradient(
      colors: [
        const Color(0xff808080),
        HSLColour.fromAHSL(1.0, hslColor.hue, 1.0, 0.5).toColour(),
      ],
    );
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.5, 0.5, 1],
      colors: [
        Colors.white,
        Color(0x00ffffff),
        Colors.transparent,
        Colors.black,
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));

    canvas.drawCircle(
      Offset(
        size.width * hslColor.saturation,
        size.height * (1 - hslColor.lightness),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hslColor.toColour())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Painter for HSL palette with variable saturation
/// Shows a square with hue on X-axis and lightness on Y-axis
class HSLWithSaturationColorPainter extends CustomPainter {
  const HSLWithSaturationColorPainter(this.hslColor, {this.pointerColor});

  final HSLColour hslColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final List<Color> colors = [
      HSLColour.fromAHSL(1.0, 0.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 60.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 120.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 180.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 240.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 300.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 360.0, hslColor.saturation, 0.5).toColour(),
    ];
    final Gradient gradientH = LinearGradient(colors: colors);
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.5, 0.5, 1],
      colors: [
        Colors.white,
        Color(0x00ffffff),
        Colors.transparent,
        Colors.black,
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));

    canvas.drawCircle(
      Offset(
        size.width * hslColor.hue / 360,
        size.height * (1 - hslColor.lightness),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hslColor.toColour())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Painter for HSL palette with variable lightness
/// Shows a square with hue on X-axis and saturation on Y-axis
class HSLWithLightnessColorPainter extends CustomPainter {
  const HSLWithLightnessColorPainter(this.hslColor, {this.pointerColor});

  final HSLColour hslColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final List<Color> colors = [
      const HSLColour.fromAHSL(1.0, 0.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 60.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 120.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 180.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 240.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 300.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 360.0, 1.0, 0.5).toColour(),
    ];
    final Gradient gradientH = LinearGradient(colors: colors);
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Color(0xFF808080)],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.black.withOpacity(
          (1 - hslColor.lightness * 2).clamp(0, 1),
        ),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.white.withOpacity(
          ((hslColor.lightness - 0.5) * 2).clamp(0, 1),
        ),
    );

    canvas.drawCircle(
      Offset(
        size.width * hslColor.hue / 360,
        size.height * (1 - hslColor.saturation),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hslColor.toColour())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Painter for RGB palette with variable red
/// Shows a square with blue on X-axis and green on Y-axis
class RGBWithRedColorPainter extends CustomPainter {
  const RGBWithRedColorPainter(this.color, {this.pointerColor});

  final Color color;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradientH = LinearGradient(
      colors: [
        Color.fromRGBO(color.red, 255, 0, 1.0),
        Color.fromRGBO(color.red, 255, 255, 1.0),
      ],
    );
    final Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(color.red, 255, 255, 1.0),
        Color.fromRGBO(color.red, 0, 255, 1.0),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..shader = gradientV.createShader(rect)
        ..blendMode = BlendMode.multiply,
    );

    canvas.drawCircle(
      Offset(
        size.width * color.blue / 255,
        size.height * (1 - color.green / 255),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(color) ? Colors.white : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Painter for RGB palette with variable green
/// Shows a square with blue on X-axis and red on Y-axis
class RGBWithGreenColorPainter extends CustomPainter {
  const RGBWithGreenColorPainter(this.color, {this.pointerColor});

  final Color color;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradientH = LinearGradient(
      colors: [
        Color.fromRGBO(255, color.green, 0, 1.0),
        Color.fromRGBO(255, color.green, 255, 1.0),
      ],
    );
    final Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(255, color.green, 255, 1.0),
        Color.fromRGBO(0, color.green, 255, 1.0),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..shader = gradientV.createShader(rect)
        ..blendMode = BlendMode.multiply,
    );

    canvas.drawCircle(
      Offset(
        size.width * color.blue / 255,
        size.height * (1 - color.red / 255),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(color) ? Colors.white : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Painter for RGB palette with variable blue
/// Shows a square with red on X-axis and green on Y-axis
class RGBWithBlueColorPainter extends CustomPainter {
  const RGBWithBlueColorPainter(this.color, {this.pointerColor});

  final Color color;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradientH = LinearGradient(
      colors: [
        Color.fromRGBO(0, 255, color.blue, 1.0),
        Color.fromRGBO(255, 255, color.blue, 1.0),
      ],
    );
    final Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(255, 255, color.blue, 1.0),
        Color.fromRGBO(255, 0, color.blue, 1.0),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..shader = gradientV.createShader(rect)
        ..blendMode = BlendMode.multiply,
    );

    canvas.drawCircle(
      Offset(
        size.width * color.red / 255,
        size.height * (1 - color.green / 255),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(color) ? Colors.white : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
