// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/models/build_day_data.dart';
import 'package:functions/models/build_day_status_field.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDayData", () {
    const projectId = 'projectId';
    final day = DateTime.now();
    final successfulBuildsDuration = Firestore.fieldValues.increment(10);
    final statusIncrements = [
      BuildDayStatusField(
        name: 'successful',
        value: Firestore.fieldValues.increment(1),
      ),
    ];

    test(
      "throws an ArgumentError if the given project id is null",
      () {
        expect(
          () => BuildDayData(
            projectId: null,
            day: day,
            successfulBuildsDuration: successfulBuildsDuration,
            statusIncrements: statusIncrements,
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
            day: null,
            successfulBuildsDuration: successfulBuildsDuration,
            statusIncrements: statusIncrements,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final buildDayData = BuildDayData(
          projectId: projectId,
          day: day,
          successfulBuildsDuration: successfulBuildsDuration,
          statusIncrements: statusIncrements,
        );

        expect(buildDayData.projectId, equals(projectId));
        expect(buildDayData.day, equals(day));
        expect(
          buildDayData.successfulBuildsDuration,
          equals(successfulBuildsDuration),
        );
        expect(buildDayData.statusIncrements, equals(statusIncrements));
      },
    );

    test(
      ".toMap() converts an instance to the map",
      () {
        final statusFieldMap = statusIncrements.first.toMap();
        final expectedMap = {
          'projectId': projectId,
          'day': Timestamp.fromDateTime(day),
          'successfulBuildsDuration': successfulBuildsDuration,
          ...statusFieldMap,
        };

        final buildDayData = BuildDayData(
          projectId: projectId,
          day: day,
          successfulBuildsDuration: successfulBuildsDuration,
          statusIncrements: statusIncrements,
        );

        final map = buildDayData.toMap();

        expect(map, equals(expectedMap));
      },
    );
  });
}
