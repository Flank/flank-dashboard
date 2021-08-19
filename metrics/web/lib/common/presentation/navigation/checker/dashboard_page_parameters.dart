// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:metrics/common/presentation/state/page_notifier.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';

/// A class that shows if page parameters can be handled by dashboard
class DashboardPageParameters {
  /// Checks whether the page parameters can be handled
  bool canHandle({
    @required RouteConfiguration configuration,
    @required PageNotifier pageNotifier,
  }) {
    ArgumentError.checkNotNull(configuration, 'configuration');
    ArgumentError.checkNotNull(pageNotifier, 'pageNotifier');

    return _canHandlePageParameters(configuration, pageNotifier);
  }

  bool _canHandlePageParameters(
      RouteConfiguration configuration, PageNotifier pageNotifier) {
    final routeName = configuration.name;

    if (routeName == RouteName.dashboard &&
        pageNotifier is ProjectMetricsNotifier) {
      return true;
    } else {
      return false;
    }
  }
}
