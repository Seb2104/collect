part of '../collect.dart';


/// A top level function that represents the default [transitionBuilder] value.
Widget _defaultTransitionBuilder(Widget child, Animation<double> animation) =>
    ScaleTransition(
      scale: animation,
      child: child,
    );

/// The main class that is used to animate between two icons.
class IconToggle extends StatefulWidget {
  IconToggle({
    this.unselectedIconData = Icons.radio_button_unchecked,
    this.selectedIconData = Icons.radio_button_checked,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.value = false,
    this.onChanged,
    this.transitionBuilder = _defaultTransitionBuilder,
    this.duration = const Duration(milliseconds: 100),
    this.reverseDuration = const Duration(milliseconds: 100),
  });

  /// The selected iconData.
  final IconData selectedIconData;

  /// The unselected iconData.
  final IconData unselectedIconData;

  /// Color of the selected iconData.
  final Color activeColor;

  /// Color of the unselected iconData.
  final Color inactiveColor;

  /// A boolean value that represents if the icon is selected of not.
  final bool value;

  /// A function to be executed when [value] changes.
  final ValueChanged<bool>? onChanged;

  /// A [TransitionBuilder] that is used to animate between the icons.
  final AnimatedSwitcherTransitionBuilder transitionBuilder;

  /// The duration of the forward animation.
  final Duration duration;

  /// The duration of the reverse animation.
  final Duration reverseDuration;

  @override
  _IconToggleState createState() => _IconToggleState();
}

/// The subclass that is used to animate between two icons.
/// It inherits the [IconToggle] class state.
class _IconToggleState extends State<IconToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _position;
  bool _cancel = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
      reverseDuration: Duration(milliseconds: 100),
    );

    _position = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _position.addStatusListener((status) {
      if (status == AnimationStatus.dismissed &&
          widget.onChanged != null &&
          _cancel == false) {
        widget.onChanged!(!widget.value);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: _buildPadding(),
    );
  }

  Padding _buildPadding() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: _IconToggleable<double>(
        listenable: _position,
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        child: _buildAnimatedSwitcher(),
      ),
    );
  }

  AnimatedSwitcher _buildAnimatedSwitcher() {
    return AnimatedSwitcher(
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      transitionBuilder: widget.transitionBuilder,
      child: _buildIcon(),
    );
  }

  Icon _buildIcon() {
    return Icon(
      widget.value ? widget.selectedIconData : widget.unselectedIconData,
      color: widget.value ? widget.activeColor : widget.inactiveColor,
      size: 22,
      key: ValueKey<bool>(widget.value),
    );
  }

  void _onTapDown(event) {
    _cancel = false;
    _controller.forward();
  }

  void _onTapUp(event) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _cancel = true;
    _controller.reverse();
  }
}

/// A widget that represents the animated icon.
class _IconToggleable<T> extends AnimatedWidget {
  _IconToggleable({
    required Animation<double> listenable,
    required this.activeColor,
    required this.inactiveColor,
    required this.child,
  })  : _listenable = listenable,
        super(listenable: listenable);

  final Color activeColor;
  final Color inactiveColor;
  final Widget child;
  final Animation<double> _listenable;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _IconPainter(
        position: _listenable,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ),
      child: child,
    );
  }
}

/// A [CustomPainter] that is related to this package
class _IconPainter extends CustomPainter {
  _IconPainter({
    required this.position,
    required this.activeColor,
    required this.inactiveColor,
  });

  final Animation<double>? position;
  final Color activeColor;
  final Color inactiveColor;

  double get _value => position != null ? position!.value : 0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color.lerp(inactiveColor, activeColor, _value)!.withOpacity(
        math.min(_value, 0.15),
      )
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      20 * _value,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
