import 'package:flutter/foundation.dart';

/// The [ChangeNotifier] of the theme type.
///
/// Stores and provides currently selected theme type.
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = true;

  /// Determines if a dark theme is currently active.
  bool get isDark => _isDark;

  /// Enable and disable a dark theme of the application.
  void changeTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
