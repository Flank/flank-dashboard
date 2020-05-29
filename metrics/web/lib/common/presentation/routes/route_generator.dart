import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/pages/loading_page.dart';
import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/project_groups/presentation/pages/project_group_page.dart';

/// Responsible for generating routes.
class RouteGenerator {
  /// The Route name of the dashboard page.
  static const String dashboard = '/dashboard';

  /// The route name of the login page.
  static const String login = '/login';

  /// The route name of the project groups page.
  static const String projectGroupPage = '/projectGroups';

  /// Generates a route for the given route [settings]
  /// based on the [isLoggedIn] authentication status.
  ///
  /// Throws an [AssertionError] if [settings] is null.
  static MaterialPageRoute generateRoute({
    @required RouteSettings settings,
    bool isLoggedIn,
  }) {
    assert(settings != null);

    if (isLoggedIn == null) {
      return _createMaterialPageRoute(widget: LoadingPage());
    }

    if (!isLoggedIn) {
      return _createMaterialPageRoute(name: login, widget: LoginPage());
    }

    if (settings.name == dashboard) {
      return _createMaterialPageRoute(name: dashboard, widget: DashboardPage());
    }

    if (settings.name == projectGroupPage) {
      return _createMaterialPageRoute(
          name: projectGroupPage, widget: ProjectGroupPage());
    }

    return _createMaterialPageRoute(name: dashboard, widget: DashboardPage());
  }

  /// Creates [MaterialPageRoute] with the given [name] and the [widget].
  ///
  /// Throws an [AssertionError] if the [widget] is null.
  static MaterialPageRoute _createMaterialPageRoute(
      {String name, @required Widget widget}) {
    assert(widget != null);
    return MaterialPageRoute(
        builder: (context) => widget, settings: RouteSettings(name: name));
  }
}
