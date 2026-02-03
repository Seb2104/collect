import 'package:collect/collect.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: TabView());
  }
}
