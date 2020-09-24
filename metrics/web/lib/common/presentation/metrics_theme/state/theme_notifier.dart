import 'package:flutter/foundation.dart';

/// The [ChangeNotifier] of the theme type.
///
/// Stores and provides currently selected theme type.
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = true;

  /// Creates a new [ThemeNotifier] instance.
  ///
  /// If the given [isDark] is `null`, the `true` is used.
  ThemeNotifier({
    bool isDark,
  }) : _isDark = isDark ?? true;

  /// Determines if a dark theme is currently active.
  bool get isDark => _isDark;

  /// Enable and disable a dark theme of the application.
  void changeTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  /// Sets the [_isDark] value according to the given [isDark] value.
  ///
  /// If the given [isDark] is `null`, the `true` is used.
  void setTheme({bool isDark}) {
    _isDark = isDark ?? true;
    notifyListeners();
  }
}
