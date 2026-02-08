import 'package:collect/src/picker_ring.dart';
import 'package:collect/src/picker_slides.dart';
import 'package:collect/src/picker_square.dart';
import 'package:flutter/material.dart';

import '../../collect.dart';
import '../../src/picker_wheel.dart';

class ColourPicker {
  static Widget wheel({
    required Color pickerColor,
    required ValueChanged<Color> onColorChanged,
    HSVColor? pickerHsvColor,
    ValueChanged<HSVColor>? onHsvColorChanged,
    bool enableAlpha = true,
    bool showLabel = true,
    List<ColorLabelType> labelTypes = const [
      ColorLabelType.rgb,
      ColorLabelType.hex,
    ],
    bool displayThumbColor = true,
    bool portraitOnly = false,
    double size = 600,
    double colorPickerWidth = 300,
    double pickerAreaHeightPercent = 1.0,
    bool hexInputBar = false,
    TextEditingController? hexInputController,
    BorderRadius? pickerAreaBorderRadius,
    List<Color>? colorHistory,
    ValueChanged<List<Color>>? onHistoryChanged,
  }) {
    return WheelPicker(
      pickerColor: pickerColor,
      onColorChanged: onColorChanged,
      enableAlpha: enableAlpha,
      showLabel: showLabel,
      labelTypes: labelTypes,
      displayThumbColor: displayThumbColor,
      portraitOnly: portraitOnly,
      size: size,
      colorPickerSize: colorPickerWidth,
      pickerAreaHeightPercent: pickerAreaHeightPercent,
      hexInputBar: false,
      hexInputController: hexInputController,
      colorHistory: colorHistory,
      onHistoryChanged: onHistoryChanged,
    );
  }

  static Widget square({
    required Color pickerColor,
    required ValueChanged<Color> onColorChanged,
    HSVColour? pickerHsvColor,
    ValueChanged<HSVColor>? onHsvColorChanged,
    PaletteType paletteType = PaletteType.hueWheel,
    bool enableAlpha = true,
    bool showLabel = true,
    List<ColorLabelType> labelTypes = const [
      ColorLabelType.rgb,
      ColorLabelType.hex,
    ],
    bool displayThumbColor = true,
    bool portraitOnly = false,
    double colorPickerWidth = 300,
    double pickerAreaHeightPercent = 1.0,
    bool hexInputBar = false,
    TextEditingController? hexInputController,
    BorderRadius? pickerAreaBorderRadius,
    List<Color>? colorHistory,
    ValueChanged<List<Color>>? onHistoryChanged,
  }) {
    return SquarePicker(
      pickerColor: pickerColor,
      onColorChanged: onColorChanged,
      pickerHsvColor: pickerHsvColor,
      onHsvColorChanged: onHsvColorChanged,
      paletteType: paletteType,
      enableAlpha: enableAlpha,
      showLabel: showLabel,
      labelTypes: labelTypes,
      displayThumbColor: displayThumbColor,
      portraitOnly: portraitOnly,
      colorPickerWidth: colorPickerWidth,
      pickerAreaHeightPercent: pickerAreaHeightPercent,
      hexInputBar: false,
      hexInputController: hexInputController,
      colorHistory: colorHistory,
      onHistoryChanged: onHistoryChanged,
    );
  }

  static Widget slides({
    required Color pickerColor,
    required ValueChanged<Color> onColorChanged,
    ColorModel colorModel = ColorModel.rgb,
    bool enableAlpha = true,
    Size sliderSize = const Size(260, 40),
    bool showSliderText = true,
    TextStyle? sliderTextStyle,
    bool showLabel = true,
    bool showParams = true,
    List<ColorLabelType> labelTypes = const [],
    TextStyle? labelTextStyle,
    bool showIndicator = true,
    Size indicatorSize = const Size(280, 50),
    AlignmentGeometry indicatorAlignmentBegin = const Alignment(-1.0, -3.0),
    AlignmentGeometry indicatorAlignmentEnd = const Alignment(1.0, 3.0),
    bool displayThumbColor = true,
    BorderRadius indicatorBorderRadius = const BorderRadius.all(Radius.zero),
  }) {
    return SlidePicker(
      pickerColor: pickerColor,
      onColorChanged: onColorChanged,
      colorModel: colorModel,
      enableAlpha: enableAlpha,
      sliderSize: sliderSize,
      showSliderText: showSliderText,
      sliderTextStyle: sliderTextStyle,
      showLabel: showLabel,
      showParams: showParams,
      labelTypes: labelTypes,
      labelTextStyle: labelTextStyle,
      showIndicator: showIndicator,
      indicatorSize: indicatorSize,
      indicatorAlignmentBegin: indicatorAlignmentBegin,
      indicatorAlignmentEnd: indicatorAlignmentEnd,
      displayThumbColor: displayThumbColor,
      indicatorBorderRadius: indicatorBorderRadius,
    );
  }

  static Widget ring({
    required Color pickerColor,
    required ValueChanged<Color> onColorChanged,
    bool portraitOnly = false,
    double colorPickerHeight = 250.0,
    double hueRingStrokeWidth = 20.0,
    bool enableAlpha = false,
    bool displayThumbColor = true,
    BorderRadius pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
  }) {
    return HueRingPicker(
      pickerColor: pickerColor,
      onColorChanged: onColorChanged,
      portraitOnly: portraitOnly,
      colorPickerHeight: colorPickerHeight,
      hueRingStrokeWidth: hueRingStrokeWidth,
    );
  }
}
