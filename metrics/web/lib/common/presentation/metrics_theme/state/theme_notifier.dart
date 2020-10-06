import 'package:flutter/material.dart';
import 'package:metrics/auth/domain/entities/theme_type.dart';

/// The [ChangeNotifier] of the theme type.
///
/// Stores and provides currently selected theme type.
class ThemeNotifier extends ChangeNotifier {
  /// A currently selected [ThemeType].
  ThemeType _selectedTheme;

  /// Creates a new [ThemeNotifier] instance with the given [brightness].
  ThemeNotifier({
    Brightness brightness,
  }) : _selectedTheme =
            _isBrightnessDark(brightness) ? ThemeType.dark : ThemeType.light;

  /// Determines if a dark theme is currently active.
  bool get isDark => _selectedTheme == ThemeType.dark;

  /// Provides the selected [ThemeType].
  ThemeType get selectedTheme => _selectedTheme;

  /// Changes the selected theme to the given [themeType].
  void changeTheme(ThemeType themeType) {
    if (themeType == null) {
      return;
    }

    if (_selectedTheme != themeType) {
      _selectedTheme = themeType;

      notifyListeners();
    }
  }

  /// Changes the current theme mode to the opposite.
  void toggleTheme() {
    if (_selectedTheme == ThemeType.dark) {
      _selectedTheme = ThemeType.light;
    } else {
      _selectedTheme = ThemeType.dark;
    }

    notifyListeners();
  }

  /// Sets the theme mode value according to the given [brightness].
  void setTheme(Brightness brightness) {
    if (_isBrightnessDark(brightness)) {
      _selectedTheme = ThemeType.dark;
    } else {
      _selectedTheme = ThemeType.light;
    }

    notifyListeners();
  }

  /// Returns `true` if the given [brightness] is [Brightness.dark],
  /// otherwise, returns `false`.
  static bool _isBrightnessDark(Brightness brightness) {
    return brightness == Brightness.dark;
  }
}
