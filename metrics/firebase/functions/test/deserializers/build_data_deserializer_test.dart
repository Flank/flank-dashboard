// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:functions/deserializers/build_data_deserializer.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDataDeserializer", () {
    const id = 'id';
    const projectId = 'projectId';
    const buildNumber = 1;
    final startedAtDateTime = DateTime.now();
    final startedAt = Timestamp.fromDateTime(startedAtDateTime);
    const buildStatus = BuildStatus.failed;
    const duration = Duration(milliseconds: 100000);
    const workflowName = 'testWorkflowName';
    const url = 'testUrl';
    const apiUrl = 'testApiUrl';
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

    test(".fromJson() returns null if the given json is null", () {
      final buildData = BuildDataDeserializer.fromJson(null);

      expect(buildData, isNull);
    });

    test(
      ".fromJson() creates a BuildData from the JSON-encodable map",
      () {
        final expectedBuildData = BuildData(
          id: id,
          projectId: projectId,
          buildNumber: buildNumber,
          startedAt: startedAtDateTime,
          buildStatus: buildStatus,
          duration: duration,
          workflowName: workflowName,
          url: url,
          apiUrl: apiUrl,
          coverage: coverage,
        );

        final buildData = BuildDataDeserializer.fromJson(buildDataJson, id: id);

        expect(buildData, equals(expectedBuildData));
      },
    );

    test(
      ".fromJson() creates a BuildData with a null id from the JSON-encodable map if the id is not passed",
      () {
        final expectedBuildData = BuildData(
          id: null,
          projectId: projectId,
          buildNumber: buildNumber,
          startedAt: startedAtDateTime,
          buildStatus: buildStatus,
          duration: duration,
          workflowName: workflowName,
          url: url,
          apiUrl: apiUrl,
          coverage: coverage,
        );

        final buildData = BuildDataDeserializer.fromJson(buildDataJson);

        expect(buildData, equals(expectedBuildData));
      },
    );

    test(
      ".fromJson() creates a BuildData with a failed build status if the given json contains failed build status enum value",
      () {
        final buildData = BuildDataDeserializer.fromJson(buildDataJson);

        expect(buildData.buildStatus, buildStatus);
      },
    );

    test(
      ".fromJson() creates a BuildData with an unknown build status if the given json contains invalid enum value",
      () {
        final json = Map<String, dynamic>.from(buildDataJson);
        json['buildStatus'] = 'invalid';

        final buildData = BuildDataDeserializer.fromJson(json);

        expect(buildData.buildStatus, BuildStatus.unknown);
      },
    );

    test(
      ".fromJson() converts the createdAt json value from a Timestamp to a DateTime while creating a BuildData",
      () {
        final buildData = BuildDataDeserializer.fromJson(buildDataJson);

        expect(buildData.startedAt, isA<DateTime>());
      },
    );
  });
}
