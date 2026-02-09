import 'dart:math';

import 'package:flutter/material.dart';

import '../collect.dart';
import 'common/common.dart';

class WheelPicker extends StatefulWidget {
  const WheelPicker({
    super.key,
    required this.height,
    required this.width,
    required this.pickerColor,
    required this.onColorChanged,
    this.pickerHsvColor,
    this.onHsvColorChanged,
    this.enableAlpha = true,
    this.showLabel = true,
    this.labelTypes = const [ColorLabelType.rgb, ColorLabelType.hex],
    this.displayThumbColor = false,
    this.portraitOnly = false,
    this.pickerRadius = 300.0,
    this.pickerAreaHeightPercent = 1.0,
    this.pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
    this.colorHistory,
    this.onHistoryChanged,
  });

  final double height;
  final double width;
  final double pickerRadius;

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final HSVColour? pickerHsvColor;
  final ValueChanged<HSVColour>? onHsvColorChanged;
  final bool enableAlpha;
  final bool showLabel;
  final List<ColorLabelType> labelTypes;
  final bool displayThumbColor;
  final bool portraitOnly;
  final double pickerAreaHeightPercent;
  final BorderRadius pickerAreaBorderRadius;
  final List<Color>? colorHistory;
  final ValueChanged<List<Color>>? onHistoryChanged;

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  HSVColour currentHsvColor = const HSVColour.fromAHSV(0.0, 0.0, 0.0, 0.0);
  List<Color> colorHistory = [];

  @override
  void initState() {
    currentHsvColor = (widget.pickerHsvColor != null)
        ? widget.pickerHsvColor as HSVColour
        : HSVColour.fromColor(widget.pickerColor);
    if (widget.colorHistory != null && widget.onHistoryChanged != null) {
      colorHistory = widget.colorHistory ?? [];
    }
    super.initState();
  }

  @override
  void didUpdateWidget(WheelPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentHsvColor = (widget.pickerHsvColor != null)
        ? widget.pickerHsvColor as HSVColour
        : HSVColour.fromColor(widget.pickerColor);
  }

  Widget colorPickerSlider(TrackType trackType) {
    return ColourPickerSlider(trackType, currentHsvColor,
            (HSVColour color) {
              setState(() => currentHsvColor = color);
      widget.onColorChanged(currentHsvColor.toColor());
      if (widget.onHsvColorChanged != null) {
        widget.onHsvColorChanged!(currentHsvColor);
      }
    }, displayThumbColor: widget.displayThumbColor);
  }

