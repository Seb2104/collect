import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../collect.dart';
import 'common/common.dart';

class HueRingPicker extends StatefulWidget {
  const HueRingPicker({
    super.key,
    required this.currentColour,
    required this.onColorChanged,
    this.portraitOnly = false,
    this.colorPickerHeight = 250.0,
    this.hueRingStrokeWidth = 20.0,
    this.enableAlpha = false,
    this.displayThumbColor = true,
    this.pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
  });

  final Color currentColour;
  final ValueChanged<Color> onColorChanged;
  final bool portraitOnly;
  final double colorPickerHeight;
  final double hueRingStrokeWidth;
  final bool enableAlpha;
  final bool displayThumbColor;
  final BorderRadius pickerAreaBorderRadius;

  @override
  State<HueRingPicker> createState() => _HueRingPickerState();
}

class _HueRingPickerState extends State<HueRingPicker> {
  HSVColour currentHsvColor = const HSVColour.fromAHSV(0.0, 0.0, 0.0, 0.0);

  @override
  void initState() {
    currentHsvColor = HSVColour.fromColor(widget.currentColour);
    super.initState();
  }

  @override
  void didUpdateWidget(HueRingPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentHsvColor = HSVColour.fromColor(widget.currentColour);
  }

  void onColorChanging(HSVColour color) {
    setState(() => currentHsvColor = color);
    widget.onColorChanged(currentHsvColor.toColor());
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait ||
        widget.portraitOnly) {
      return Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: widget.pickerAreaBorderRadius,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  SizedBox(
                    width: widget.colorPickerHeight,
                    height: widget.colorPickerHeight,
                    child: ColorPickerHueRing(
                      currentHsvColor,
                      onColorChanging,
                      displayThumbColor: widget.displayThumbColor,
                      strokeWidth: widget.hueRingStrokeWidth,
                    ),
                  ),
                  SizedBox(
                    width: widget.colorPickerHeight / 1.6,
                    height: widget.colorPickerHeight / 1.6,
                    child: ColorPickerArea(
                      currentHsvColor,
                      onColorChanging,
                      PaletteType.hsv,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.enableAlpha)
            SizedBox(
              height: 40.0,
              width: widget.colorPickerHeight,
              child: ColourPickerSlider(
                TrackType.alpha,
                currentHsvColor,
                onColorChanging,
                displayThumbColor: widget.displayThumbColor,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 10),
                ColorIndicator(currentHsvColor),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Column(
            children: [
              SizedBox(height: widget.colorPickerHeight / 8.5),
              ColorIndicator(currentHsvColor),
              if (widget.enableAlpha) const SizedBox(height: 5),
              SizedBox(
                height: 40.0,
                width: 100.0,
                child: ColourPickerSlider(
                  TrackType.alpha,
                  currentHsvColor,
                  onColorChanging,
                  displayThumbColor: true,
                ),
              ),
            ],
          ),

          ClipRRect(
            borderRadius: widget.pickerAreaBorderRadius,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  SizedBox(
                    width: widget.colorPickerHeight * 0.5,
                    height: widget.colorPickerHeight * 0.5,
                    child: ColorPickerArea(
                      currentHsvColor,
                      onColorChanging,
                      PaletteType.hsv,
                    ),
                  ),
                  SizedBox(
                    width:
                        widget.colorPickerHeight -
                        widget.hueRingStrokeWidth * 2,
                    height:
                        widget.colorPickerHeight -
                        widget.hueRingStrokeWidth * 2,
                    child: ColorPickerHueRing(
                      currentHsvColor,
                      onColorChanging,
                      strokeWidth: widget.hueRingStrokeWidth,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}

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

class HueRingPainter extends CustomPainter {
  const HueRingPainter(
    this.hsvColor, {
    this.displayThumbColor = true,
    this.strokeWidth = 5,
  });

  final HSVColour hsvColor;
  final bool displayThumbColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radio = size.width <= size.height ? size.width / 2 : size.height / 2;

    final List<Color> colors = [
      const HSVColour.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
    ];
    canvas.drawCircle(
      center,
      radio,
      Paint()
        ..shader = SweepGradient(colors: colors).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    final Offset offset = Offset(
      center.dx + radio * cos((hsvColor.hue * pi / 180)),
      center.dy - radio * sin((hsvColor.hue * pi / 180)),
    );
    canvas.drawShadow(
      Path()..addOval(Rect.fromCircle(center: offset, radius: 12)),
      Colors.black,
      3.0,
      true,
    );
    canvas.drawCircle(
      offset,
      size.height * 0.04,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    if (displayThumbColor) {
      canvas.drawCircle(
        offset,
        size.height * 0.03,
        Paint()
          ..color = hsvColor.toColor()
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  bool hitTest(Offset position) {
    final center = Offset(0, 0);
    final radio = 1.0;
    final dist = sqrt(pow(position.dx - 0.5, 2) + pow(position.dy - 0.5, 2)) * 2;
    return dist > 0.7 && dist < 1.3;
  }
}

class ColorPickerArea extends StatelessWidget {
  const ColorPickerArea(
    this.hsvColor,
    this.onColorChanged,
    this.paletteType, {
    super.key,
  });

  final HSVColour hsvColor;
  final ValueChanged<HSVColour> onColorChanged;
  final PaletteType paletteType;

  void _handleColorRectChange(double horizontal, double vertical) {
    onColorChanged(
      HSVColour.fromHSVColor(
        hsvColor.withSaturation(horizontal).withValue(vertical),
      ),
    );
  }

  void _handleGesture(
    Offset position,
    BuildContext context,
    double height,
    double width,
  ) {
    RenderBox? getBox = context.findRenderObject() as RenderBox?;
    if (getBox == null) return;

    Offset localOffset = getBox.globalToLocal(position);
    double horizontal = localOffset.dx.clamp(0.0, width);
    double vertical = localOffset.dy.clamp(0.0, height);

    _handleColorRectChange(horizontal / width, 1 - vertical / height);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (details) => _handleGesture(
            details.position,
            context,
            height,
            width,
          ),
          onPointerMove: (details) => _handleGesture(
            details.position,
            context,
            height,
            width,
          ),
          child: CustomPaint(painter: HSVWithHueColorPainter(hsvColor)),
        );
      },
    );
  }
}

class ColorPickerHueRing extends StatelessWidget {
  const ColorPickerHueRing(
    this.hsvColor,
    this.onColorChanged, {
    super.key,
    this.displayThumbColor = true,
    this.strokeWidth = 5.0,
  });

  final HSVColour hsvColor;
  final ValueChanged<HSVColour> onColorChanged;
  final bool displayThumbColor;
  final double strokeWidth;

  void _handleGesture(
    Offset position,
    BuildContext context,
    double height,
    double width,
  ) {
    RenderBox? getBox = context.findRenderObject() as RenderBox?;
    if (getBox == null) return;

    Offset localOffset = getBox.globalToLocal(position);
    double horizontal = localOffset.dx.clamp(0.0, width);
    double vertical = localOffset.dy.clamp(0.0, height);

    Offset center = Offset(width / 2, height / 2);
    double radio = width <= height ? width / 2 : height / 2;
    double dist =
        sqrt(pow(horizontal - center.dx, 2) + pow(vertical - center.dy, 2)) /
        radio;
    double rad =
        (atan2(horizontal - center.dx, vertical - center.dy) / pi + 1) /
        2 *
        360;
    if (dist > 0.7 && dist < 1.3) {
      onColorChanged(
        hsvColor.withHue(((rad + 90) % 360).clamp(0, 360)).toHSVColour,
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
          behavior: HitTestBehavior.translucent,
          onPointerDown: (details) => _handleGesture(
            details.position,
            context,
            height,
            width,
          ),
          onPointerMove: (details) => _handleGesture(
            details.position,
            context,
            height,
            width,
          ),
          child: CustomPaint(
            painter: HueRingPainter(
              hsvColor,
              displayThumbColor: displayThumbColor,
              strokeWidth: strokeWidth,
            ),
          ),
        );
      },
    );
  }
}
