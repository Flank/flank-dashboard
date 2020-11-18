import 'package:flutter/widgets.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// A [RouteObserver] that helps to send an event to [FirebaseAnalytics]
/// as a [Route] changes.
class FirebaseAnalyticsObserver extends RouteObserver<PageRoute<dynamic>> {
  /// A [FirebaseAnalytics] needed to get the Firebase Analytics API.
  final FirebaseAnalytics analytics;

  /// Creates a new instance of the [FirebaseAnalyticsObserver]
  /// with the given [analytics].
  FirebaseAnalyticsObserver({
    @required this.analytics,
  }) : assert(analytics != null);

  /// Sends a custom page view event.
  ///
  /// Does nothing if the [route] is not [PageRoute].
  void _sendPageEvent(Route<dynamic> route) {
    if (route is! PageRoute) return;

    final String screenName = route.settings.name;

    if (screenName != null && screenName != '/') {
      analytics.logEvent(name: '${screenName.substring(1)}_page_view');
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    _sendPageEvent(route);
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _sendPageEvent(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    _sendPageEvent(previousRoute);
  }
}
