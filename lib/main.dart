import 'package:flutter/material.dart';

void main() {
  print('Hello World!');
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Container()));
  }
}
