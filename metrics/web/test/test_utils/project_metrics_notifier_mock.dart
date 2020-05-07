import 'package:flutter/cupertino.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:mockito/mockito.dart';

class ProjectMetricsNotifierMock extends Mock
    with ChangeNotifier
    implements ProjectMetricsNotifier {}
