import 'package:flutter/cupertino.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:mockito/mockito.dart';

class ProjectMetricsNotifierMock extends Mock
    with ChangeNotifier
    implements ProjectMetricsNotifier {}
