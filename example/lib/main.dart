import 'package:collect/api/presentation/colour_picker.dart';
import 'package:collect/collect.dart';
import 'package:flutter/material.dart';

Colour colour = Colours.black;

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        backgroundColor: AppTheme.background(context),
        body: Center(
          child: SizedBox(
            child: ColourPicker.wheel(
              // colorPickerWidth: 300,
              // hexInputBar: true,
              pickerColor: colour,
              onColorChanged: (value) {
                colour = Colour.fromColor(value);
                print(colour.print());
              },
            ),
          ),
        ),
      ),
    );
  }
}
