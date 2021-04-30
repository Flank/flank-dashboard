// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDataDeserializer", () {
    const id = 'id';
    const projectId = 'projectId';
    const duration = Duration(milliseconds: 100000);
    const url = 'testUrl';
    const apiUrl = 'testApiUrl';
    const buildNumber = 1;
    const buildStatus = BuildStatus.failed;
    const workflowName = 'testWorkflowName';
    final coverage = Percent(1.0);
    final startedAt = DateTime.now();
    final buildDataJson = {
      'id': id,
      'projectId': projectId,
      'duration': duration.inMilliseconds,
      'startedAt': startedAt,
      'url': url,
      'apiUrl': apiUrl,
      'buildNumber': buildNumber,
      'buildStatus': buildStatus.toString(),
      'workflowName': workflowName,
      'coverage': coverage.value,
    };

    test(
      ".fromJson() returns null if the given JSON is null",
      () {
        final buildData = BuildDataDeserializer.fromJson(null, id);

        expect(buildData, isNull);
      },
    );

    test(".fromJson() creates a BuildData from the JSON-encodable map", () {
      final expectedBuildData = BuildData(
        id: id,
        projectId: projectId,
        duration: duration,
        startedAt: startedAt,
        url: url,
        apiUrl: apiUrl,
        buildNumber: buildNumber,
        buildStatus: buildStatus,
        workflowName: workflowName,
        coverage: coverage,
      );

      final buildData = BuildDataDeserializer.fromJson(buildDataJson, id);

      expect(buildData, equals(expectedBuildData));
    });
  });
}
