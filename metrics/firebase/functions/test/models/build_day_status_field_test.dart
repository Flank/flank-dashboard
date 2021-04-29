// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/models/build_day_status_field.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDayStatusField", () {
    const name = 'name';
    final value = Firestore.fieldValues.increment(1);

    test(
      "creates an instance with the given parameters",
      () {
        final buildDayStatusField = BuildDayStatusField(
          name: name,
          value: value,
        );

        expect(buildDayStatusField.name, equals(name));
        expect(buildDayStatusField.value, equals(value));
      },
    );

    test(
      ".toMap() converts an instance to the map",
      () {
        final expectedMap = {
          name: value,
        };

        final buildDayStatusField = BuildDayStatusField(
          name: name,
          value: value,
        );

        final buildDayStatusFieldMap = buildDayStatusField.toMap();

        expect(buildDayStatusFieldMap, equals(expectedMap));
      },
    );
  });
}
