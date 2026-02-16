/// The menu library — houses all the menu-related widgets, types, and helpers.
///
/// This is the main entry point for the menu system. It pulls in all the
/// part files (base menu, config, controller, entries, textfield, theme)
/// so you only need to import this one file to get everything.
library menu;

import 'package:collect/collect.dart';
import 'package:flutter/material.dart' hide MenuTheme;
import 'package:flutter/services.dart';

part 'base_menu.dart';
part 'menu_config.dart';
part 'menu_control.dart';
part 'menu_entry.dart';
part 'menu_textfield.dart';
part 'menu_theme.dart';

/// A function that decides whether a single item matches the search text.
///
/// Gets called for each item in the list — return true if the item
/// should show up in the results, false if it should be hidden.
typedef FilterMatchFn<T> = bool Function(String item, String searchValue);

/// A function that filters a whole list of entries based on the user's input.
///
/// Takes the full list and the current filter text, and returns
/// whatever subset should be shown in the dropdown.
typedef MenuFilterCallback<T> =
    List<T> Function(List<T> entries, String filter);

/// A function that searches through entries and returns the index of the best match.
///
/// Returns null if nothing matches. The returned index is used to
/// highlight that item in the dropdown so the user can see where they are.
typedef MenuSearchCallback<T> = int? Function(List<T> entries, String query);

/// Controls what causes the dropdown to close.
///
/// - [all] — closes when you tap outside OR select an item (most common).
/// - [self] — only closes when you select an item, tapping outside does nothing.
/// - [none] — stays open no matter what. You'd have to close it manually.
enum MenuCloseBehavior { all, self, none }

/// The default filter matching logic — just a simple case-insensitive contains check.
///
/// If you don't provide your own [FilterMatchFn], this is what gets used.
/// It lowercases both strings and checks if the item contains the search value.
bool defaultFilterMatch(String item, String searchValue) {
  return item.toLowerCase().contains(searchValue.toLowerCase());
}
