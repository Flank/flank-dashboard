// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/constants/default_routes.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';

/// A factory that is responsible for creating the [RouteConfiguration]
/// depending on the [Uri].
class RouteConfigurationFactory {
  /// Creates a new instance of the [RouteConfigurationFactory].
  const RouteConfigurationFactory();

  /// Creates a [RouteConfiguration] from the given [uri].
  ///
  /// If the given [Uri] is null or does not contain any path segments,
  /// returns [DefaultRoutes.loading].
  /// If the given [Uri] contains the route name that does not match any of
  /// [RouteName]s, returns [DefaultRoutes.dashboard].
  RouteConfiguration create(Uri uri) {
    final pathSegments = uri?.pathSegments;

    if (pathSegments == null || pathSegments.isEmpty) {
      return const RouteConfiguration.loading();
    }

    final routeName = pathSegments.first;

    final parameters = uri?.queryParameters;
    final hasParameters = parameters != null && parameters.isNotEmpty;
    final queryParameters = hasParameters ? parameters : null;

    if (routeName == RouteName.login.value) {
      return RouteConfiguration.login(parameters: queryParameters);
    } else if (routeName == RouteName.dashboard.value) {
      return RouteConfiguration.dashboard(parameters: queryParameters);
    } else if (routeName == RouteName.projectGroups.value) {
      return RouteConfiguration.projectGroups(parameters: queryParameters);
    } else if (routeName == RouteName.debugMenu.value) {
      return RouteConfiguration.debugMenu(parameters: queryParameters);
    }

    return DefaultRoutes.dashboard;
  }
}
