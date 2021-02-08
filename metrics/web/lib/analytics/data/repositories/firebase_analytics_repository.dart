// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:metrics/analytics/domain/repositories/analytics_repository.dart';

/// A class that provides methods for interaction with the [FirebaseAnalytics].
class FirebaseAnalyticsRepository implements AnalyticsRepository {
  /// An instance of the [FirebaseAnalytics] that provides an ability
  /// to interact with the remote analytics service.
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  @override
  Future<void> logLogin() async {
    return _analytics.logLogin();
  }

  @override
  Future<void> logPageView(String pageName) {
    return _analytics.logEvent(name: pageName);
  }

  @override
  Future<void> setUserId(String id) {
    return _analytics.setUserId(id);
  }
}
