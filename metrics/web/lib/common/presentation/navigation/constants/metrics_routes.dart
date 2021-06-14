// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';

/// A class that holds the [RouteConfiguration]s for Metrics application routes.
class MetricsRoutes {
  /// A [RouteConfiguration] for the loading page.
  static const RouteConfiguration loading = RouteConfiguration.loading();

  /// A [RouteConfiguration] for the login page.
  static final RouteConfiguration login = RouteConfiguration.login();

  /// A [RouteConfiguration] for the dashboard page.
  static final RouteConfiguration dashboard = RouteConfiguration.dashboard();

  /// A [RouteConfiguration] for the project groups page.
  static final RouteConfiguration projectGroups =
      RouteConfiguration.projectGroups();

  /// A [RouteConfiguration] for the debug menu page.
  static final RouteConfiguration debugMenu = RouteConfiguration.debugMenu();

  /// A [Set] that contains all available [RouteConfiguration]s.
  static final Set<RouteConfiguration> values = {
    loading,
    login,
    dashboard,
    projectGroups,
    debugMenu,
  };
}
