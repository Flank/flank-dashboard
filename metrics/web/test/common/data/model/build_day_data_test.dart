// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/common/data/model/build_day_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildDayData", () {
    const projectId = 'id';
    const successful = 1;
    const failed = 1;
    const unknown = 1;
    const inProgress = 1;
    const totalDuration = Duration(seconds: 1);

    final day = DateTime(2021);

    Map<String, dynamic> createBuildDayDataJson({
      String projectId,
      int successful = 1,
      int failed = 1,
      int unknown = 1,
      int inProgress = 1,
      int totalDuration,
      Timestamp day,
    }) {
      return {
        'projectId': projectId ?? 'id',
        'successful': successful,
        'failed': failed,
        'unknown': unknown,
        'inProgress': inProgress,
        'totalDuration': totalDuration,
        'day': day ?? Timestamp.fromDate(DateTime(2021)),
      };
    }

    test(
      "throws an ArgumentError if the given project id is null",
      () {
        expect(
          () => BuildDayData(
            projectId: null,
            successful: successful,
            failed: failed,
            unknown: unknown,
            inProgress: inProgress,
            totalDuration: totalDuration,
            day: day,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given successful is null",
      () {
        expect(
          () => BuildDayData(
            projectId: projectId,
            successful: null,
            failed: failed,
            unknown: unknown,
            inProgress: inProgress,
            totalDuration: totalDuration,
            day: day,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given failed is null",
      () {
        expect(
          () => BuildDayData(
            projectId: projectId,
            successful: successful,
            failed: null,
            unknown: unknown,
            inProgress: inProgress,
            totalDuration: totalDuration,
            day: day,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given unknown is null",
      () {
        expect(
          () => BuildDayData(
            projectId: projectId,
            successful: successful,
            failed: failed,
            unknown: null,
            inProgress: inProgress,
            totalDuration: totalDuration,
            day: day,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given in progress is null",
      () {
        expect(
          () => BuildDayData(
            projectId: projectId,
            successful: successful,
            failed: failed,
            unknown: unknown,
            inProgress: null,
            totalDuration: totalDuration,
            day: day,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given total duration is null",
      () {
        expect(
          () => BuildDayData(
            projectId: projectId,
            successful: successful,
            failed: failed,
            unknown: unknown,
            inProgress: inProgress,
            totalDuration: null,
            day: day,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given day is null",
      () {
        expect(
          () => BuildDayData(
            projectId: projectId,
            successful: successful,
            failed: failed,
            unknown: unknown,
            inProgress: inProgress,
            totalDuration: totalDuration,
            day: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final buildDay = BuildDayData(
          projectId: projectId,
          successful: successful,
          failed: failed,
          unknown: unknown,
          inProgress: inProgress,
          totalDuration: totalDuration,
          day: day,
        );

        expect(buildDay.projectId, equals(projectId));
        expect(buildDay.successful, equals(successful));
        expect(buildDay.failed, equals(failed));
        expect(buildDay.unknown, equals(unknown));
        expect(buildDay.inProgress, equals(inProgress));
        expect(buildDay.totalDuration, equals(totalDuration));
        expect(buildDay.day, equals(day));
      },
    );

    test(
      "equals to another BuildDayData instance with the same parameters",
      () {
        final buildDayData = BuildDayData(
          projectId: projectId,
          successful: successful,
          failed: failed,
          unknown: unknown,
          inProgress: inProgress,
          totalDuration: totalDuration,
          day: day,
        );

        final anotherBuildDayData = BuildDayData(
          projectId: projectId,
          successful: successful,
          failed: failed,
          unknown: unknown,
          inProgress: inProgress,
          totalDuration: totalDuration,
          day: day,
        );

        expect(buildDayData, equals(anotherBuildDayData));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final buildDayData = BuildDayData.fromJson(null);

        expect(buildDayData, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final expectedBuildDayData = BuildDayData(
          projectId: projectId,
          successful: successful,
          failed: failed,
          unknown: unknown,
          inProgress: inProgress,
          totalDuration: totalDuration,
          day: day,
        );

        final json = createBuildDayDataJson(
          projectId: projectId,
          successful: successful,
          failed: failed,
          unknown: unknown,
          inProgress: inProgress,
          totalDuration: totalDuration.inMilliseconds,
          day: Timestamp.fromDate(day),
        );

        final buildDayData = BuildDayData.fromJson(json);

        expect(buildDayData, equals(expectedBuildDayData));
      },
    );

    test(
      ".fromJson() maps the null number of successful builds in the given json to zero",
      () {
        final json = createBuildDayDataJson(successful: null);

        final buildDayData = BuildDayData.fromJson(json);

        expect(buildDayData.successful, isZero);
      },
    );

    test(
      ".fromJson() maps the null number of failed builds in the given json to zero",
      () {
        final json = createBuildDayDataJson(failed: null);

        final buildDayData = BuildDayData.fromJson(json);

        expect(buildDayData.failed, isZero);
      },
    );

    test(
      ".fromJson() maps the null number of unknown builds in the given json to zero",
      () {
        final json = createBuildDayDataJson(unknown: null);

        final buildDayData = BuildDayData.fromJson(json);

        expect(buildDayData.unknown, isZero);
      },
    );

    test(
      ".fromJson() maps the null number of in progress builds in the given json to zero",
      () {
        final json = createBuildDayDataJson(inProgress: null);

        final buildDayData = BuildDayData.fromJson(json);

        expect(buildDayData.inProgress, isZero);
      },
    );

    test(
      ".fromJson() maps the null total duration in the given json to zero duration",
      () {
        const expectedTotalDuration = Duration.zero;
        final json = createBuildDayDataJson(totalDuration: null);

        final buildDayData = BuildDayData.fromJson(json);

        expect(buildDayData.totalDuration, equals(expectedTotalDuration));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final buildDayData = BuildDayData.fromJson(null);

        expect(buildDayData, isNull);
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        final expectedJson = createBuildDayDataJson(
          projectId: projectId,
          successful: successful,
          failed: failed,
          unknown: unknown,
          inProgress: inProgress,
          totalDuration: totalDuration.inMilliseconds,
          day: Timestamp.fromDate(day),
        );

        final buildDayData = BuildDayData(
          projectId: projectId,
          successful: successful,
          failed: failed,
          unknown: unknown,
          inProgress: inProgress,
          totalDuration: totalDuration,
          day: day,
        );

        final json = buildDayData.toJson();

        expect(json, equals(expectedJson));
      },
    );
  });
}
