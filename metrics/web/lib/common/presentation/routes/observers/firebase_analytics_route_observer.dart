// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:metrics/analytics/presentation/state/analytics_notifier.dart';

/// A [RouteObserver] that logs page changes using [AnalyticsNotifier] when
/// the currently active [PageRoute] changes.
class FirebaseAnalyticsRouteObserver extends RouteObserver<PageRoute> {
  /// An [AnalyticsNotifier] that is used to log page changes.
  AnalyticsNotifier analyticsNotifier;

  /// Creates a new instance of the [FirebaseAnalyticsRouteObserver].
  ///
  /// The [analyticsNotifier] must not be `null`.
  FirebaseAnalyticsRouteObserver({
    @required this.analyticsNotifier,
  }) : assert(analyticsNotifier != null);

  /// Logs the page name extracted from the [Route.settings]
  /// of the given [route].
  void _logPageView(PageRoute route) {
    final routeName = route?.settings?.name;

    analyticsNotifier.logPageView(routeName);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route is PageRoute) {
      _logPageView(route);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    if (newRoute is PageRoute) {
      _logPageView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (previousRoute is PageRoute) {
      _logPageView(previousRoute);
    }
  }
}
