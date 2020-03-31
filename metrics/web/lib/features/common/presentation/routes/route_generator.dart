import 'package:flutter/material.dart';
import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/presentation/pages/login_page.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';

/// Generate a route for the given route settings.
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings, User user) {
    switch (settings.name) {
      case '/dashboard':
        if (user != null) {
          return _navigateTo('/dashboard', DashboardPage());
        }

        return _navigateTo('/login', LoginPage());
      case '/login':
      default:
        if (user != null) {
          return _navigateTo('/dashboard', DashboardPage());
        }

        return _navigateTo('/login', LoginPage());
    }
  }

  static MaterialPageRoute _navigateTo(String name, Widget widget) {
    return MaterialPageRoute(
        builder: (context) => widget, settings: RouteSettings(name: name));
  }
}
