import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/pages/login_page.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';

/// Responsible for generating routes.
class RouteGenerator {
  /// Generates a route for the given route [settings] and a user authentication
  /// status, determined by a [isLoggedIn] value.
  static MaterialPageRoute generateRoute(
      {RouteSettings settings, bool isLoggedIn}) {
    switch (settings.name) {
      case '/dashboard':
        if (isLoggedIn) {
          return _navigateTo('/dashboard', DashboardPage());
        }

        return _navigateTo('/login', LoginPage());
      case '/login':
      default:
        if (isLoggedIn) {
          return _navigateTo('/dashboard', DashboardPage());
        }

        return _navigateTo('/login', LoginPage());
    }
  }

  /// Build [MaterialPageRoute].
  ///
  /// Using a [name] and a [widget] to construct the [MaterialPageRoute].
  static MaterialPageRoute _navigateTo(String name, Widget widget) {
    return MaterialPageRoute(
        builder: (context) => widget, settings: RouteSettings(name: name));
  }
}
