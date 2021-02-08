// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

class BuildsTestData {
  static final BuildData firstBuild = BuildData(
    id: 'first',
    buildNumber: 1,
    startedAt: DateTime(2020),
    buildStatus: BuildStatus.successful,
    duration: const Duration(minutes: 10),
    workflowName: 'build',
    coverage: Percent(0.7),
  );

  static final BuildData secondBuild = BuildData(
    id: 'second',
    buildNumber: 2,
    startedAt: DateTime(2020),
    buildStatus: BuildStatus.successful,
    duration: const Duration(minutes: 9),
    workflowName: 'build',
    coverage: Percent(0.75),
  );

  static final List<BuildData> builds = [firstBuild, secondBuild];
}
