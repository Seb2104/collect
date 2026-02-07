part of '../../collect.dart';

class ActionIcon extends StatefulWidget {
  const ActionIcon({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.enabled = true,
    this.isActive = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isActive;

  @override
  State<ActionIcon> createState() => _ActionIconState();
}

class _ActionIconState extends State<ActionIcon> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Tooltip(
          message: widget.tooltip,
          preferBelow: false,
          waitDuration: const Duration(milliseconds: 800),
          decoration: BoxDecoration(
            color: AppTheme.textPrimary(context),
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            color: AppTheme.background(context),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.enabled ? widget.onTap : null,
              borderRadius: BorderRadius.circular(10),
              hoverColor: AppTheme.hover(context),
              splashColor: AppTheme.primarySage.withValues(alpha: 0.1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: widget.isActive
                      ? AppTheme.primarySage.withValues(alpha: 0.15)
                      : Colors.transparent,
                  border: widget.isActive
                      ? Border.all(
                          color: AppTheme.primarySage.withValues(alpha: 0.3),
                          width: 1.5,
                        )
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  size: 17,
                  color: widget.enabled
                      ? (widget.isActive
                            ? AppTheme.primarySage
                            : AppTheme.textPrimary(
                                context,
                              ).withValues(alpha: 0.75))
                      : AppTheme.textSecondary(context).withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
