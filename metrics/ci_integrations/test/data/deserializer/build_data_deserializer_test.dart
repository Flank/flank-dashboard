// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/data/deserializer/build_data_deserializer.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDataDeserializer", () {
    const id = 'id';
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

    test(".fromJson() returns BuildData from a JSON map", () {
      final expectedBuildData = BuildData(
        id: id,
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
