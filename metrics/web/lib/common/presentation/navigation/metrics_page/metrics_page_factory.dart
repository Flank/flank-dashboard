// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:metrics/common/presentation/pages/loading_page.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/debug_menu/presentation/pages/debug_menu_page.dart';
import 'package:metrics/project_groups/presentation/pages/project_group_page.dart';

/// A factory that is responsible for creating the [MetricsPage]
/// depending on the [RouteConfiguration].
class MetricsPageFactory {
  /// Creates the [MetricsPage] from the given [RouteConfiguration].
  ///
  /// If the given [RouteConfiguration] is `null` or contains the route name that
  /// does not match to any of [RouteName]s returns the [DashboardPage].
  MetricsPage create(RouteConfiguration configuration) {
    final routeName = configuration?.name;
    final routePath = configuration?.path;

    switch (routeName) {
      case RouteName.loading:
        return MetricsPage(
          child: const LoadingPage(),
          name: routePath,
          arguments: configuration,
        );
      case RouteName.login:
        return MetricsPage(
          child: const LoginPage(),
          name: routePath,
          arguments: configuration,
        );
      case RouteName.dashboard:
        return MetricsPage(
          child: DashboardPage(),
          name: routePath,
          arguments: configuration,
        );
      case RouteName.projectGroups:
        return MetricsPage(
          child: ProjectGroupPage(),
          name: routePath,
          arguments: configuration,
        );
      case RouteName.debugMenu:
        return MetricsPage(
          child: const DebugMenuPage(),
          name: routePath,
          arguments: configuration,
        );
    }

    return MetricsPage(
      child: DashboardPage(),
      name: routePath,
      arguments: configuration,
    );
  }
}
