// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:functions/serializers/build_data_serializer.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDataSerializer", () {
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
      ".toJson() returns null if the given build data is null",
      () {
        final expectedBuildDataJson = BuildDataSerializer.toJson(null);

        expect(expectedBuildDataJson, isNull);
      },
    );

    test(
      ".toJson() converts the given build data into the JSON-encodable map",
      () {
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
        final expectedBuildDataJson = {
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

        final buildDataJson = BuildDataSerializer.toJson(buildData);

        expect(buildDataJson, equals(expectedBuildDataJson));
      },
    );
  });
}
