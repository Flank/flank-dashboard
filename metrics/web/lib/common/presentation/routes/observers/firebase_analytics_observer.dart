import 'package:flutter/widgets.dart';
import 'package:metrics/analytics/presentation/state/analytics_notifier.dart';

/// A [NavigatorObserver] that logs page changes using [AnalyticsNotifier] when the
/// currently active [PageRoute] changes.
class FirebaseAnalyticsObserver extends RouteObserver<PageRoute<dynamic>> {
  /// An [AnalyticsNotifier] needed to able to log page changes.
  AnalyticsNotifier analyticsNotifier;

  /// Creates a new instance of the [FirebaseAnalyticsObserver].
  ///
  /// The [analyticsNotifier] must not be `null`.
  FirebaseAnalyticsObserver({@required this.analyticsNotifier})
      : assert(analyticsNotifier != null);

  /// Extracts the page name from the [PageRoute] and
  /// logs it using [AnalyticsNotifier].
  ///
  /// ToDo
  void _logPageView(PageRoute<dynamic> newRoute, PageRoute<dynamic> oldRoute) {
    final newRouteName = newRoute?.settings?.name;
    final oldRouteName = oldRoute?.settings?.name;

    // if (newRouteName == null || newRouteName == oldRouteName) return;

    // analyticsNotifier.logPageView(newRouteName);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route is PageRoute && previousRoute is PageRoute) {
      _logPageView(route, previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    if (newRoute is PageRoute && oldRoute is PageRoute) {
      _logPageView(newRoute, oldRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (previousRoute is PageRoute && route is PageRoute) {
      _logPageView(previousRoute, route);
    }
  }
}
