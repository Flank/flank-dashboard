// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/models/build_data_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:functions/deserializers/build_data_deserializer.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/build_test_data_generator.dart';

// ignore_for_file: avoid_redundant_argument_values

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
    final testDataGenerator = BuildTestDataGenerator(
      projectId: projectId,
    );

    test(".fromJson() returns null if the given json is null", () {
      final buildData = BuildDataDeserializer.fromJson(null);

      expect(buildData, isNull);
    });

    test(
      ".fromJson() creates a BuildData from the JSON-encodable map",
      () {
        final expectedBuildData = BuildDataModel(
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
        final buildJson = testDataGenerator.generateBuildJson(
          buildNumber: buildNumber,
          startedAt: startedAtDateTime,
          buildStatus: buildStatus,
          duration: duration,
          workflowName: workflowName,
          url: url,
          apiUrl: apiUrl,
          coverage: coverage,
        );

        final buildData = BuildDataDeserializer.fromJson(buildJson, id: id);

        expect(buildData, equals(expectedBuildData));
      },
    );

    test(
      ".fromJson() creates a BuildData with a null id from the JSON-encodable map if the id is not passed",
      () {
        final buildJson = testDataGenerator.generateBuildJson();

        final buildData = BuildDataDeserializer.fromJson(buildJson);

        expect(buildData.id, isNull);
      },
    );

    test(
      ".fromJson() creates a BuildData with a succesful build status if the given json contains successful build status enum value",
      () {
        const expectedBuildStatus = BuildStatus.successful;
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: expectedBuildStatus,
        );

        final buildData = BuildDataDeserializer.fromJson(buildJson);

        expect(buildData.buildStatus, equals(expectedBuildStatus));
      },
    );

    test(
      ".fromJson() creates a BuildData with a failed build status if the given json contains failed build status enum value",
      () {
        const expectedBuildStatus = BuildStatus.failed;
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: expectedBuildStatus,
        );

        final buildData = BuildDataDeserializer.fromJson(buildJson);

        expect(buildData.buildStatus, equals(expectedBuildStatus));
      },
    );

    test(
      ".fromJson() creates a BuildData with an inProgress build status if the given json contains inProgress build status enum value",
      () {
        const expectedBuildStatus = BuildStatus.inProgress;
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: expectedBuildStatus,
        );

        final buildData = BuildDataDeserializer.fromJson(buildJson);

        expect(buildData.buildStatus, equals(expectedBuildStatus));
      },
    );

    test(
      ".fromJson() creates a BuildData with an unknown build status if the given json contains unknown build status enum value",
      () {
        const expectedBuildStatus = BuildStatus.unknown;
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: expectedBuildStatus,
        );

        final buildData = BuildDataDeserializer.fromJson(buildJson);

        expect(buildData.buildStatus, equals(expectedBuildStatus));
      },
    );

    test(
      ".fromJson() creates a BuildData with an unknown build status if the given json contains invalid enum value",
      () {
        const expectedBuildStatus = BuildStatus.unknown;
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: null,
        );

        final buildData = BuildDataDeserializer.fromJson(buildJson);

        expect(buildData.buildStatus, equals(expectedBuildStatus));
      },
    );

    test(
      ".fromJson() converts the startedAt json value from a Timestamp to a DateTime while creating a BuildData",
      () {
        final expectedDateTime = startedAt.toDateTime();
        final buildJson = testDataGenerator.generateBuildJson(
          startedAt: expectedDateTime,
        );

        final buildData = BuildDataDeserializer.fromJson(buildJson);

        expect(buildData.startedAt, equals(expectedDateTime));
      },
    );

    test(
      ".fromJson() creates a BuildData with a zero duration if the given json has null duration",
      () {
        final buildJson = testDataGenerator.generateBuildJson(
          duration: null,
        );

        final buildData = BuildDataDeserializer.fromJson(buildJson);

        expect(buildData.duration, Duration.zero);
      },
    );

    test(
      ".fromJson() parses a duration from the given json",
      () {
        final buildJson = testDataGenerator.generateBuildJson(
          duration: duration,
        );

        final buildData = BuildDataDeserializer.fromJson(buildJson);

        expect(buildData.duration, duration);
      },
    );

    test(
      ".fromJson() creates a BuildData with a null coverage if the given json has a null coverage",
      () {
        final buildJson = testDataGenerator.generateBuildJson(
          coverage: null,
        );

        final buildData = BuildDataDeserializer.fromJson(buildJson);

        expect(buildData.coverage, isNull);
      },
    );

    test(
      ".fromJson() parses a coverage from the given json",
      () {
        final buildJson = testDataGenerator.generateBuildJson(
          coverage: coverage,
        );

        final buildData = BuildDataDeserializer.fromJson(buildJson);

        expect(buildData.coverage, coverage);
      },
    );
  });
}
