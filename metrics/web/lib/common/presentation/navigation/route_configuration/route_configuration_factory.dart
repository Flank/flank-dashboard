import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';

/// A factory responsible for creating the [RouteConfiguration]
/// based on the [Uri].
class RouteConfigurationFactory {
  /// Creates a [RouteConfiguration] from the given [uri].
  RouteConfiguration create(Uri uri) {
    final pathSegments = uri.pathSegments;

    if (pathSegments.isEmpty) return MetricsRoutes.loading;

    final routeName = pathSegments.first;

    if (routeName == RouteName.login.value) {
      return MetricsRoutes.login;
    } else if (routeName == RouteName.loading.value) {
      return MetricsRoutes.loading;
    } else if (routeName == RouteName.dashboard.value) {
      return MetricsRoutes.dashboard;
    } else if (routeName == RouteName.projectGroups.value) {
      return MetricsRoutes.projectGroups;
    }

    return MetricsRoutes.dashboard;
  }
}
