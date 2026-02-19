import 'package:collect/collect.dart';
import 'package:example/constants/demos.dart';
import 'package:flutter/material.dart';

class FilteredMenuDemo extends StatefulWidget {
  const FilteredMenuDemo({super.key});

  @override
  State<FilteredMenuDemo> createState() => _FilteredMenuDemoState();
}

class _FilteredMenuDemoState extends State<FilteredMenuDemo> {
  List<MenuEntry> _filterCallback(List<MenuEntry> entries, String filter) {
    if (filter.isEmpty) return entries;

    setState(() {});
    return entries.where((entry) {
      return entry.label.toLowerCase().contains(filter.toLowerCase());
    }).toList();
  }

  int? _searchCallback(List<MenuEntry> entries, String query) {
    if (query.isEmpty) return null;

    final index = entries.indexWhere((entry) {
      return entry.label.toLowerCase().startsWith(query.toLowerCase());
    });
    setState(() {});

    return index != -1 ? index : null;
  }

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
              filterCallback: _filterCallback,
              searchCallback: _searchCallback,
            ),
          ),
        ),
      ),
    );
  }
}
