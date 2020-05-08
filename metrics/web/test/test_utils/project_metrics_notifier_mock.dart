import 'package:flutter/foundation.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:mockito/mockito.dart';

/// Mock implementation of the [ProjectMetricsNotifier].
class ProjectMetricsNotifierMock extends Mock
    with ChangeNotifier
    implements ProjectMetricsNotifier {}
