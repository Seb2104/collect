part of '../../collect.dart';

class ColourPicker {
  static Widget wheel({
    /// The size of the container surrounding the colour picker
    required double height,

    /// The size of the container surrounding the colour picker
    required double width,

    required Colour currentColour,
    double pickerRadius = 300,
    required ValueChanged<Colour> onColourChanged,
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
    double pickerAreaHeightPercent = 1.0,
    BorderRadius? pickerAreaBorderRadius,
    List<Colour>? colourHistory,
    ValueChanged<List<Color>>? onHistoryChanged,
  }) {
    return WheelPicker(
      height: height,
      width: width,
      pickerColour: currentColour,
      onColourChanged: onColourChanged,
      enableAlpha: enableAlpha,
      showLabel: showLabel,
      labelTypes: labelTypes,
      displayThumbColor: displayThumbColor,
      portraitOnly: portraitOnly,
      pickerRadius: pickerRadius,
      pickerAreaHeightPercent: pickerAreaHeightPercent,
      colorHistory: colourHistory,
      onHistoryChanged: onHistoryChanged,
    );
  }

  static Widget square({
    required Color currentColour,
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
      currentColour: currentColour,
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
      colorHistory: colorHistory,
      onHistoryChanged: onHistoryChanged,
    );
  }

  static Widget slides({
    required Color currentColour,
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
      currentColour: currentColour,
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
    required Color currentColour,
    required ValueChanged<Color> onColorChanged,
    bool portraitOnly = false,
    double colorPickerHeight = 250.0,
    double hueRingStrokeWidth = 20.0,
    bool enableAlpha = false,
    bool displayThumbColor = true,
    BorderRadius pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
  }) {
    return HueRingPicker(
      currentColour: currentColour,
      onColorChanged: onColorChanged,
      portraitOnly: portraitOnly,
      colorPickerHeight: colorPickerHeight,
      hueRingStrokeWidth: hueRingStrokeWidth,
    );
  }
}
