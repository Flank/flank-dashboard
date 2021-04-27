// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/data/build_day_data.dart';
import 'package:functions/data/build_day_status_field.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDayData", () {
    const projectId = 'projectId';
    final day = Timestamp.fromDateTime(DateTime.now());
    final totalDuration = Firestore.fieldValues.increment(10);
    final statusField = BuildDayStatusField(
      name: 'successful',
      value: Firestore.fieldValues.increment(1),
    );

    test(
      "creates an instance with the given parameters",
      () {
        final buildDayData = BuildDayData(
          projectId: projectId,
          day: day,
          totalDuration: totalDuration,
          statusField: statusField,
        );

        expect(buildDayData.projectId, equals(projectId));
        expect(buildDayData.day, equals(day));
        expect(buildDayData.totalDuration, equals(totalDuration));
        expect(buildDayData.statusField, equals(statusField));
      },
    );

    test(
      ".toMap() converts an instance to the map",
      () {
        final buildDayData = BuildDayData(
          projectId: projectId,
          day: day,
          totalDuration: totalDuration,
          statusField: statusField,
        );
        final map = buildDayData.toMap();
        final statusFieldMap = statusField.toMap();
        final expectedMap = {
          'projectId': projectId,
          'day': day,
          'totalDuration': totalDuration,
          ...statusFieldMap,
        };

        expect(map, equals(expectedMap));
      },
    );
  });
}
