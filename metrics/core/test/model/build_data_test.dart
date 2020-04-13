import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

const id = 'id';
const projectId = 'projectId';
const buildNumber = 1;
final DateTime startedAt = DateTime.utc(2020, 4, 13);
const buildStatus = BuildStatus.successful;
const duration = Duration(seconds: 1);
const workflowName = 'workflowName';
const url = 'url';
const coverage = Percent(1.0);

final Map<String, dynamic> json = {
  'projectId': projectId,
  'buildNumber': buildNumber,
  'startedAt': startedAt,
  'buildStatus': buildStatus?.toString(),
  'duration': duration?.inMilliseconds,
  'workflowName': workflowName,
  'url': url,
  'coverage': coverage?.value,
};

final BuildData buildData = BuildData(
  id: id,
  projectId: projectId,
  buildNumber: buildNumber,
  startedAt: startedAt,
  buildStatus: buildStatus,
  duration: duration,
  workflowName: workflowName,
  url: url,
  coverage: coverage,
);

void main() {
  test(
      "Creates the new BuildData instance from the existing one using the .copyWith()",
      () {
    final copiedBuildData = buildData.copyWith();

    expect(copiedBuildData.id, equals(id));
    expect(copiedBuildData.projectId, equals(projectId));
    expect(copiedBuildData.buildNumber, equals(buildNumber));
    expect(copiedBuildData.startedAt, equals(startedAt));
    expect(copiedBuildData.buildStatus, equals(buildStatus));
    expect(copiedBuildData.duration, equals(duration));
    expect(copiedBuildData.workflowName, equals(workflowName));
    expect(copiedBuildData.url, equals(url));
    expect(copiedBuildData.coverage, equals(coverage));
  });

  test(".toJson() should convert a BuildData instance to the json map", () {
    expect(buildData.toJson(), equals(json));
  });
}
