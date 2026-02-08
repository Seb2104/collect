import 'package:collect/collect.dart';
import 'package:flutter/material.dart';

class ColourLabel extends StatefulWidget {
  final Colour colour;
  final bool enableAlpha;
  final TextStyle? textStyle;
  final List<ColorLabelType> colorLabelTypes;
  final double height;
  final double width;

  const ColourLabel(
    this.colour, {
    super.key,
    this.enableAlpha = true,
    this.colorLabelTypes = const [
      ColorLabelType.rgb,
      ColorLabelType.hsv,
      ColorLabelType.hsl,
    ],
    this.textStyle,
    this.height = 140,
    this.width = 240,
  }) : assert(colorLabelTypes.length > 0);

  @override
  State<ColourLabel> createState() => _ColourLabelState();
}

class _ColourLabelState extends State<ColourLabel> {
  String b256() => widget.colour.b256;

  String hexView() => widget.colour.hex;

  String argbView() => widget.colour.argb;

  String hslView() => widget.colour.hsl.toString();
  MenuControl menuController = MenuControl();
  String selectedFormat = 'b256';

  @override
  void initState() {
    super.initState();
    menuController.selectedValue = selectedFormat;
  }

  String getViewForFormat(String format) {
    switch (format) {
      case 'b256':
        return b256();
      case 'hex':
        return hexView();
      case 'argb':
        return argbView();
      case 'hsl':
        return hslView();
      default:
        return b256();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Menu(
              width: 100,
              onChanged: (value) {
                selectedFormat = value!;
                menuController.selectedValue = selectedFormat;
                print(selectedFormat);
                setState(() {});
              },
              textStyle: TextStyle(fontSize: 11),
              items: [
                MenuItemString(value: 'b256', label: 'b256'),
                MenuItemString(value: 'hex', label: 'HEX'),
                MenuItemString(value: 'argb', label: 'ARGB'),
                MenuItemString(value: 'hsl', label: 'HSL'),
              ],
            ),
          ),
          Word(
            getViewForFormat(selectedFormat),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
