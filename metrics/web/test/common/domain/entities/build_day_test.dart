// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/entities/build_day.dart';

void main() {
  group("BuildDay", () {
    const projectId = 'id';
    const successful = 1;
    const failed = 2;
    const unknown = 3;
    const inProgress = 4;
    const totalDuration = Duration(seconds: 1);

    final day = DateTime(2020);

    test(
      "throws an ArgumentError if the given project id is null",
      () {
        expect(
          () => BuildDay(
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
          () => BuildDay(
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
          () => BuildDay(
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
          () => BuildDay(
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
          () => BuildDay(
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
          () => BuildDay(
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
          () => BuildDay(
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
      "creates a new instance with the given parameters",
      () {
        final buildDay = BuildDay(
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
      "equals to another BuildDay instance with the same parameters",
      () {
        final buildDay = BuildDay(
          projectId: projectId,
          successful: successful,
          failed: failed,
          unknown: unknown,
          inProgress: inProgress,
          totalDuration: totalDuration,
          day: day,
        );

        final anotherBuildDay = BuildDay(
          projectId: projectId,
          successful: successful,
          failed: failed,
          unknown: unknown,
          inProgress: inProgress,
          totalDuration: totalDuration,
          day: day,
        );

        expect(buildDay, equals(anotherBuildDay));
      },
    );
  });
}
