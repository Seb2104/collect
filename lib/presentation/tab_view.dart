part of '../../collect.dart';

class TabView extends StatefulWidget {
  /// A Map\<String: Widget>, mapping each tab's name to its content
  // final Map<String, Widget> content;

  /// Which side the tabs are aligned to
  final Side tabPosition;

  /// How much horizontal space to give the tabs
  ///
  /// # ONLY WORKS IF
  /// [tabPosition] is set to [Side.left] or [Side.right]
  final double tabsWidth;

  /// How long the animation will play for
  ///
  /// Set to [Duration.zero] to remove the animation in its entirety
  final Duration animationDuration;

  /// Whether or not to show the indicator for the selected tab
  final bool indicator;

  /// Which tab is selected when first drawn
  final int initialIndex;

  /// The amount of padding the tabs get in the direction of their arrangement
  final EdgeInsets? tabPadding;

  /// Puts this widget before the tabs
  final Widget? leading;

  /// Puts this widget after the tabs
  final Widget? trailing;

  final List<TabItem> children;

  const TabView({
    super.key,
    // this.content = demoContent,
    this.tabPosition = Side.top,
    this.tabsWidth = 200,
    this.animationDuration = kTabScrollDuration,
    this.indicator = true,
    this.initialIndex = 0,
    this.tabPadding,
    this.leading,
    this.trailing,
    required this.children,
  });

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    controller = TabController(
      length: widget.children.length,
      vsync: this,
      animationDuration: widget.animationDuration,
      initialIndex: widget.initialIndex.clamp(0, widget.children.length - 1),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.tabPosition) {
      case Side.bottom || Side.top:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.tabPosition == Side.top) _buildHorizontalTabs(),
            _buildPages(),
            if (widget.tabPosition == Side.bottom) _buildHorizontalTabs(),
          ],
        );
      case Side.left || Side.right:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.tabPosition == Side.left) _buildVerticalTabs(),
            _buildPages(),
            if (widget.tabPosition == Side.right) _buildVerticalTabs(),
          ],
        );
    }
  }

  Widget _buildPages() {
    return Expanded(
      child: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: widget.content.values.toList(),
      ),
    );
  }

  Widget _buildHorizontalTabs() {
    return SingleChildScrollView(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Row(
            children: [
              if (widget.leading != null) ...[
                const SizedBox(width: 10),
                widget.leading!,
                const SizedBox(width: 10),
              ],

              ...List.generate(widget.children.length, (index) {
                return InkWell(
                  onTap: () => controller.animateTo(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: controller.index == index
                          ? AppTheme.primarySage.withValues(alpha: 0.08)
                          : Colors.transparent,

                      border: widget.indicator == true
                          ? widget.tabPosition == Side.top
                          ? Border(
                        bottom: BorderSide(
                          color: controller.index == index
                              ? AppTheme.primarySage
                              : Colors.transparent,
                          width: 3,
                        ),
                      )
                          : Border(
                        top: BorderSide(
                          color: controller.index == index
                              ? AppTheme.primarySage
                              : Colors.transparent,
                          width: 3,
                        ),
                      )
                          : null,
                    ),
                    padding:
                    widget.tabPadding ??
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Word(
                      widget.content.keys.toList()[index],
                      fontWeight: controller.index == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }),

              if (widget.trailing != null) ...[
                const SizedBox(width: 10),
                widget.trailing!,
                const SizedBox(width: 10),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildVerticalTabs() {
    return SizedBox(
      width: widget.tabsWidth,
      child: SingleChildScrollView(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.leading != null) ...[
                  const SizedBox(height: 10),
                  widget.leading!,
                  const SizedBox(height: 10),
                ],
                ...List.generate(widget.children.length, (index) {
                  return InkWell(
                    onTap: () => controller.animateTo(index),
                    child: Container(
                      width: double.infinity,
                      padding:
                      widget.tabPadding ??
                          const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: controller.index == index
                            ? AppTheme.primarySage.withValues(alpha: 0.08)
                            : Colors.transparent,
                        border: widget.indicator
                            ? widget.tabPosition == Side.right
                            ? Border(
                          left: BorderSide(
                            color: controller.index == index
                                ? AppTheme.primarySage
                                : Colors.transparent,
                            width: 3,
                          ),
                        )
                            : Border(
                          right: BorderSide(
                            color: controller.index == index
                                ? AppTheme.primarySage
                                : Colors.transparent,
                            width: 3,
                          ),
                        )
                            : null,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Word(widget.content.keys.toList()[index]),
                      ),
                    ),
                  );
                }),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 10),
                  widget.trailing!,
                  const SizedBox(width: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class TabItem {
  final Widget title;
  final Widget view;

  const TabItem({required this.title, required this.view});
}

enum Side { top, left, bottom, right }

/// Absolute barebone basic map of five tabs for testing
const Map<String, Widget> demoContent = {
  'First': First(),
  'Second': Second(),
  'Third': Third(),
  'Fourth': Fourth(),
  'Fifth': Fifth(),
};

class First extends StatelessWidget {
  const First({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('First'));
  }
}

class Second extends StatelessWidget {
  const Second({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Second'));
  }
}

class Third extends StatelessWidget {
  const Third({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Third'));
  }
}

class Fourth extends StatelessWidget {
  const Fourth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Fourth'));
  }
}

class Fifth extends StatelessWidget {
  const Fifth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Fifth'));
  }
}
