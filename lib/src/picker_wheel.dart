import 'package:flutter/material.dart';

import '../collect.dart';
import 'base/base_colour_picker.dart';
import 'common/common.dart';
import 'gestures/colour_picker_gesture_detector.dart';
import 'painters/wheel_painter.dart';

class WheelPicker extends StatefulWidget {
  const WheelPicker({
    super.key,
    required this.height,
    required this.width,
    required this.pickerColour,
    required this.onColourChanged,
    this.pickerHsvColour,
    this.onHsvColourChanged,
    this.enableAlpha = true,
    this.showLabel = true,
    this.labelTypes = const [ColorLabelType.rgb, ColorLabelType.hex],
    this.displayThumbColor = false,
    this.portraitOnly = false,
    this.pickerRadius = 300.0,
    this.pickerAreaHeightPercent = 1.0,
    this.pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
    this.colourHistory,
    this.onHistoryChanged,
  });

  final double height;
  final double width;
  final double pickerRadius;

  final Colour pickerColour;
  final ValueChanged<Colour> onColourChanged;
  final HSVColour? pickerHsvColour;
  final ValueChanged<HSVColour>? onHsvColourChanged;
  final bool enableAlpha;
  final bool showLabel;
  final List<ColorLabelType> labelTypes;
  final bool displayThumbColor;
  final bool portraitOnly;
  final double pickerAreaHeightPercent;
  final BorderRadius pickerAreaBorderRadius;
  final List<Colour>? colourHistory;
  final ValueChanged<List<Colour>>? onHistoryChanged;

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends BaseColourPicker<WheelPicker> {
  @override
  Color getInitialColor() => widget.pickerColour;

  @override
  HSVColour? getInitialHsvColor() => widget.pickerHsvColour;

  @override
  List<Color>? getColorHistory() => widget.colourHistory?.cast<Color>();

  @override
  ValueChanged<List<Color>>? getHistoryChangedCallback() {
    if (widget.onHistoryChanged == null) return null;
    return (List<Color> colors) {
      widget.onHistoryChanged!(colors.cast<Colour>());
    };
  }

  @override
  void notifyColorChanged(HSVColour color) {
    widget.onColourChanged(color.toColour());
    if (widget.onHsvColourChanged != null) {
      widget.onHsvColourChanged!(color);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isPortrait(context, widget.portraitOnly)) {
      return Column(
        children: <Widget>[
          SizedBox(
            width: widget.pickerRadius,
            height: widget.pickerRadius * widget.pickerAreaHeightPercent,
            child: WheelGestureDetector(
              onColorChanged: onColorChanging,
              hsvColor: currentHsvColor,
              child: CustomPaint(
                painter: HUEColorWheelPainter(currentHsvColor),
              ),
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
                  onTap: addToHistory,
                  child: ColorIndicator(currentHsvColor),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: widget.pickerRadius * 0.133,
                        width: widget.pickerRadius * 0.75,
                        child: buildColorPickerSlider(
                          TrackType.value,
                          displayThumbColor: widget.displayThumbColor,
                        ),
                      ),
                      if (widget.enableAlpha)
                        SizedBox(
                          height: widget.pickerRadius * 0.133,
                          width: widget.pickerRadius * 0.75,
                          child: buildColorPickerSlider(
                            TrackType.alpha,
                            displayThumbColor: widget.displayThumbColor,
                          ),
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
                  for (Color colour in colorHistory)
                    Padding(
                      key: Key(colour.hashCode.toString()),
                      padding: EdgeInsets.fromLTRB(
                        widget.pickerRadius * 0.05,
                        0,
                        0,
                        widget.pickerRadius * 0.033,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () =>
                              onColorChanging(HSVColour.fromColor(colour)),
                          child: ColorIndicator(
                            HSVColour.fromColor(colour),
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
              child: WheelGestureDetector(
                onColorChanged: onColorChanging,
                hsvColor: currentHsvColor,
                child: CustomPaint(
                  painter: HUEColorWheelPainter(currentHsvColor),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: widget.pickerRadius * 0.067),
                    GestureDetector(
                      onTap: addToHistory,
                      child: ColorIndicator(currentHsvColor),
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: widget.pickerRadius * 0.133,
                          width: widget.pickerRadius * 0.867,
                          child: buildColorPickerSlider(
                            TrackType.value,
                            displayThumbColor: widget.displayThumbColor,
                          ),
                        ),
                        if (widget.enableAlpha)
                          SizedBox(
                            height: widget.pickerRadius * 0.133,
                            width: widget.pickerRadius * 0.867,
                            child: buildColorPickerSlider(
                              TrackType.alpha,
                              displayThumbColor: widget.displayThumbColor,
                            ),
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
                                onLongPress: () => removeFromHistory(color),
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
