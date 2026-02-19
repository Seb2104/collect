part of '../menu.dart';

/// Callback for custom item filtering logic.
///
/// Receives the full [items] list and the current search [query], and should
/// return a new list containing only the items that match.
typedef MenuFilterCallback =
    List<MenuItem> Function(List<MenuItem> items, String query);

/// Callback for custom search-highlight logic.
///
/// Receives the current (possibly filtered) [items] and the [query], and
/// should return the index of the best match, or `null` if nothing matches.
typedef MenuSearchCallback = int? Function(List<MenuItem> items, String query);

/// Callback invoked when a menu item is selected.
///
/// Receives the selected [MenuItem] as a parameter.
typedef OnMenuItemSelected = void Function(MenuItem item);
