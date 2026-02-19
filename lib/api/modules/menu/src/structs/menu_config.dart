part of '../../menu.dart';

class MenuConfig {
  final EdgeInsetsGeometry padding;
  final Colour backgroundColour;
  final BorderRadius borderRadius;
  final Border border;
  final bool searchable;
  final bool enableFilter;
  final bool enableSearch;
  final MenuFilterCallback? filterCallback;
  final MenuSearchCallback? searchCallback;

  const MenuConfig({
    this.padding = const EdgeInsetsGeometry.all(0),
    this.backgroundColour = Colours.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
    this.border = const Border(),
    this.searchable = false,
    this.enableFilter = true,
    this.enableSearch = true,
    this.filterCallback,
    this.searchCallback,
  });
}
