// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildData", () {
    const id = 'id';
    const projectId = 'projectId';
    const buildNumber = 1;
    final startedAt = DateTime.utc(2020, 4, 13);
    const buildStatus = BuildStatus.successful;
    const duration = Duration(seconds: 1);
    const workflowName = 'workflowName';
    const url = 'url';
    const apiUrl = 'apiUrl';
    final coverage = Percent(1.0);

    final buildDataJson = {
      'projectId': projectId,
      'buildNumber': buildNumber,
      'startedAt': startedAt,
      'buildStatus': buildStatus.toString(),
      'duration': duration.inMilliseconds,
      'workflowName': workflowName,
      'url': url,
      'apiUrl': apiUrl,
      'coverage': coverage.value,
    };

    final buildData = BuildData(
      id: id,
      projectId: projectId,
      buildNumber: buildNumber,
      startedAt: startedAt,
      buildStatus: buildStatus,
      duration: duration,
      workflowName: workflowName,
      url: url,
      apiUrl: apiUrl,
      coverage: coverage,
    );

    test(
      ".copyWith() creates a new instance from the existing one",
      () {
        const id = 'newId';
        const projectId = 'newProjectId';
        const buildNumber = 10;
        final startedAt = DateTime(2020, 12, 31);
        const buildStatus = BuildStatus.unknown;
        const duration = Duration();
        const workflowName = 'newWorkflowName';
        const url = 'newUrl';
        const apiUrl = 'newApiUrl';
        final coverage = Percent(0.0);

        final copiedBuildData = buildData.copyWith(
          id: id,
          projectId: projectId,
          buildNumber: buildNumber,
          startedAt: startedAt,
          buildStatus: buildStatus,
          duration: duration,
          workflowName: workflowName,
          url: url,
          apiUrl: apiUrl,
          coverage: coverage,
        );

        expect(copiedBuildData.id, equals(id));
        expect(copiedBuildData.projectId, equals(projectId));
        expect(copiedBuildData.buildNumber, equals(buildNumber));
        expect(copiedBuildData.startedAt, equals(startedAt));
        expect(copiedBuildData.buildStatus, equals(buildStatus));
        expect(copiedBuildData.duration, equals(duration));
        expect(copiedBuildData.workflowName, equals(workflowName));
        expect(copiedBuildData.url, equals(url));
        expect(copiedBuildData.apiUrl, equals(apiUrl));
        expect(copiedBuildData.coverage, equals(coverage));
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        expect(buildData.toJson(), equals(buildDataJson));
      },
    );
  });
}
