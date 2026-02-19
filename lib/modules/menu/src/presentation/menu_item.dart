part of '../../menu.dart';

class MenuItem {
  final String label;
  final String value;

  const MenuItem({required this.label, required this.value});

  Widget build(BuildContext context) {
    final scope = MenuScope.of(context);
    final config = scope.itemConfig;
    final height = scope.itemHeight;

    return InkWell(
      onTap: () {
        scope.controller.selectItem(this);
      },
      child: Container(
        height: height,
        padding: config.padding,
        alignment: switch (config.alignment) {
          Aligned.left => Alignment.centerLeft,
          Aligned.center => Alignment.center,
          Aligned.right => Alignment.centerRight,
        },
        child: Word(label, color: Colours.grey),
      ),
    );
  }
}
