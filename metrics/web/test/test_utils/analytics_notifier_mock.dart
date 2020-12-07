import 'package:flutter/foundation.dart';
import 'package:metrics/analytics/presentation/state/analytics_notifier.dart';
import 'package:mockito/mockito.dart';

class AnalyticsNotifierMock extends Mock
    with ChangeNotifier
    implements AnalyticsNotifier {}
