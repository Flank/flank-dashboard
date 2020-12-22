import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';

/// A class that holds the [RouteConfiguration]s for Metrics application routes.
class MetricsRoutes {
  /// A [RouteConfiguration] for the loading page.
  static const RouteConfiguration loading = RouteConfiguration(
    name: RouteName.loading,
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
}
