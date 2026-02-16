part of 'menu.dart';

/// A controller that lets you programmatically control a [Menu] widget.
///
/// This is for when you need to open/close/toggle the dropdown from
/// outside the widget itself — like from a button somewhere else on the page,
/// or in response to some other event. It also tracks the currently
/// selected value and whether the dropdown is open.
///
/// It extends [ChangeNotifier] so you can listen for changes if you need to.
class MenuControl<T> extends ChangeNotifier {
  /// The currently selected value, or null if nothing's selected yet.
  T? _selectedValue;

  /// Whether the dropdown overlay is currently showing.
  bool _isOpen = false;

  /// Internal callback registered by the Menu widget to show itself.
  VoidCallback? _showCallback;

  /// Internal callback registered by the Menu widget to hide itself.
  VoidCallback? _hideCallback;

  /// Gets the currently selected value.
  T? get selectedValue => _selectedValue;

  /// Sets the selected value and notifies listeners if it actually changed.
  set selectedValue(T? value) {
    if (_selectedValue != value) {
      _selectedValue = value;
      notifyListeners();
    }
  }

  /// Whether the dropdown is currently open/visible.
  bool get isOpen => _isOpen;

  /// Updates the open state and notifies listeners.
  /// Called internally by the Menu widget — you probably don't need
  /// to call this yourself.
  void setOpen(bool value) {
    if (_isOpen != value) {
      _isOpen = value;
      notifyListeners();
    }
  }

  /// Called by the Menu widget to register its "show" function.
  /// This is what makes [show] work — without it, the controller
  /// wouldn't know how to actually open the dropdown.
  void registerShowCallback(VoidCallback callback) {
    _showCallback = callback;
  }

  /// Called by the Menu widget to register its "hide" function.
  /// Same idea as [registerShowCallback] but for closing.
  void registerHideCallback(VoidCallback callback) {
    _hideCallback = callback;
  }

  /// Opens the dropdown. Only works if the Menu widget has registered
  /// its show callback (which it does automatically in initState).
  void show() {
    _showCallback?.call();
  }

  /// Closes the dropdown. Same deal — needs the hide callback to be registered.
  void hide() {
    _hideCallback?.call();
  }

  /// Toggles the dropdown — opens it if closed, closes it if open.
  void toggle() {
    if (_isOpen) {
      hide();
    } else {
      show();
    }
  }

  /// Cleans up the callbacks so we don't hold onto stale references.
  @override
  void dispose() {
    _showCallback = null;
    _hideCallback = null;
    super.dispose();
  }
}
