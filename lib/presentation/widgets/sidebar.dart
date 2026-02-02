part of '../../common.dart';

class Sidebar extends StatefulWidget {
  final List<SidebarGroup> groups;
  final SidebarPosition position;
  final double? contentWidth;
  final double minContentWidth;
  final double maxContentWidth;
  final bool isExpanded;
  final VoidCallback? onToggle;
  final int? selectedItemIndex;
  final Function(int)? onItemSelected;
  final Function(double)? onContentWidthChanged;

  const Sidebar({
    super.key,
    required this.groups,
    this.position = SidebarPosition.left,
    this.contentWidth = 300,
    this.minContentWidth = 200,
    this.maxContentWidth = 600,
    this.isExpanded = false,
    this.onToggle,
    this.selectedItemIndex,
    this.onItemSelected,
    this.onContentWidthChanged,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  late Map<int, AnimationController> _animationControllers;
  int? _selectedIndex;
  late double _currentContentWidth;
  bool _isResizing = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedItemIndex;
    _currentContentWidth = widget.contentWidth ?? 300;
    _animationControllers = {};

    int globalIndex = 0;
    for (var group in widget.groups) {
      for (var item in group.items) {
        if (item.animationBuilder != null) {
          _animationControllers[globalIndex] = AnimationController(
            duration: const Duration(milliseconds: 200),
            vsync: this,
          );
        }
        globalIndex++;
      }
    }
  }

  @override
  void didUpdateWidget(Sidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItemIndex != widget.selectedItemIndex) {
      setState(() {
        _selectedIndex = widget.selectedItemIndex;
      });
    }
    if (oldWidget.contentWidth != widget.contentWidth) {
      setState(() {
        _currentContentWidth = widget.contentWidth ?? 300;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTap(int globalIndex, SidebarItem item) {
    final controller = _animationControllers[globalIndex];
    if (controller != null) {
      controller.forward().then((_) {
        controller.reset();
      });
    }

    item.onTap?.call();

    if (item.content != null) {
      setState(() {
        if (_selectedIndex == globalIndex && widget.isExpanded) {
          widget.onToggle?.call();
        } else if (_selectedIndex != globalIndex) {
          _selectedIndex = globalIndex;
          widget.onItemSelected?.call(globalIndex);
          if (!widget.isExpanded) {
            widget.onToggle?.call();
          }
        } else if (!widget.isExpanded) {
          widget.onToggle?.call();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.position == SidebarPosition.left) {
      return Row(
        children: [
          _buildIconColumn(),
          _buildContentPanel(),
          if (widget.isExpanded) _buildResizeHandle(),
        ],
      );
    } else {
      return Row(
        children: [
          if (widget.isExpanded) _buildResizeHandle(),
          _buildContentPanel(),
          _buildIconColumn(),
        ],
      );
    }
  }

  Widget _buildIconColumn() {
    return Container(
      width: 50,
      decoration: BoxDecoration(color: AppTheme.surfaceElevated(context)),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ..._buildIconGroups(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildIconGroups() {
    final List<Widget> widgets = [];
    int globalIndex = 0;

    for (int groupIndex = 0; groupIndex < widget.groups.length; groupIndex++) {
      final group = widget.groups[groupIndex];

      if (group.expandBefore) {
        widgets.add(const Spacer());
      }

      final groupWidgets = <Widget>[];
      for (int i = 0; i < group.items.length; i++) {
        final item = group.items[i];
        final currentGlobalIndex = globalIndex;

        Widget iconButton = _buildIconButton(item, currentGlobalIndex);

        if (item.animationBuilder != null &&
            _animationControllers.containsKey(currentGlobalIndex)) {
          iconButton = AnimatedBuilder(
            animation: _animationControllers[currentGlobalIndex]!,
            builder: (context, child) {
              return item.animationBuilder!(
                context,
                _animationControllers[currentGlobalIndex]!,
                child!,
              );
            },
            child: iconButton,
          );
        }

        groupWidgets.add(iconButton);

        if (i < group.items.length - 1) {
          groupWidgets.add(const SizedBox(height: 8));
        }

        globalIndex++;
      }

      if (groupWidgets.isNotEmpty) {
        widgets.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(children: groupWidgets),
          ),
        );
      }

      if (group.showDividerAfter && groupIndex < widget.groups.length - 1) {
        widgets.add(const SizedBox(height: 16));
        widgets.add(Divider(height: 1));
        widgets.add(const SizedBox(height: 16));
      }
    }

    return widgets;
  }

  Widget _buildIconButton(SidebarItem item, int globalIndex) {
    Widget button = Stack(
      children: [
        ActionIcon(
          icon: item.icon,
          tooltip: item.tooltip,
          onTap: item.enabled ? () => _onItemTap(globalIndex, item) : null,
          enabled: item.enabled,
          isActive:
          _selectedIndex == globalIndex &&
              widget.isExpanded &&
              item.content != null,
        ),
        if (item.badge != null)
          Positioned(top: 4, right: 4, child: item.badge!),
      ],
    );

    return button;
  }

  Widget _buildContentPanel() {
    return AnimatedContainer(
      duration: _isResizing ? Duration.zero : const Duration(milliseconds: 200),
      width: widget.isExpanded ? _currentContentWidth : 0,
      decoration: BoxDecoration(color: AppTheme.surface(context)),
      child: widget.isExpanded
          ? FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 200)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildContent();
          }
          return const SizedBox.shrink();
        },
      )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildContent() {
    if (_selectedIndex == null) {
      return const SizedBox.shrink();
    }

    int globalIndex = 0;
    for (var group in widget.groups) {
      for (var item in group.items) {
        if (globalIndex == _selectedIndex) {
          return item.content ?? const SizedBox.shrink();
        }
        globalIndex++;
      }
    }

    return const SizedBox.shrink();
  }

  Widget _buildResizeHandle() {
    final isLeft = widget.position == SidebarPosition.left;

    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        onHorizontalDragStart: (_) {
          setState(() {
            _isResizing = true;
          });
        },
        onHorizontalDragUpdate: (details) {
          setState(() {
            double delta = isLeft ? details.delta.dx : -details.delta.dx;
            _currentContentWidth = (_currentContentWidth + delta).clamp(
              widget.minContentWidth,
              widget.maxContentWidth,
            );
          });
        },
        onHorizontalDragEnd: (_) {
          setState(() {
            _isResizing = false;
          });
          widget.onContentWidthChanged?.call(_currentContentWidth);
        },
        child: Container(width: 6, decoration: BoxDecoration()),
      ),
    );
  }
}

class SidebarItem {
  final IconData icon;
  final String tooltip;
  final Widget? content;
  final VoidCallback? onTap;
  final bool enabled;
  final Widget? badge;
  final List<LogicalKeyboardKey>? shortcutKeys;
  final AnimationBuilder? animationBuilder;

  const SidebarItem({
    required this.icon,
    required this.tooltip,
    this.content,
    this.onTap,
    this.enabled = true,
    this.badge,
    this.shortcutKeys,
    this.animationBuilder,
  });
}

typedef AnimationBuilder =
Widget Function(
    BuildContext context,
    Animation<double> animation,
    Widget child,
    );

class SidebarGroup {
  final List<SidebarItem> items;
  final bool showDividerAfter;
  final bool expandBefore;

  const SidebarGroup({
    required this.items,
    this.showDividerAfter = false,
    this.expandBefore = false,
  });
}

enum SidebarPosition { left, right }
