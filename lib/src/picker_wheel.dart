import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../collect.dart';
import 'common/painters.dart';

class WheelPicker extends StatefulWidget {
  const WheelPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.pickerHsvColor,
    this.onHsvColorChanged,
    this.enableAlpha = true,
    this.showLabel = true,
    this.labelTypes = const [ColorLabelType.rgb, ColorLabelType.hex],
    this.displayThumbColor = false,
    this.portraitOnly = false,
    this.colorPickerWidth = 300.0,
    this.pickerAreaHeightPercent = 1.0,
    this.pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
    this.hexInputBar = false,
    this.hexInputController,
    this.colorHistory,
    this.onHistoryChanged,
  });

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final HSVColor? pickerHsvColor;
  final ValueChanged<HSVColor>? onHsvColorChanged;
  final bool enableAlpha;
  final bool showLabel;
  final List<ColorLabelType> labelTypes;
  final bool displayThumbColor;
  final bool portraitOnly;
  final double colorPickerWidth;
  final double pickerAreaHeightPercent;
  final BorderRadius pickerAreaBorderRadius;
  final bool hexInputBar;
  final TextEditingController? hexInputController;
  final List<Color>? colorHistory;
  final ValueChanged<List<Color>>? onHistoryChanged;

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  HSVColor currentHsvColor = const HSVColor.fromAHSV(0.0, 0.0, 0.0, 0.0);
  List<Color> colorHistory = [];

  @override
  void initState() {
    currentHsvColor = (widget.pickerHsvColor != null)
        ? widget.pickerHsvColor as HSVColor
        : HSVColor.fromColor(widget.pickerColor);
    if (widget.hexInputController?.text.isEmpty == true) {
      widget.hexInputController?.text = colorToHex(
        currentHsvColor.toColor(),
        enableAlpha: widget.enableAlpha,
      );
    }
    widget.hexInputController?.addListener(colorPickerTextInputListener);
    if (widget.colorHistory != null && widget.onHistoryChanged != null) {
      colorHistory = widget.colorHistory ?? [];
    }
    super.initState();
  }

  @override
  void didUpdateWidget(WheelPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentHsvColor = (widget.pickerHsvColor != null)
        ? widget.pickerHsvColor as HSVColor
        : HSVColor.fromColor(widget.pickerColor);
  }

  void colorPickerTextInputListener() {
    if (widget.hexInputController == null) return;
    final Color? color = colorFromHex(
      widget.hexInputController!.text,
      enableAlpha: widget.enableAlpha,
    );
    if (color != null) {
      setState(() => currentHsvColor = HSVColor.fromColor(color));
      widget.onColorChanged(color);
      if (widget.onHsvColorChanged != null) {
        widget.onHsvColorChanged!(currentHsvColor);
      }
    }
  }

  @override
  void dispose() {
    widget.hexInputController?.removeListener(colorPickerTextInputListener);
    super.dispose();
  }

  Widget colorPickerSlider(TrackType trackType) {
    return ColorPickerSlider(trackType, currentHsvColor, (HSVColor color) {
      widget.hexInputController?.text = colorToHex(
        color.toColor(),
        enableAlpha: widget.enableAlpha,
      );
      setState(() => currentHsvColor = color);
      widget.onColorChanged(currentHsvColor.toColor());
      if (widget.onHsvColorChanged != null) {
        widget.onHsvColorChanged!(currentHsvColor);
      }
    }, displayThumbColor: widget.displayThumbColor);
  }

  void onColorChanging(HSVColor color) {
    widget.hexInputController?.text = colorToHex(
      color.toColor(),
      enableAlpha: widget.enableAlpha,
    );
    setState(() => currentHsvColor = color);
    widget.onColorChanged(currentHsvColor.toColor());
    if (widget.onHsvColorChanged != null) {
      widget.onHsvColorChanged!(currentHsvColor);
    }
  }

  Widget colorPicker() {
    return ClipRRect(
      borderRadius: widget.pickerAreaBorderRadius,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ColorPickerArea(
          currentHsvColor,
          onColorChanging,
          PaletteType.hueWheel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait ||
        widget.portraitOnly) {
      return Column(
        children: <Widget>[
          SizedBox(
            width: widget.colorPickerWidth,
            height: widget.colorPickerWidth * widget.pickerAreaHeightPercent,
            child: colorPicker(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
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
                        height: 40.0,
                        width: widget.colorPickerWidth - 75.0,
                        child: colorPickerSlider(TrackType.value),
                      ),
                      if (widget.enableAlpha)
                        SizedBox(
                          height: 40.0,
                          width: widget.colorPickerWidth - 75.0,
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
              width: widget.colorPickerWidth,
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (Color color in colorHistory)
                    Padding(
                      key: Key(color.hashCode.toString()),
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                      child: Center(
                        child: GestureDetector(
                          onTap: () =>
                              onColorChanging(HSVColor.fromColor(color)),
                          child: ColorIndicator(
                            HSVColor.fromColor(color),
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          if (widget.showLabel && widget.labelTypes.isNotEmpty)
            FittedBox(
              child: ColorPickerLabel(
                currentHsvColor,
                enableAlpha: widget.enableAlpha,
                colorLabelTypes: widget.labelTypes,
              ),
            ),
          if (widget.hexInputBar)
            ColorPickerInput(
              currentHsvColor.toColor(),
              (Color color) {
                setState(() => currentHsvColor = HSVColor.fromColor(color));
                widget.onColorChanged(currentHsvColor.toColor());
                if (widget.onHsvColorChanged != null) {
                  widget.onHsvColorChanged!(currentHsvColor);
                }
              },
              enableAlpha: widget.enableAlpha,
              embeddedText: false,
            ),
          const SizedBox(height: 20.0),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          SizedBox(
            width: widget.colorPickerWidth,
            height: widget.colorPickerWidth * widget.pickerAreaHeightPercent,
            child: colorPicker(),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(width: 20.0),
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
                        height: 40.0,
                        width: 260.0,
                        child: colorPickerSlider(TrackType.value),
                      ),
                      if (widget.enableAlpha)
                        SizedBox(
                          height: 40.0,
                          width: 260.0,
                          child: colorPickerSlider(TrackType.alpha),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                ],
              ),
              if (colorHistory.isNotEmpty)
                SizedBox(
                  width: widget.colorPickerWidth,
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (Color color in colorHistory)
                        Padding(
                          key: Key(color.hashCode.toString()),
                          padding: const EdgeInsets.fromLTRB(15, 18, 0, 0),
                          child: Center(
                            child: GestureDetector(
                              onTap: () =>
                                  onColorChanging(HSVColor.fromColor(color)),
                              onLongPress: () {
                                if (colorHistory.remove(color)) {
                                  widget.onHistoryChanged!(colorHistory);
                                  setState(() {});
                                }
                              },
                              child: ColorIndicator(
                                HSVColor.fromColor(color),
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
              const SizedBox(height: 20.0),
              if (widget.showLabel && widget.labelTypes.isNotEmpty)
                FittedBox(
                  child: ColorPickerLabel(
                    currentHsvColor,
                    enableAlpha: widget.enableAlpha,
                    colorLabelTypes: widget.labelTypes,
                  ),
                ),
              if (widget.hexInputBar)
                ColorPickerInput(
                  currentHsvColor.toColor(),
                  (Color color) {
                    setState(() => currentHsvColor = HSVColor.fromColor(color));
                    widget.onColorChanged(currentHsvColor.toColor());
                    if (widget.onHsvColorChanged != null) {
                      widget.onHsvColorChanged!(currentHsvColor);
                    }
                  },
                  enableAlpha: widget.enableAlpha,
                  embeddedText: false,
                ),
              const SizedBox(height: 5),
            ],
          ),
        ],
      );
    }
  }
}

class HUEColorWheelPainter extends CustomPainter {
  const HUEColorWheelPainter(this.hsvColor, {this.pointerColor});

  final HSVColor hsvColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radio = size.width <= size.height ? size.width / 2 : size.height / 2;

    final List<Color> colors = [
      const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
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

class _SliderLayout extends MultiChildLayoutDelegate {
  static const String track = 'track';
  static const String thumb = 'thumb';
  static const String gestureContainer = 'gesturecontainer';

  @override
  void performLayout(Size size) {
    layoutChild(
      track,
      BoxConstraints.tightFor(
        width: size.width - 30.0,
        height: size.height / 5,
      ),
    );
    positionChild(track, Offset(15.0, size.height * 0.4));
    layoutChild(
      thumb,
      BoxConstraints.tightFor(width: 5.0, height: size.height / 4),
    );
    positionChild(thumb, Offset(0.0, size.height * 0.4));
    layoutChild(
      gestureContainer,
      BoxConstraints.tightFor(width: size.width, height: size.height),
    );
    positionChild(gestureContainer, Offset.zero);
  }

  @override
  bool shouldRelayout(_SliderLayout oldDelegate) => false;
}

class IndicatorPainter extends CustomPainter {
  const IndicatorPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Size chessSize = Size(size.width / 10, size.height / 10);
    final Paint chessPaintB = Paint()..color = const Color(0xFFCCCCCC);
    final Paint chessPaintW = Paint()..color = Colors.white;
    List.generate((size.height / chessSize.height).round(), (int y) {
      List.generate((size.width / chessSize.width).round(), (int x) {
        canvas.drawRect(
          Offset(chessSize.width * x, chessSize.height * y) & chessSize,
          (x + y) % 2 != 0 ? chessPaintW : chessPaintB,
        );
      });
    });

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height / 2,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ColorPickerLabel extends StatefulWidget {
  const ColorPickerLabel(
    this.hsvColor, {
    super.key,
    this.enableAlpha = true,
    this.colorLabelTypes = const [
      ColorLabelType.rgb,
      ColorLabelType.hsv,
      ColorLabelType.hsl,
    ],
    this.textStyle,
  }) : assert(colorLabelTypes.length > 0);

  final HSVColor hsvColor;
  final bool enableAlpha;
  final TextStyle? textStyle;
  final List<ColorLabelType> colorLabelTypes;

  @override
  State<ColorPickerLabel> createState() => _ColorPickerLabelState();
}

class _ColorPickerLabelState extends State<ColorPickerLabel> {
  final Map<ColorLabelType, List<String>> _colorTypes = const {
    ColorLabelType.hex: ['R', 'G', 'B', 'A'],
    ColorLabelType.rgb: ['R', 'G', 'B', 'A'],
    ColorLabelType.hsv: ['H', 'S', 'V', 'A'],
    ColorLabelType.hsl: ['H', 'S', 'L', 'A'],
  };

  late ColorLabelType _colorType;

  @override
  void initState() {
    super.initState();
    _colorType = widget.colorLabelTypes[0];
  }

  List<String> colorValue(HSVColor hsvColor, ColorLabelType colorLabelType) {
    if (colorLabelType == ColorLabelType.hex) {
      final Color color = hsvColor.toColor();
      return [
        color.red.toRadixString(16).toUpperCase().padLeft(2, '0'),
        color.green.toRadixString(16).toUpperCase().padLeft(2, '0'),
        color.blue.toRadixString(16).toUpperCase().padLeft(2, '0'),
        color.alpha.toRadixString(16).toUpperCase().padLeft(2, '0'),
      ];
    } else if (colorLabelType == ColorLabelType.rgb) {
      final Color color = hsvColor.toColor();
      return [
        color.red.toString(),
        color.green.toString(),
        color.blue.toString(),
        '${(color.opacity * 100).round()}%',
      ];
    } else if (colorLabelType == ColorLabelType.hsv) {
      return [
        '${hsvColor.hue.round()}°',
        '${(hsvColor.saturation * 100).round()}%',
        '${(hsvColor.value * 100).round()}%',
        '${(hsvColor.alpha * 100).round()}%',
      ];
    } else if (colorLabelType == ColorLabelType.hsl) {
      HSLColour hslColor = hsvToHsl(hsvColor);
      return [
        '${hslColor.hue.round()}°',
        '${(hslColor.saturation * 100).round()}%',
        '${(hslColor.lightness * 100).round()}%',
        '${(hsvColor.alpha * 100).round()}%',
      ];
    } else {
      return ['??', '??', '??', '??'];
    }
  }

  List<Widget> colorValueLabels() {
    double fontSize = 14;
    if (widget.textStyle != null && widget.textStyle?.fontSize != null) {
      fontSize = widget.textStyle?.fontSize ?? 14;
    }

    return [
      for (String item in _colorTypes[_colorType] ?? [])
        if (widget.enableAlpha || item != 'A')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: fontSize * 2),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Text(
                      item,
                      style:
                          widget.textStyle ??
                          Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: Text(
                        colorValue(
                          widget.hsvColor,
                          _colorType,
                        )[_colorTypes[_colorType]!.indexOf(item)],
                        overflow: TextOverflow.ellipsis,
                        style:
                            widget.textStyle ??
                            Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButton(
          value: _colorType,
          onChanged: (ColorLabelType? type) {
            if (type != null) setState(() => _colorType = type);
          },
          items: [
            for (ColorLabelType type in widget.colorLabelTypes)
              DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last.toUpperCase()),
              ),
          ],
        ),
        const SizedBox(width: 10.0),
        ...colorValueLabels(),
      ],
    );
  }
}

class ColorPickerInput extends StatefulWidget {
  const ColorPickerInput(
    this.color,
    this.onColorChanged, {
    super.key,
    this.enableAlpha = true,
    this.embeddedText = false,
    this.disable = false,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool enableAlpha;
  final bool embeddedText;
  final bool disable;

  @override
  State<ColorPickerInput> createState() => _ColorPickerInputState();
}

class _ColorPickerInputState extends State<ColorPickerInput> {
  TextEditingController textEditingController = TextEditingController();
  int inputColor = 0;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (inputColor != widget.color.value) {
      textEditingController.text =
          '#${widget.color.red.toRadixString(16).toUpperCase().padLeft(2, '0')}${widget.color.green.toRadixString(16).toUpperCase().padLeft(2, '0')}${widget.color.blue.toRadixString(16).toUpperCase().padLeft(2, '0')}${widget.enableAlpha ? widget.color.alpha.toRadixString(16).toUpperCase().padLeft(2, '0') : ''}';
    }
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!widget.embeddedText)
            Text('Hex', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(width: 10),
          SizedBox(
            width:
                (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) * 10,
            child: TextField(
              enabled: !widget.disable,
              controller: textEditingController,
              inputFormatters: [
                UpperCaseTextFormatter(),
                FilteringTextInputFormatter.allow(RegExp(kValidHexPattern)),
              ],
              decoration: InputDecoration(
                isDense: true,
                label: widget.embeddedText ? const Text('Hex') : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
              ),
              onChanged: (String value) {
                String input = value;
                if (value.length == 9) {
                  input =
                      value.split('').getRange(7, 9).join() +
                      value.split('').getRange(1, 7).join();
                }
                final Color? color = colorFromHex(input);
                if (color != null) {
                  widget.onColorChanged(color);
                  inputColor = color.value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ColorIndicator extends StatelessWidget {
  const ColorIndicator(
    this.hsvColor, {
    super.key,
    this.width = 50.0,
    this.height = 50.0,
  });

  final HSVColor hsvColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(1000.0)),
        border: Border.all(color: const Color(0xffdddddd)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(1000.0)),
        child: CustomPaint(painter: IndicatorPainter(hsvColor.toColor())),
      ),
    );
  }
}

class ColorPickerArea extends StatelessWidget {
  const ColorPickerArea(
    this.hsvColor,
    this.onColorChanged,
    this.paletteType, {
    super.key,
  });

  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onColorChanged;
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

class ColorPickerSlider extends StatelessWidget {
  const ColorPickerSlider(
    this.trackType,
    this.hsvColor,
    this.onColorChanged, {
    super.key,
    this.displayThumbColor = false,
    this.fullThumbColor = false,
  });

  final TrackType trackType;
  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onColorChanged;
  final bool displayThumbColor;
  final bool fullThumbColor;

  void slideEvent(RenderBox getBox, BoxConstraints box, Offset globalPosition) {
    double localDx = getBox.globalToLocal(globalPosition).dx - 15.0;
    double progress =
        localDx.clamp(0.0, box.maxWidth - 30.0) / (box.maxWidth - 30.0);
    switch (trackType) {
      case TrackType.hue:
        onColorChanged(hsvColor.withHue(progress * 359));
        break;
      case TrackType.saturation:
        onColorChanged(hsvColor.withSaturation(progress));
        break;
      case TrackType.saturationForHSL:
        onColorChanged(hslToHsv(hsvToHsl(hsvColor).withSaturation(progress)));
        break;
      case TrackType.value:
        onColorChanged(hsvColor.withValue(progress));
        break;
      case TrackType.lightness:
        onColorChanged(hslToHsv(hsvToHsl(hsvColor).withLightness(progress)));
        break;
      case TrackType.red:
        onColorChanged(
          HSVColor.fromColor(
            hsvColor.toColor().withRed((progress * 0xff).round()),
          ),
        );
        break;
      case TrackType.green:
        onColorChanged(
          HSVColor.fromColor(
            hsvColor.toColor().withGreen((progress * 0xff).round()),
          ),
        );
        break;
      case TrackType.blue:
        onColorChanged(
          HSVColor.fromColor(
            hsvColor.toColor().withBlue((progress * 0xff).round()),
          ),
        );
        break;
      case TrackType.alpha:
        onColorChanged(
          hsvColor.withAlpha(
            localDx.clamp(0.0, box.maxWidth - 30.0) / (box.maxWidth - 30.0),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        double thumbOffset = 15.0;
        Color thumbColor;
        switch (trackType) {
          case TrackType.hue:
            thumbOffset += (box.maxWidth - 30.0) * hsvColor.hue / 360;
            thumbColor = HSVColor.fromAHSV(
              1.0,
              hsvColor.hue,
              1.0,
              1.0,
            ).toColor();
            break;
          case TrackType.saturation:
            thumbOffset += (box.maxWidth - 30.0) * hsvColor.saturation;
            thumbColor = HSVColor.fromAHSV(
              1.0,
              hsvColor.hue,
              hsvColor.saturation,
              1.0,
            ).toColor();
            break;
          case TrackType.saturationForHSL:
            thumbOffset +=
                (box.maxWidth - 30.0) * hsvToHsl(hsvColor).saturation;
            thumbColor = HSLColour.fromAHSL(
              1.0,
              hsvColor.hue,
              hsvToHsl(hsvColor).saturation,
              0.5,
            ).toColour();
            break;
          case TrackType.value:
            thumbOffset += (box.maxWidth - 30.0) * hsvColor.value;
            thumbColor = HSVColor.fromAHSV(
              1.0,
              hsvColor.hue,
              1.0,
              hsvColor.value,
            ).toColor();
            break;
          case TrackType.lightness:
            thumbOffset += (box.maxWidth - 30.0) * hsvToHsl(hsvColor).lightness;
            thumbColor = HSLColour.fromAHSL(
              1.0,
              hsvColor.hue,
              1.0,
              hsvToHsl(hsvColor).lightness,
            ).toColour();
            break;
          case TrackType.red:
            thumbOffset +=
                (box.maxWidth - 30.0) * hsvColor.toColor().red / 0xff;
            thumbColor = hsvColor.toColor().withOpacity(1.0);
            break;
          case TrackType.green:
            thumbOffset +=
                (box.maxWidth - 30.0) * hsvColor.toColor().green / 0xff;
            thumbColor = hsvColor.toColor().withOpacity(1.0);
            break;
          case TrackType.blue:
            thumbOffset +=
                (box.maxWidth - 30.0) * hsvColor.toColor().blue / 0xff;
            thumbColor = hsvColor.toColor().withOpacity(1.0);
            break;
          case TrackType.alpha:
            thumbOffset += (box.maxWidth - 30.0) * hsvColor.toColor().opacity;
            thumbColor = hsvColor.toColor().withOpacity(hsvColor.alpha);
            break;
        }

        return CustomMultiChildLayout(
          delegate: _SliderLayout(),
          children: <Widget>[
            LayoutId(
              id: _SliderLayout.track,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                child: CustomPaint(painter: TrackPainter(trackType, hsvColor)),
              ),
            ),
            LayoutId(
              id: _SliderLayout.thumb,
              child: Transform.translate(
                offset: Offset(thumbOffset, 0.0),
                child: CustomPaint(
                  painter: ThumbPainter(
                    thumbColor: displayThumbColor ? thumbColor : null,
                    fullThumbColor: fullThumbColor,
                  ),
                ),
              ),
            ),
            LayoutId(
              id: _SliderLayout.gestureContainer,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints box) {
                  RenderBox? getBox = context.findRenderObject() as RenderBox?;
                  return GestureDetector(
                    onPanDown: (DragDownDetails details) => getBox != null
                        ? slideEvent(getBox, box, details.globalPosition)
                        : null,
                    onPanUpdate: (DragUpdateDetails details) => getBox != null
                        ? slideEvent(getBox, box, details.globalPosition)
                        : null,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
