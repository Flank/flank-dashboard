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
    const buildStatus = BuildStatus.failed;
    const duration = Duration(milliseconds: 100000);
    const workflowName = 'testWorkflowName';
    const url = 'testUrl';
    const apiUrl = 'testApiUrl';

    final startedAtDateTime = DateTime.now();
    final startedAt = Timestamp.fromDateTime(startedAtDateTime);
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
      ".fromJson() creates a BuildData with a succesful build status if the given json contains successful build status enum value",
      () {
        const expectedBuildStatus = BuildStatus.successful;
        final json = Map<String, dynamic>.from(buildDataJson);
        json['buildStatus'] = expectedBuildStatus.toString();

        final buildData = BuildDataDeserializer.fromJson(json);

        expect(buildData.buildStatus, expectedBuildStatus);
      },
    );

    test(
      ".fromJson() creates a BuildData with a failed build status if the given json contains failed build status enum value",
      () {
        const expectedBuildStatus = BuildStatus.failed;
        final json = Map<String, dynamic>.from(buildDataJson);
        json['buildStatus'] = expectedBuildStatus.toString();

        final buildData = BuildDataDeserializer.fromJson(json);

        expect(buildData.buildStatus, expectedBuildStatus);
      },
    );

    test(
      ".fromJson() creates a BuildData with an inProgress build status if the given json contains inProgress build status enum value",
      () {
        const expectedBuildStatus = BuildStatus.inProgress;
        final json = Map<String, dynamic>.from(buildDataJson);
        json['buildStatus'] = expectedBuildStatus.toString();

        final buildData = BuildDataDeserializer.fromJson(json);

        expect(buildData.buildStatus, expectedBuildStatus);
      },
    );

    test(
      ".fromJson() creates a BuildData with an unknown build status if the given json contains unknown build status enum value",
      () {
        const expectedBuildStatus = BuildStatus.unknown;
        final json = Map<String, dynamic>.from(buildDataJson);
        json['buildStatus'] = expectedBuildStatus.toString();

        final buildData = BuildDataDeserializer.fromJson(json);

        expect(buildData.buildStatus, BuildStatus.unknown);
      },
    );

    test(
      ".fromJson() creates a BuildData with an unknown build status if the given json contains invalid enum value",
      () {
        const expectedBuildStatus = BuildStatus.unknown;
        final json = Map<String, dynamic>.from(buildDataJson);
        json['buildStatus'] = 'invalid';

        final buildData = BuildDataDeserializer.fromJson(json);

        expect(buildData.buildStatus, expectedBuildStatus);
      },
    );

    test(
      ".fromJson() converts the createdAt json value from a Timestamp to a DateTime while creating a BuildData",
      () {
        final expectedDateTime = startedAt.toDateTime();
        final buildData = BuildDataDeserializer.fromJson(buildDataJson);

        expect(buildData.startedAt, equals(expectedDateTime));
      },
    );

    test(
      ".fromJson() creates a BuildData with a zero duration if the given json has null duration",
      () {
        final json = Map<String, dynamic>.from(buildDataJson);
        json.remove('duration');

        final buildData = BuildDataDeserializer.fromJson(json);

        expect(buildData.duration, Duration.zero);
      },
    );

    test(
      ".fromJson() properly converts a duration from the given json",
      () {
        final buildData = BuildDataDeserializer.fromJson(buildDataJson);

        expect(buildData.duration, duration);
      },
    );

    test(
      ".fromJson() properly converts a coverage from the given json",
      () {
        final buildData = BuildDataDeserializer.fromJson(buildDataJson);

        expect(buildData.coverage, coverage);
      },
    );

    test(
      ".fromJson() creates a BuildData with a null coverage if the given json has a null coverage",
      () {
        final json = Map<String, dynamic>.from(buildDataJson);
        json.remove('coverage');

        final buildData = BuildDataDeserializer.fromJson(json);

        expect(buildData.coverage, isNull);
      },
    );
  });
}
