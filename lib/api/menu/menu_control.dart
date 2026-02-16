part of 'menu.dart';


class MenuControl<T> extends ChangeNotifier {
  T? _selectedValue;
  bool _isOpen = false;
  VoidCallback? _showCallback;
  VoidCallback? _hideCallback;

  T? get selectedValue => _selectedValue;

  set selectedValue(T? value) {
    if (_selectedValue != value) {
      _selectedValue = value;
      notifyListeners();
    }
  }

  bool get isOpen => _isOpen;

  void setOpen(bool value) {
    if (_isOpen != value) {
      _isOpen = value;
      notifyListeners();
    }
  }

  void registerShowCallback(VoidCallback callback) {
    _showCallback = callback;
  }

  void registerHideCallback(VoidCallback callback) {
    _hideCallback = callback;
  }

  void show() {
    _showCallback?.call();
  }

  void hide() {
    _hideCallback?.call();
  }

  void toggle() {
    if (_isOpen) {
      hide();
    } else {
      show();
    }
  }

  @override
  void dispose() {
    _showCallback = null;
    _hideCallback = null;
    super.dispose();
  }
}
