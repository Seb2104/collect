part of '../../collect.dart';

class RoundedCheckBox extends StatefulWidget {
  const RoundedCheckBox({
    super.key,
    this.isChecked,
    this.checkedWidget,
    this.uncheckedWidget,
    this.checkedColor,
    this.uncheckedColor,
    this.disabledColor,
    this.border,
    this.borderColor,
    this.size,
    this.animationDuration,
    this.onTap,
    this.text = '',
    this.textStyle,
  });

  final bool? isChecked;

  final Widget? checkedWidget;

  final Widget? uncheckedWidget;

  final Color? checkedColor;

  final Color? uncheckedColor;

  final Color? disabledColor;

  final Border? border;

  final Color? borderColor;

  final double? size;

  final String text;
  final TextStyle? textStyle;

  final Function(bool?)? onTap;

  final Duration? animationDuration;

  @override
  _RoundedCheckBoxState createState() => _RoundedCheckBoxState();
}

class _RoundedCheckBoxState extends State<RoundedCheckBox> {
  bool? isChecked;
  late Duration animationDuration;
  double? size;
  Widget? checkedWidget;
  Widget? uncheckedWidget;
  Color? checkedColor;
  Color? uncheckedColor;
  Color? disabledColor;
  late Color borderColor;

  @override
  void initState() {
    isChecked = widget.isChecked ?? false;
    animationDuration = widget.animationDuration ?? Duration(milliseconds: 500);
    size = widget.size ?? 24.0;
    checkedColor = widget.checkedColor ?? Colors.green;
    uncheckedColor = widget.uncheckedColor;
    borderColor = widget.borderColor ?? Colors.grey;
    checkedWidget =
        widget.checkedWidget ??
        Icon(Icons.check, color: Colors.white, size: size! - 6);
    uncheckedWidget = widget.uncheckedWidget ?? const SizedBox.shrink();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap != null
          ? () {
              setState(() => isChecked = !isChecked!);
              widget.onTap?.call(isChecked);
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(size! / 2),
            child: AnimatedContainer(
              duration: animationDuration,
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: isChecked! ? checkedColor : uncheckedColor,
                border: widget.border ?? Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(size! / 2),
              ),
              child: isChecked! ? checkedWidget! : uncheckedWidget!,
            ),
          ),
          if (widget.text.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 8),
                Text(
                  widget.text,
                  style: widget.textStyle ?? AppTheme.baseTextStyle,
                ).flexible(),
              ],
            ).flexible(),
        ],
      ),
    );
  }
}
