// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("Build", () {
    test("two instances with the equal fields are equal", () {
      const buildNumber = 1;
      final DateTime startedAt = DateTime.utc(2020, 4, 13);
      const buildStatus = BuildStatus.successful;
      const duration = Duration(seconds: 1);
      const workflowName = 'workflowName';

      final firstBuild = Build(
        buildNumber: buildNumber,
        startedAt: startedAt,
        buildStatus: buildStatus,
        duration: duration,
        workflowName: workflowName,
      );

      final secondBuild = Build(
        buildNumber: buildNumber,
        startedAt: startedAt,
        buildStatus: buildStatus,
        duration: duration,
        workflowName: workflowName,
      );

      expect(firstBuild, equals(secondBuild));
    });
  });
}
