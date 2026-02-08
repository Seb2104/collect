import 'package:flutter/material.dart';

import '../../collect.dart';

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
  Widget base256View() => Center(child: Word.primary(widget.colour.b256));

  Widget hexView() => Center(child: Word.primary(widget.colour.hex));

  Widget argbView() => Center(child: Word.primary(widget.colour.argb));

  Widget hslView() => Center(child: Word.primary(widget.colour.hsl.toString()));
  MenuController menuController = MenuController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Menu(
            menuController: menuController,
            initialSelection: 'b256',
            items: [
              MenuEntry(value: "b256", label: 'B256'),
              MenuEntry(value: "hex", label: 'HEX'),
              MenuEntry(value: "argb", label: 'ARGB'),
              MenuEntry(value: "hsl", label: 'HSL'),
            ],
          ),
        ],
      ),
      //     child: TabView(
      //       tabPadding: EdgeInsets.all(0),
      //       tabPosition: Side.left,
      // tabsWidth: 50,
      //       content: TabViewContent([
      //         TabViewItem('b256', view: base256View()),
      //         TabViewItem('HEX', view: hexView()),
      //         TabViewItem('ARGB', view: argbView()),
      //         TabViewItem('HSL', view: hslView()),
      //       ]),
      //     ),
    );
  }
}
