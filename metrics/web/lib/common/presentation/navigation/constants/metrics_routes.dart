// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';

/// A class that holds the [RouteConfiguration]s for Metrics application routes.
class MetricsRoutes {
  /// A [RouteConfiguration] for the loading page.
  static const RouteConfiguration loading = RouteConfiguration(
    name: RouteName.loading,
    path: Navigator.defaultRouteName,
    authorizationRequired: false,
  );

  /// A [RouteConfiguration] for the login page.
  static final RouteConfiguration login = RouteConfiguration(
    name: RouteName.login,
    path: '/${RouteName.login}',
    authorizationRequired: false,
  );

  /// A [RouteConfiguration] for the dashboard page.
  static final RouteConfiguration dashboard = RouteConfiguration(
    name: RouteName.dashboard,
    path: '/${RouteName.dashboard}',
    authorizationRequired: true,
  );

  /// A [RouteConfiguration] for the project groups page.
  static final RouteConfiguration projectGroups = RouteConfiguration(
    name: RouteName.projectGroups,
    path: '/${RouteName.projectGroups}',
    authorizationRequired: true,
  );

  /// A [RouteConfiguration] for the debug menu page.
  static final RouteConfiguration debugMenu = RouteConfiguration(
    name: RouteName.debugMenu,
    path: '/${RouteName.debugMenu}',
    authorizationRequired: true,
  );

  /// A [Set] that contains all available [RouteConfiguration]s.
  static final Set<RouteConfiguration> values = {
    loading,
    login,
    dashboard,
    projectGroups,
    debugMenu,
  };
}
