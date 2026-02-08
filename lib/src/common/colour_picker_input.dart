import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../collect.dart';

class ColourPickerInput extends StatefulWidget {
  const ColourPickerInput(
    this.colour,
    this.onColourChanged, {
    super.key,
    this.enableAlpha = true,
    this.embeddedText = false,
    this.disable = false,
  });

  final Colour colour;
  final ValueChanged<Colour> onColourChanged;
  final bool enableAlpha;
  final bool embeddedText;
  final bool disable;

  @override
  State<ColourPickerInput> createState() => _ColourPickerInputState();
}

class _ColourPickerInputState extends State<ColourPickerInput> {
  TextEditingController textEditingController = TextEditingController();
  int inputColour = 0;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (inputColour != widget.colour.value) {
      textEditingController.text =
          '#${widget.colour.red.toRadixString(16).toUpperCase().padLeft(2, '0')}${widget.colour.green.toRadixString(16).toUpperCase().padLeft(2, '0')}${widget.colour.blue.toRadixString(16).toUpperCase().padLeft(2, '0')}${widget.enableAlpha ? widget.colour.alpha.toRadixString(16).toUpperCase().padLeft(2, '0') : ''}';
    }
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!widget.embeddedText)
            Text('Hex', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(width: 10),
          SizedBox(
            width:
                (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) * 10,
            child: TextField(
              enabled: !widget.disable,
              controller: textEditingController,
              inputFormatters: [
                UpperCaseTextFormatter(),
                FilteringTextInputFormatter.allow(RegExp(kValidHexPattern)),
              ],
              decoration: InputDecoration(
                isDense: true,
                label: widget.embeddedText ? const Text('Hex') : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
              ),
              onChanged: (String value) {
                String input = value;
                if (value.length == 9) {
                  input =
                      value.split('').getRange(7, 9).join() +
                      value.split('').getRange(1, 7).join();
                }
                final Colour? colour = Colour.fromColor(colorFromHex(input) ?? Colours.white);
                if (colour != null) {
                  widget.onColourChanged(colour);
                  inputColour = colour.value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
