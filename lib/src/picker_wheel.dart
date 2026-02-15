import 'package:flutter/material.dart';

import '../collect.dart';
import 'base/base_colour_picker.dart';
import 'common/common.dart';
import 'gestures/colour_picker_gesture_detector.dart';
import 'painters/wheel_painter.dart';

class WheelPicker extends StatefulWidget {
  const WheelPicker({
    super.key,
    required this.currentColour,
    required this.onColourChanged,
    required this.height,
    required this.width,
    required this.style,
    required this.pickerRadius,
    required this.enableAlpha,
    required this.showLabel,
    required this.displayThumbColor,
    required this.orientation,

    this.pickerHsvColour,
    this.onHsvColourChanged,
    this.colourHistory,
    this.onHistoryChanged,
  });

  final double height;
  final double width;
  final double pickerRadius;

  final Colour currentColour;
  final ValueChanged<Colour> onColourChanged;
  final HSVColour? pickerHsvColour;
  final ValueChanged<HSVColour>? onHsvColourChanged;
  final bool enableAlpha;
  final bool showLabel;
  final bool displayThumbColor;
  final Orientation orientation;
  final List<Colour>? colourHistory;
  final ValueChanged<List<Colour>>? onHistoryChanged;
  final PickerStyle style;

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends BaseColourPicker<WheelPicker> {
  @override
  Color getInitialColor() => widget.currentColour;

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

  onColourChange(HSVColour colour) {
    widget.onColourChanged(colour.toColour());
    if (widget.onHsvColourChanged != null) {
      widget.onHsvColourChanged!(colour);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orientation == Orientation.portrait) {
      return Column(
        children: <Widget>[
          SizedBox(
            width: widget.pickerRadius * 2,
            height: widget.pickerRadius * 2,
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
          if (widget.showLabel)
            FittedBox(
              child: ColourLabel(
                currentHsvColor.toColour(),
                enableAlpha: widget.enableAlpha,
                colorLabelTypes: [
                  ColorLabelType.hex,
                  ColorLabelType.rgb,
                  ColorLabelType.hsl,
                  ColorLabelType.hsv,
                ],
              ),
            ),
        ],
      );
    } else {
      return Container(
        height: widget.height,
        width: widget.width,
        decoration: widget.style.decoration,
        padding: widget.style.padding,
        margin: widget.style.margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: widget.pickerRadius * 2,
              height: widget.pickerRadius * 2,
              child: WheelGestureDetector(
                onColorChanged: onColorChanging,
                hsvColor: currentHsvColor,
                child: CustomPaint(
                  painter: HUEColorWheelPainter(currentHsvColor),
                ),
              ),
            ),
            VerticalDivider(color: Colours.black.withOpacity(0.3)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  colour: currentHsvColor,
                  size: widget.pickerRadius,
                  displayThumbColour: widget.displayThumbColor,
                  alphaEnabled: widget.enableAlpha,
                  onChanged: onColourChange,
                ),
                // Row(
                //   children: <Widget>[
                //     GestureDetector(
                //       onTap: addToHistory,
                //       child: ColorIndicator(currentHsvColor),
                //     ),
                //     Column(
                //       children: <Widget>[
                //         SizedBox(
                //           height: widget.pickerRadius * 0.3,
                //           width: widget.pickerRadius * 2,
                //           child: ColourPickerSlider(
                //             TrackType.value,
                //             currentHsvColor,
                //             (HSVColour colour) {
                //               setState(() => currentHsvColor = colour);
                //               notifyColorChanged(colour);
                //             },
                //             displayThumbColor: widget.displayThumbColor,
                //           ),
                //         ),
                //         if (widget.enableAlpha)
                //           SizedBox(
                //             height: widget.pickerRadius * 0.3,
                //             width: widget.pickerRadius * 2,
                //             child: ColourPickerSlider(
                //               TrackType.alpha,
                //               currentHsvColor,
                //               (HSVColour colour) {
                //                 setState(() => currentHsvColor = colour);
                //                 notifyColorChanged(colour);
                //               },
                //               displayThumbColor: widget.displayThumbColor,
                //             ),
                //           ),
                //       ],
                //     ),
                //   ],
                // ),
                if (widget.showLabel)
                  ColourLabel(
                    height:
                        (widget.height / 2) -
                        widget.style.padding.along(Axis.vertical) -
                        widget.style.margin.along(Axis.vertical),
                    width:
                        (widget.width / 2) -
                        widget.style.padding.along(Axis.horizontal),
                    currentHsvColor.toColour(),
                    enableAlpha: widget.enableAlpha,
                    colorLabelTypes: [
                      ColorLabelType.hex,
                      ColorLabelType.rgb,
                      ColorLabelType.hsl,
                      ColorLabelType.hsv,
                    ],
                  ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class Indicator extends StatefulWidget {
  final double size;
  final HSVColour colour;
  final bool displayThumbColour;
  final bool alphaEnabled;
  final onChanged;

  const Indicator({
    super.key,
    required this.colour,
    required this.size,
    required this.displayThumbColour,
    required this.alphaEnabled,
    required this.onChanged,
  });

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {

  @override
  Widget build(BuildContext context) {
     HSVColour currentHSVColour = widget.colour.toHSVColour;
    return Row(
      children: <Widget>[
        ColorIndicator(currentHSVColour),
        Column(
          children: <Widget>[
            SizedBox(
              height: widget.size * 0.3,
              width: widget.size * 2,
              child: ColourPickerSlider(
                TrackType.value,
                currentHSVColour,
                (colour) {
                  widget.onChanged(colour);
                },
                displayThumbColor: widget.displayThumbColour,
              ),
            ),
            if (widget.alphaEnabled)
              SizedBox(
                height: widget.size * 0.3,
                width: widget.size * 2,
                child: ColourPickerSlider(
                  TrackType.alpha,
                  currentHSVColour,
                      (colour) {
                    widget.onChanged(colour);
                  },
                  displayThumbColor: widget.displayThumbColour,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
