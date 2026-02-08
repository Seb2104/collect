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
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Center(
            child: Container(child: ReCollectIcons.backgroundColour),
          ),
        ),
      ),
    );
  }
}
