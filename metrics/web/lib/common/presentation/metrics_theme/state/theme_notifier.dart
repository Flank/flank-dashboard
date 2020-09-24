import 'package:flutter/material.dart';

/// The [ChangeNotifier] of the theme type.
///
/// Stores and provides currently selected theme type.
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = true;

  /// Creates a new [ThemeNotifier] instance.
  ThemeNotifier({
    Brightness brightness,
  }) : _isDark = _isBrightnessDark(brightness);

  /// Determines if a dark theme is currently active.
  bool get isDark => _isDark;

  /// Changes the current theme mode to the opposite.
  void changeTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  /// Sets the theme mode value according to the given [brightness].
  void setTheme(Brightness brightness) {
    _isDark = _isBrightnessDark(brightness);
    notifyListeners();
  }

  /// Returns `true` if the given [brightness] is [Brightness.dark],
  /// otherwise, returns `false`.
  static bool _isBrightnessDark(Brightness brightness) {
    return brightness == Brightness.dark;
  }
}
