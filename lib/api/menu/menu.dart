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

typedef FilterMatchFn<T> = bool Function(String item, String searchValue);
typedef MenuFilterCallback<T> =
    List<T> Function(List<T> entries, String filter);
typedef MenuSearchCallback<T> = int? Function(List<T> entries, String query);

enum MenuCloseBehavior { all, self, none }

bool defaultFilterMatch(String item, String searchValue) {
  return item.toLowerCase().contains(searchValue.toLowerCase());
}
