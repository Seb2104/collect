part of '../../menu.dart';

class MenuScope extends InheritedWidget {
  final MenuController controller;
  final ItemConfig itemConfig;
  final double itemHeight;

  MenuItem? get selected => controller.value.selectedItem;

  const MenuScope({
    super.key,
    required this.controller,
    required this.itemConfig,
    required this.itemHeight,
    required super.child,
  });

  static MenuScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MenuScope>();
    assert(scope != null, 'No MenuScope found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(MenuScope oldWidget) {
    return controller != oldWidget.controller ||
        itemConfig != oldWidget.itemConfig ||
        itemHeight != oldWidget.itemHeight;
  }
}
