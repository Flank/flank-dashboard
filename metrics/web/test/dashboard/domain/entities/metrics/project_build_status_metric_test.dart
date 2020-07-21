import 'package:metrics/dashboard/domain/entities/metrics/project_build_status_metric.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectBuildStatusMetric", () {
    test("equals to another ProjectBuildStatusMetric with the same status", () {
      const status = BuildStatus.successful;
      const expectedStatusMetric = ProjectBuildStatusMetric(
        status: status,
      );

      const actualStatusMetric = ProjectBuildStatusMetric(
        status: status,
      );

      expect(actualStatusMetric, equals(expectedStatusMetric));
    });
  });
}