  void onColorChanging(HSVColour color) {
    setState(() => currentHsvColor = color);
    widget.onColorChanged(currentHsvColor.toColor());
    if (widget.onHsvColorChanged != null) {
      widget.onHsvColorChanged!(currentHsvColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait ||
        widget.portraitOnly) {
      return Column(
        children: <Widget>[
          SizedBox(
            width: widget.pickerRadius,
            height: widget.pickerRadius * widget.pickerAreaHeightPercent,
            child: ColorPickerArea(
              currentHsvColor,
              onColorChanging,
              PaletteType.hueWheel,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              widget.pickerRadius * 0.05,
              widget.pickerRadius * 0.017,
              widget.pickerRadius * 0.033,
              widget.pickerRadius * 0.017,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => setState(() {
                    if (widget.onHistoryChanged != null &&
                        !colorHistory.contains(currentHsvColor.toColor())) {
                      colorHistory.add(currentHsvColor.toColor());
                      widget.onHistoryChanged!(colorHistory);
                    }
                  }),
                  child: ColorIndicator(currentHsvColor),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: widget.pickerRadius * 0.133,
                        width: widget.pickerRadius * 0.75,
                        child: colorPickerSlider(TrackType.value),
                      ),
                      if (widget.enableAlpha)
                        SizedBox(
                          height: widget.pickerRadius * 0.133,
                          width: widget.pickerRadius * 0.75,
                          child: colorPickerSlider(TrackType.alpha),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (colorHistory.isNotEmpty)
            SizedBox(
              width: widget.pickerRadius,
              height: widget.pickerRadius * 0.167,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (Color color in colorHistory)
                    Padding(
                      key: Key(color.hashCode.toString()),
                      padding: EdgeInsets.fromLTRB(
                        widget.pickerRadius * 0.05,
                        0,
                        0,
                        widget.pickerRadius * 0.033,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () =>
                              onColorChanging(HSVColour.fromColor(color)),
                          child: ColorIndicator(
                            HSVColour.fromColor(color),
                            width: widget.pickerRadius * 0.1,
                            height: widget.pickerRadius * 0.1,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: widget.pickerRadius * 0.05),
                ],
              ),
            ),
          if (widget.showLabel && widget.labelTypes.isNotEmpty)
            FittedBox(
              child: ColourLabel(
                currentHsvColor.toColour(),
                enableAlpha: widget.enableAlpha,
                colorLabelTypes: widget.labelTypes,
              ),
            ),
        ],
      );
    } else {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: widget.pickerRadius,
              height: widget.pickerRadius * widget.pickerAreaHeightPercent,
              child: ColorPickerArea(
                currentHsvColor,
                onColorChanging,
                PaletteType.hueWheel,
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: widget.pickerRadius * 0.067),
                    GestureDetector(
                      onTap: () => setState(() {
                        if (widget.onHistoryChanged != null &&
                            !colorHistory.contains(currentHsvColor.toColor())) {
                          colorHistory.add(currentHsvColor.toColor());
                          widget.onHistoryChanged!(colorHistory);
                        }
                      }),
                      child: ColorIndicator(currentHsvColor),
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: widget.pickerRadius * 0.133,
                          width: widget.pickerRadius * 0.867,
                          child: colorPickerSlider(TrackType.value),
                        ),
                        if (widget.enableAlpha)
                          SizedBox(
                            height: widget.pickerRadius * 0.133,
                            width: widget.pickerRadius * 0.867,
                            child: colorPickerSlider(TrackType.alpha),
                          ),
                      ],
                    ),
                    SizedBox(width: widget.pickerRadius * 0.033),
                  ],
                ),
                if (colorHistory.isNotEmpty)
                  SizedBox(
                    width: widget.pickerRadius,
                    height: widget.pickerRadius * 0.167,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        for (Color color in colorHistory)
                          Padding(
                            key: Key(color.hashCode.toString()),
                            padding: EdgeInsets.fromLTRB(
                              widget.pickerRadius * 0.05,
                              widget.pickerRadius * 0.06,
                              0,
                              0,
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () =>
                                    onColorChanging(HSVColour.fromColor(color)),
                                onLongPress: () {
                                  if (colorHistory.remove(color)) {
                                    widget.onHistoryChanged!(colorHistory);
                                    setState(() {});
                                  }
                                },
                                child: ColorIndicator(
                                  HSVColour.fromColor(color),
                                  width: widget.pickerRadius * 0.1,
                                  height: widget.pickerRadius * 0.1,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(width: widget.pickerRadius * 0.05),
                      ],
                    ),
                  ),
                SizedBox(height: widget.pickerRadius * 0.067),
                if (widget.showLabel && widget.labelTypes.isNotEmpty)
                  FittedBox(
                    child: ColourLabel(
                      height: 100,
                      currentHsvColor.toColour(),
                      enableAlpha: widget.enableAlpha,
                      colorLabelTypes: widget.labelTypes,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class HUEColorWheelPainter extends CustomPainter {
  const HUEColorWheelPainter(this.hsvColor, {this.pointerColor});

  final HSVColour hsvColor;
  final Color? pointerColor;

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
    final Gradient gradientS = SweepGradient(colors: colors);
    const Gradient gradientR = RadialGradient(
      colors: [Colors.white, Color(0x00FFFFFF)],
    );
    canvas.drawCircle(
      center,
      radio,
      Paint()..shader = gradientS.createShader(rect),
    );
    canvas.drawCircle(
      center,
      radio,
      Paint()..shader = gradientR.createShader(rect),
    );
    canvas.drawCircle(
      center,
      radio,
      Paint()..color = Colors.black.withOpacity(1 - hsvColor.value),
    );

    canvas.drawCircle(
      Offset(
        center.dx +
            hsvColor.saturation * radio * cos((hsvColor.hue * pi / 180)),
        center.dy -
            hsvColor.saturation * radio * sin((hsvColor.hue * pi / 180)),
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

  void _handleColorWheelChange(double hue, double radio) {
    onColorChanged(hsvColor.withHue(hue).withSaturation(radio));
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

    Offset center = Offset(width / 2, height / 2);
    double radio = width <= height ? width / 2 : height / 2;
    double dist =
        sqrt(pow(horizontal - center.dx, 2) + pow(vertical - center.dy, 2)) /
        radio;
    double rad =
        (atan2(horizontal - center.dx, vertical - center.dy) / pi + 1) /
        2 *
        360;
    _handleColorWheelChange(((rad + 90) % 360).clamp(0, 360), dist.clamp(0, 1));
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
          child: CustomPaint(painter: HUEColorWheelPainter(hsvColor)),
        );
      },
    );
  }
}
