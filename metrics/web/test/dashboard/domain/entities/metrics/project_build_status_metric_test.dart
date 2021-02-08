// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/domain/entities/metrics/project_build_status_metric.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectBuildStatusMetric", () {
    test("successfully creates an instance with the given build status", () {
      const expectedStatus = BuildStatus.failed;

      const buildStatus = ProjectBuildStatusMetric(status: expectedStatus);

      expect(buildStatus.status, equals(expectedStatus));
    });

    test(
      "equals to another project build status metric with the same status",
      () {
        const status = BuildStatus.successful;
        const expectedStatusMetric = ProjectBuildStatusMetric(
          status: status,
        );

        const actualStatusMetric = ProjectBuildStatusMetric(
          status: status,
        );

        expect(actualStatusMetric, equals(expectedStatusMetric));
      },
    );
  });
}
