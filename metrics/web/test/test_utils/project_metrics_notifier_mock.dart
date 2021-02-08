// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:mockito/mockito.dart';

class ProjectMetricsNotifierMock extends Mock
    with ChangeNotifier
    implements ProjectMetricsNotifier {}
