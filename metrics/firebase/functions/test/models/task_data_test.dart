// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/models/task_code.dart';
import 'package:functions/models/task_data.dart';
import 'package:test/test.dart';

void main() {
  group("TaskData", () {
    const projectId = 'projectId';
    const code = TaskCode.buildDaysCreated;
    const context = 'context';
    final createdAt = DateTime.now();
    final data = {
      'projectId': projectId,
    };

    test(
      "throws an ArgumentError if the given code is null",
      () {
        expect(
          () => TaskData(
            code: null,
            data: data,
            context: context,
            createdAt: createdAt,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given created at parameter is null",
      () {
        expect(
          () => TaskData(
            code: code,
            data: data,
            context: context,
            createdAt: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final taskData = TaskData(
          code: code,
          data: data,
          context: context,
          createdAt: createdAt,
        );

        expect(taskData.code, equals(code));
        expect(taskData.data, equals(data));
        expect(taskData.context, equals(context));
        expect(taskData.createdAt, equals(createdAt));
      },
    );

    test(
      ".copyWith() creates a new instance with the same fields if called without params",
      () {
        final taskData = TaskData(
          code: code,
          data: data,
          context: context,
          createdAt: createdAt,
        );

        final copiedTaskData = taskData.copyWith();

        expect(copiedTaskData.code, equals(code));
        expect(copiedTaskData.data, equals(data));
        expect(copiedTaskData.context, equals(context));
        expect(copiedTaskData.createdAt, equals(createdAt));
      },
    );

    test(
      ".copyWith() creates a copy of an instance with the given fields replaced with the new values",
      () {
        final taskData = TaskData(
          code: code,
          data: data,
          context: 'error',
          createdAt: DateTime(2020),
        );

        final copiedTaskData = taskData.copyWith(
          context: context,
          createdAt: createdAt,
        );

        expect(copiedTaskData.code, equals(code));
        expect(copiedTaskData.data, equals(data));
        expect(copiedTaskData.context, equals(context));
        expect(copiedTaskData.createdAt, equals(createdAt));
      },
    );

    test(
      ".toMap() converts an instance to the map",
      () {
        final expectedMap = {
          'code': code.value,
          'data': data,
          'context': context,
          'createdAt': Timestamp.fromDateTime(createdAt)
        };

        final taskData = TaskData(
          code: code,
          data: data,
          context: context,
          createdAt: createdAt,
        );

        final map = taskData.toMap();

        expect(map, equals(expectedMap));
      },
    );
  });
}
