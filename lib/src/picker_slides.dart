library slider_picker;

import 'package:flutter/material.dart';

import '../collect.dart';

class SlidePicker extends StatefulWidget {
  const SlidePicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.colorModel = ColorModel.rgb,
    this.enableAlpha = true,
    this.sliderSize = const Size(260, 40),
    this.showSliderText = true,
    this.sliderTextStyle,
    this.showParams = true,
    this.showLabel = true,
    this.labelTypes = const [],
    this.labelTextStyle,
    this.showIndicator = true,
    this.indicatorSize = const Size(280, 50),
    this.indicatorAlignmentBegin = const Alignment(-1.0, -3.0),
    this.indicatorAlignmentEnd = const Alignment(1.0, 3.0),
    this.displayThumbColor = true,
    this.indicatorBorderRadius = const BorderRadius.all(Radius.zero),
  });

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final ColorModel colorModel;
  final bool enableAlpha;
  final Size sliderSize;
  final bool showSliderText;
  final TextStyle? sliderTextStyle;
  final bool showLabel;
  final bool showParams;
  final List<ColorLabelType> labelTypes;
  final TextStyle? labelTextStyle;
  final bool showIndicator;
  final Size indicatorSize;
  final AlignmentGeometry indicatorAlignmentBegin;
  final AlignmentGeometry indicatorAlignmentEnd;
  final bool displayThumbColor;
  final BorderRadius indicatorBorderRadius;

  @override
  State<StatefulWidget> createState() => _SlidePickerState();
}

class _SlidePickerState extends State<SlidePicker> {
  HSVColour currentHsvColor = const HSVColour.fromAHSV(0.0, 0.0, 0.0, 0.0);

  @override
  void initState() {
    super.initState();
    currentHsvColor = HSVColour.fromColor(widget.pickerColor);
  }

  @override
  void didUpdateWidget(SlidePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentHsvColor = HSVColour.fromColor(widget.pickerColor);
  }

  Widget colorPickerSlider(TrackType trackType) {
    return ColorPickerSlider(
      trackType,
      currentHsvColor,
      (HSVColour color) {
        setState(() => currentHsvColor = color);
        widget.onColorChanged(currentHsvColor.toColor());
      },
      displayThumbColor: widget.displayThumbColor,
      fullThumbColor: true,
    );
  }

  Widget indicator() {
    return ClipRRect(
      borderRadius: widget.indicatorBorderRadius,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: () {
          setState(
            () => currentHsvColor = HSVColour.fromColor(widget.pickerColor),
          );
          widget.onColorChanged(currentHsvColor.toColor());
        },
        child: Container(
          width: widget.indicatorSize.width,
          height: widget.indicatorSize.height,
          margin: const EdgeInsets.only(bottom: 15.0),
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.pickerColor,
                widget.pickerColor,
                currentHsvColor.toColor(),
                currentHsvColor.toColor(),
              ],
              begin: widget.indicatorAlignmentBegin,
              end: widget.indicatorAlignmentEnd,
              stops: const [0.0, 0.5, 0.5, 1.0],
            ),
          ),
          child: const CustomPaint(painter: CheckerPainter()),
        ),
      ),
    );
  }

  String getColorParams(int pos) {
    assert(pos >= 0 && pos < 4);
    if (widget.colorModel == ColorModel.rgb) {
      final Color color = currentHsvColor.toColor();
      return [
        color.red.toString(),
        color.green.toString(),
        color.blue.toString(),
        '${(color.opacity * 100).round()}',
      ][pos];
    } else if (widget.colorModel == ColorModel.hsv) {
      return [
        currentHsvColor.hue.round().toString(),
        (currentHsvColor.saturation * 100).round().toString(),
        (currentHsvColor.value * 100).round().toString(),
        (currentHsvColor.alpha * 100).round().toString(),
      ][pos];
    } else if (widget.colorModel == ColorModel.hsl) {
      HSLColour hslColor = hsvToHsl(currentHsvColor);
      return [
        hslColor.hue.round().toString(),
        (hslColor.saturation * 100).round().toString(),
        (hslColor.lightness * 100).round().toString(),
        (currentHsvColor.alpha * 100).round().toString(),
      ][pos];
    } else {
      return '??';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double fontSize = widget.labelTextStyle?.fontSize ?? 14;

    final List<TrackType> trackTypes = [
      if (widget.colorModel == ColorModel.hsv) ...[
        TrackType.hue,
        TrackType.saturation,
        TrackType.value,
      ],
      if (widget.colorModel == ColorModel.hsl) ...[
        TrackType.hue,
        TrackType.saturationForHSL,
        TrackType.lightness,
      ],
      if (widget.colorModel == ColorModel.rgb) ...[
        TrackType.red,
        TrackType.green,
        TrackType.blue,
      ],
      if (widget.enableAlpha) ...[TrackType.alpha],
    ];
    List<SizedBox> sliders = [
      for (TrackType trackType in trackTypes)
        SizedBox(
          width: widget.sliderSize.width,
          height: widget.sliderSize.height,
          child: Row(
            children: <Widget>[
              if (widget.showSliderText)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    trackType.toString().split('.').last[0].toUpperCase(),
                    style:
                        widget.sliderTextStyle ??
                        Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              Expanded(child: colorPickerSlider(trackType)),
              if (widget.showParams)
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: fontSize * 2 + 5),
                  child: Text(
                    getColorParams(trackTypes.indexOf(trackType)),
                    style:
                        widget.sliderTextStyle ??
                        Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          ),
        ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.showIndicator) indicator(),
        if (!widget.showIndicator) const SizedBox(height: 20),
        ...sliders,
        const SizedBox(height: 20.0),
        if (widget.showLabel && widget.labelTypes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ColorPickerLabel(
              currentHsvColor,
              enableAlpha: widget.enableAlpha,
              textStyle: widget.labelTextStyle,
              colorLabelTypes: widget.labelTypes,
            ),
          ),
      ],
    );
  }
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

class CheckerPainter extends CustomPainter {
  const CheckerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Size chessSize = Size(size.height / 6, size.height / 6);
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

  final HSVColour hsvColor;
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

  List<String> colorValue(HSVColour hsvColor, ColorLabelType colorLabelType) {
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
  final HSVColour hsvColor;
  final ValueChanged<HSVColour> onColorChanged;
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
          HSVColour.fromColor(
            hsvColor.toColor().withRed((progress * 0xff).round()),
          ),
        );
        break;
      case TrackType.green:
        onColorChanged(
          HSVColour.fromColor(
            hsvColor.toColor().withGreen((progress * 0xff).round()),
          ),
        );
        break;
      case TrackType.blue:
        onColorChanged(
          HSVColour.fromColor(
            hsvColor.toColor().withBlue((progress * 0xff).round()),
          ),
        );
        break;
      case TrackType.alpha:
        onColorChanged(
          hsvColor.withAlpha(
            localDx.clamp(0.0, box.maxWidth - 30.0) / (box.maxWidth - 30.0),
          ).toHSVColour,
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
            thumbColor = HSVColour.fromAHSV(
              1.0,
              hsvColor.hue,
              1.0,
              1.0,
            ).toColor();
            break;
          case TrackType.saturation:
            thumbOffset += (box.maxWidth - 30.0) * hsvColor.saturation;
            thumbColor = HSVColour.fromAHSV(
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
            thumbColor = HSVColour.fromAHSV(
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
