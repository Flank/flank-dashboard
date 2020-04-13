import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

const buildNumber = 1;
final DateTime startedAt = DateTime.utc(2020, 4, 13);
const buildStatus = BuildStatus.successful;
const duration = Duration(seconds: 1);
const workflowName = 'workflowName';

void main() {
  test("Two identical Build instances are equal", () {
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
}
