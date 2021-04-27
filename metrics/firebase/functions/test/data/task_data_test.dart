// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/data/task_data.dart';
import 'package:test/test.dart';

void main() {
  group("TaskData", () {
    const projectId = 'projectId';
    const code = 'code';
    const context = 'context';
    final day = Timestamp.fromDateTime(DateTime.now());
    final data = {
      'projectId': projectId,
    };

    final taskData = TaskData(
      code: code,
      data: data,
      context: context,
      day: day,
    );

    test(
      "creates an instance with the given parameters",
      () {
        final taskData = TaskData(
          code: code,
          data: data,
          context: context,
          day: day,
        );

        expect(taskData.code, equals(code));
        expect(taskData.data, equals(data));
        expect(taskData.context, equals(context));
        expect(taskData.day, equals(day));
      },
    );

    test(
      ".toMap() converts an instance to the map",
      () {
        final map = taskData.toMap();
        final expectedMap = {
          'code': code,
          'data': data,
          'context': context,
          'day': day
        };

        expect(map, equals(expectedMap));
      },
    );
  });
}
