// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:functions/models/task_data_code.dart';
import 'package:test/test.dart';

void main() {
  group("TaskDataCode", () {
    test(".values contains all available task data codes", () {
      const expectedValues = {
        TaskDataCode.buildDaysCreated,
        TaskDataCode.buildDaysUpdated
      };

      final values = TaskDataCode.values;

      expect(values, containsAll(expectedValues));
    });
  });
}
