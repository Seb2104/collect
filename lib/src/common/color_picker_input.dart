import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../collect.dart';

class ColorPickerInput extends StatefulWidget {
  const ColorPickerInput(
    this.color,
    this.onColorChanged, {
    super.key,
    this.enableAlpha = true,
    this.embeddedText = false,
    this.disable = false,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool enableAlpha;
  final bool embeddedText;
  final bool disable;

  @override
  State<ColorPickerInput> createState() => _ColorPickerInputState();
}

class _ColorPickerInputState extends State<ColorPickerInput> {
  TextEditingController textEditingController = TextEditingController();
  int inputColor = 0;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (inputColor != widget.color.value) {
      textEditingController.text =
          '#${widget.color.red.toRadixString(16).toUpperCase().padLeft(2, '0')}${widget.color.green.toRadixString(16).toUpperCase().padLeft(2, '0')}${widget.color.blue.toRadixString(16).toUpperCase().padLeft(2, '0')}${widget.enableAlpha ? widget.color.alpha.toRadixString(16).toUpperCase().padLeft(2, '0') : ''}';
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
                final Color? color = colorFromHex(input);
                if (color != null) {
                  widget.onColorChanged(color);
                  inputColor = color.value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
