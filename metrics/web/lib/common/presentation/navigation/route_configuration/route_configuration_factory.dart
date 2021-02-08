// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';

/// A factory that is responsible for creating the [RouteConfiguration]
/// depending on the [Uri].
class RouteConfigurationFactory {
  /// Creates a [RouteConfiguration] from the given [uri].
  ///
  /// If the given [Uri] is null or does not contain any path segments,
  /// returns [MetricsRoutes.loading].
  /// If the given [Uri] contains the route name that does not match any of
  /// [RouteName]s, returns [MetricsRoutes.dashboard].
  RouteConfiguration create(Uri uri) {
    final pathSegments = uri?.pathSegments;

    if (pathSegments == null || pathSegments.isEmpty) {
      return MetricsRoutes.loading;
    }

    final routeName = pathSegments.first;

    if (routeName == RouteName.login.value) {
      return MetricsRoutes.login;
    } else if (routeName == RouteName.dashboard.value) {
      return MetricsRoutes.dashboard;
    } else if (routeName == RouteName.projectGroups.value) {
      return MetricsRoutes.projectGroups;
    } else if (routeName == RouteName.debugMenu.value) {
      return MetricsRoutes.debugMenu;
    }

    return MetricsRoutes.dashboard;
  }
}
