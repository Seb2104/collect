import 'package:collect/collect.dart';
import 'package:example/constants/demos.dart';
import 'package:flutter/material.dart';

class FilteredMenuDemo extends StatefulWidget {
  const FilteredMenuDemo({super.key});

  @override
  State<FilteredMenuDemo> createState() => _FilteredMenuDemoState();
}

class _FilteredMenuDemoState extends State<FilteredMenuDemo> {
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
            child: FilteredMenu(
              entries: menuEntries,
              width: 500,
            ),
          ),
        ),
      ),
    );
  }
}
