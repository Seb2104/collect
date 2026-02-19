import 'package:collect/collect.dart';
import 'package:flutter/material.dart';

import '../constants/demos.dart';

class MenuDemo extends StatefulWidget {
  const MenuDemo({super.key});

  @override
  State<MenuDemo> createState() => _MenuDemoState();
}

class _MenuDemoState extends State<MenuDemo> {
  String selected = menuItems[0].value;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          color: AppTheme.background(context),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilteredMenu(
                  entries: [MenuEntry(value: 'value', label: 'label')],
                ),
                SizedBox(height: 20),
                Word('Selected value: $selected'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}