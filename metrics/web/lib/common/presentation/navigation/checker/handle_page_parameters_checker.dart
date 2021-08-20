// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';

/// A class that shows if page parameters can be handled by dashboard.
class HandlePageParametersChecker {
  /// Checks whether the page parameters can be handled.
  bool canHandle({
    @required RouteConfiguration configuration,
  }) {
    ArgumentError.checkNotNull(configuration, 'configuration');

    final routeName = configuration.name;

    if (routeName == RouteName.dashboard) {
      return true;
    }

    return false;
  }
}
