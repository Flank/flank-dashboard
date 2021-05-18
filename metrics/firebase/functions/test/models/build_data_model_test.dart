// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:functions/models/build_data_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDataModel", () {
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

    test(
      "creates an instance with the given parameters",
      () {
        final buildData = BuildDataModel(
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

        expect(buildData.id, equals(id));
        expect(buildData.projectId, equals(projectId));
        expect(buildData.buildNumber, equals(buildNumber));
        expect(buildData.startedAt, equals(startedAt));
        expect(buildData.buildStatus, equals(buildStatus));
        expect(buildData.duration, equals(duration));
        expect(buildData.workflowName, equals(workflowName));
        expect(buildData.url, equals(url));
        expect(buildData.apiUrl, equals(apiUrl));
        expect(buildData.coverage, equals(coverage));
      },
    );

    test(
      ".toJson() converts an instance to the JSON-encodable map",
      () {
        final expectedJson = {
          'id': id,
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
        final buildData = BuildDataModel(
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

        expect(buildData.toJson(), equals(expectedJson));
      },
    );
  });
}
