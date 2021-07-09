// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/models/page_parameters_model.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:metrics/dashboard/presentation/models/dashboard_page_parameters_model.dart';

/// A factory that is responsible for creating the [PageParametersModel]
/// depending on the [RouteConfiguration].
class PageParametersFactory {
  /// Creates a new instance of the [PageParametersModel] for
  /// the [RouteConfiguration].
  ///
  /// If the given [RouteConfiguration] is `null` or contains the route name that
  /// does not match any [RouteName] returns `null`.
  /// If the [RouteConfiguration]'s parameters [Map] is `null` returns `null`.
  PageParametersModel create(RouteConfiguration configuration) {
    if (configuration == null) return null;

    final routeName = configuration.name;
    final parametersMap = configuration.parameters;

    switch (routeName) {
      case RouteName.dashboard:
        return DashboardPageParametersModel.fromMap(parametersMap);
      default:
        return null;
    }
  }
}
