import 'package:collect/collect.dart';
import 'package:flutter/material.dart';

Colour colour = Colours.white;

void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        backgroundColor: AppTheme.background(context),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 250,
              crossAxisCount: 2,
              crossAxisSpacing: 50,
              mainAxisSpacing: 50,
            ),
            children: [
              Container(
                color: Colours.blueGrey,
                height: 250,
                width: 800,
                child: ColourPicker.wheel(
                  height: 200,
                  width: 800,
                  currentColour: colour,
                  onColourChanged: (value) {
                    colour = value.colour;
                    setState(() {});
                  },
                ),
              ),
              Container(
                color: Colours.blueGrey,
                height: 250,
                width: 800,
                child: ColourPicker.slides(
                  currentColour: colour,
                  onColorChanged: (value) {
                    colour = value.colour;
                    setState(() {});
                  },
                ),
              ),
              Container(
                color: Colours.blueGrey,
                height: 250,
                width: 800,
                child: ColourPicker.ring(
                  currentColour: colour,
                  onColorChanged: (value) {
                    colour = value.colour;
                    setState(() {});
                  },
                ),
              ),
              Container(
                color: Colours.blueGrey,
                height: 100,
                width: 800,
                child: ColourPicker.square(
                  currentColour: colour,
                  onColorChanged: (value) {
                    colour = value.colour;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
