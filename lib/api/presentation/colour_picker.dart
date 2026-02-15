part of '../../collect.dart';

//TODO change it so you can just specify the orientation
class ColourPicker {
  static Widget wheel({
    required Colour currentColour,
    required ValueChanged<Colour> onColourChanged,
    double height = 300,
    double size = 700,
    PickerStyle style = const PickerStyle(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.lightBackground,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    double pickerRadius = 125,
    bool enableAlpha = true,
    bool showLabel = true,
    bool displayThumbColor = true,
    Orientation orientation = Orientation.landscape,

    HSVColour? pickerHsvColour,
    ValueChanged<HSVColor>? onHsvColourChanged,
    List<Colour>? colourHistory,
    ValueChanged<List<Color>>? onHistoryChanged,
  }) {
    return WheelPicker(
      currentColour: currentColour,
      onColourChanged: onColourChanged,
      size: size,
      style: style,
      pickerRadius: pickerRadius,
      showLabel: showLabel,
      displayThumbColor: displayThumbColor,
      orientation: orientation,
      pickerHsvColour: pickerHsvColour,
      onHsvColourChanged: onHsvColourChanged,
      colourHistory: colourHistory,
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
