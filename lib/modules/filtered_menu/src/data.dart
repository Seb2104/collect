part of '../filtered_menu.dart';

enum MenuCloseBehavior { all, self, none }

typedef MenuEntryFilterCallback<T> =
    List<T> Function(List<T> entries, String filter);
typedef MenuEntrySearchCallback<T> =
    int? Function(List<T> entries, String query);
