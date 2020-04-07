import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/pages/login_page.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';

/// Responsible for generating routes.
class RouteGenerator {
  static const String dashboard = '/dashboard';
  static const String login = '/login';

  /// Generates a route for the given route [settings] and a user authentication
  /// status, determined by a [isLoggedIn] value.
  static MaterialPageRoute generateRoute(
      {RouteSettings settings, bool isLoggedIn}) {

    if (!isLoggedIn) {
      return _createMaterialPageRoute(login, LoginPage());
    }

    return _createMaterialPageRoute(dashboard, DashboardPage());
  }

  /// Creates [MaterialPageRoute] with the given [name] and the [widget].
  static MaterialPageRoute _createMaterialPageRoute(String name, Widget widget) {
    return MaterialPageRoute(
        builder: (context) => widget, settings: RouteSettings(name: name));
  }
}
