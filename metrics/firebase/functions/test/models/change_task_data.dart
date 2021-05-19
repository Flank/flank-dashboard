// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:functions/models/change_task_data.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ChangeTaskData", () {
    const beforeProjectId = '1';
    const afterProjectId = '2';

    const beforeUpdateData = BuildData(projectId: beforeProjectId);
    const afterUpdateData = BuildData(projectId: afterProjectId);

    test(
      "throws an ArgumentError if the given before update data is null",
      () {
        expect(
          () => ChangeTaskData(
            beforeUpdateData: null,
            afterUpdateData: afterUpdateData,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given after update data is null",
      () {
        expect(
          () => ChangeTaskData(
            beforeUpdateData: beforeUpdateData,
            afterUpdateData: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final changeTaskData = ChangeTaskData(
          beforeUpdateData: beforeUpdateData,
          afterUpdateData: afterUpdateData,
        );

        expect(changeTaskData.beforeUpdateData, equals(beforeUpdateData));
        expect(changeTaskData.afterUpdateData, equals(afterUpdateData));
      },
    );

    test(
      ".toJson() converts an instance to the JSON-encodable map",
      () {
        final expectedJson = {
          'before': {'projectId': beforeProjectId},
          'after': {'projectId': afterProjectId}
        };

        final changeTaskData = ChangeTaskData(
          beforeUpdateData: beforeUpdateData,
          afterUpdateData: afterUpdateData,
        );

        final json = changeTaskData.toJson();

        expect(json, equals(expectedJson));
      },
    );
  });
}
