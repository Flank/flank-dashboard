// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:functions/models/build_day_status_field_name.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDayStatusFieldName", () {
    test(".values contains all available build day status field names", () {
      const expectedValues = {
        BuildDayStatusFieldName.successful,
        BuildDayStatusFieldName.failed,
        BuildDayStatusFieldName.inProgress,
        BuildDayStatusFieldName.unknown,
      };

      final values = BuildDayStatusFieldName.values;

      expect(values, containsAll(expectedValues));
    });
  });
}
