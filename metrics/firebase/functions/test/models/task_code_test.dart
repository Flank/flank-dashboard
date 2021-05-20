// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:functions/models/task_code.dart';
import 'package:test/test.dart';

void main() {
  group("TaskCode", () {
    test(".values contains all available task data codes", () {
      const expectedValues = {
        TaskCode.buildDaysCreated,
        TaskCode.buildDaysUpdated
      };

      const values = TaskCode.values;

      expect(values, containsAll(expectedValues));
    });
  });
}
