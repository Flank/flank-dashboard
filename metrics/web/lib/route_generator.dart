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
          return navigateTo('/dashboard');
        }

        return navigateTo('/login');
      case '/login':
      default:
        if (user != null) {
          return navigateTo('/dashboard');
        }

        return navigateTo('/login');
    }
  }

  static Route navigateTo(String name) {
    switch (name) {
      case '/dashboard':
        return MaterialPageRoute(
            builder: (context) => DashboardPage(),
            settings: const RouteSettings(name: '/dashboard'));
      case '/login':
      default:
        return MaterialPageRoute(
            builder: (context) => LoginPage(),
            settings: const RouteSettings(name: '/login'));
    }
  }
}
