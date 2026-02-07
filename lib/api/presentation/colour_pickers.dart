import 'package:flutter/material.dart';

import '../../collect.dart';
import '../../src/picker_wheel.dart';

class ColourPicker {
  static Widget wheel({
    required Color pickerColor,
    required ValueChanged<Color> onColorChanged,
    HSVColor? pickerHsvColor,
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
    return WheelPicker(
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
}
