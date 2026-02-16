import 'package:collect/collect.dart';
import 'package:flutter/material.dart';

// colorLabelTypes: [
// ColorLabelType.hex,
// ColorLabelType.rgb,
// ColorLabelType.hsl,
// ColorLabelType.hsv,
// ],

class ColourLabel extends StatefulWidget {
  final Colour colour;
  final double height;
  final double width;

  const ColourLabel(
    this.colour, {
    super.key,
    this.height = 140,
    this.width = 300,
  });

  @override
  State<ColourLabel> createState() => _ColourLabelState();
}

class _ColourLabelState extends State<ColourLabel> {
  String b256() => widget.colour.b256;

  String hexView() => widget.colour.hex;

  String argbView() => widget.colour.argb;

  String hslView() => widget.colour.hsl.toString();

  String hsvView() => widget.colour.hsv.toString();

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
      case 'hsv':
        return hsvView();
      default:
        return b256();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        children: [
          MenuDropDown(
            width: 100,
            value: selectedFormat,
            onChanged: (val) {
              selectedFormat = val;
              menuController.selectedValue = selectedFormat;
              print(selectedFormat);
              setState(() {});
            },
            textStyle: TextStyle(fontSize: 11),
            items: ['b256', 'hex', 'argb', 'hsl', 'hsv'],
          ),
          Spacer(),
          Word(getViewForFormat(selectedFormat), fontSize: 14),
        ],
      ),
    );
  }
}
