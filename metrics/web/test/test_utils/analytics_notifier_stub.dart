// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:metrics/analytics/presentation/state/analytics_notifier.dart';

/// Stub implementation of the [AnalyticsNotifier].
///
/// Provides test implementation of the [AnalyticsNotifier] methods.
class AnalyticsNotifierStub extends ChangeNotifier
    implements AnalyticsNotifier {
  @override
  Future<void> logLogin(String userId) async {}

  @override
  Future<void> logPageView(String name) async {}

  @override
  Future<void> resetUser() async {}
}
