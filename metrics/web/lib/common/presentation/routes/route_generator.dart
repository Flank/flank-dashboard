import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_route.dart';
import 'package:metrics/common/presentation/pages/loading_page.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/debug_menu/presentation/pages/debug_menu_page.dart';
import 'package:metrics/project_groups/presentation/pages/project_group_page.dart';

/// Responsible for generating routes.
class RouteGenerator {
  /// Generates a route for the given route [settings]
  /// based on the [isLoggedIn] authentication status.
  ///
  /// Throws an [AssertionError] if [settings] is null.
  static MetricsPageRoute generateRoute({
    @required RouteSettings settings,
    bool isLoggedIn,
  }) {
    assert(settings != null);

    if (isLoggedIn == null) {
      return _createMetricsPageRoute(
        widget: LoadingPage(routeName: settings.name),
      );
    }

    if (!isLoggedIn) {
      return _createMetricsPageRoute(
        name: MetricsRoutes.login.path,
        widget: const LoginPage(),
      );
    }

    if (settings.name == MetricsRoutes.debugMenu.path) {
      return _createMetricsPageRoute(
        name: MetricsRoutes.debugMenu.path,
        widget: const DebugMenuPage(),
      );
    }

    if (settings.name == MetricsRoutes.dashboard.path) {
      return _createMetricsPageRoute(
        name: MetricsRoutes.dashboard.path,
        widget: DashboardPage(),
      );
    }

    if (settings.name == MetricsRoutes.projectGroups.path) {
      return _createMetricsPageRoute(
        name: MetricsRoutes.projectGroups.path,
        widget: ProjectGroupPage(),
      );
    }

    return _createMetricsPageRoute(
      name: MetricsRoutes.dashboard.path,
      widget: DashboardPage(),
    );
  }

  /// Creates [MetricsPageRoute] with the given [name] and the [widget].
  ///
  /// Throws an [AssertionError] if the [widget] is null.
  static MetricsPageRoute _createMetricsPageRoute({
    String name,
    @required Widget widget,
  }) {
    assert(widget != null);
    return MetricsPageRoute(
      builder: (_) => widget,
      settings: RouteSettings(name: name),
    );
  }
}
