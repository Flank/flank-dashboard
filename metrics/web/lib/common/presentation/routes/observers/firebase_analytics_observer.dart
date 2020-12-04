import 'package:flutter/widgets.dart';
import 'package:metrics/analytics/presentation/state/analytics_notifier.dart';

/// A [RouteObserver] that logs page changes using [AnalyticsNotifier] when
/// the currently active [PageRoute] changes.
class FirebaseAnalyticsObserver extends RouteObserver<PageRoute<dynamic>>  {
  /// An [AnalyticsNotifier] needed to able to log page changes.
  AnalyticsNotifier analyticsNotifier;

  /// Creates a new instance of the [FirebaseAnalyticsObserver].
  ///
  /// The [analyticsNotifier] must not be `null`.
  FirebaseAnalyticsObserver({@required this.analyticsNotifier})
      : assert(analyticsNotifier != null);

  /// Extracts the page name from the given [route] and
  /// logs it using [analyticsNotifier].
  void _logPageView(PageRoute<dynamic> route) {
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
