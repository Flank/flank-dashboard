// ignore_for_file: prefer_const_constructors
import 'package:metrics/dashboard/domain/entities/metrics/project_build_status_metrics.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectBuildStatusMetrics", () {
    test("successfuly creates an instance with the given build status", () {
      const expectedStatus = BuildStatus.failed;

      const buildStatus = ProjectBuildStatusMetrics(status: expectedStatus);

      expect(buildStatus.status, equals(expectedStatus));
    });

    test(
      "equals to another project build status metrics with the same status",
      () {
        const status = BuildStatus.successful;
        const expectedStatusMetrics = ProjectBuildStatusMetrics(
          status: status,
        );

        const actualStatusMetrics = ProjectBuildStatusMetrics(
          status: status,
        );

        expect(actualStatusMetrics, equals(expectedStatusMetrics));
      },
    );
  });
}
