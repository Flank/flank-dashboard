// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/models/build_day_status_field.dart';
import 'package:functions/models/build_day_status_field_name.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDayStatusField", () {
    const name = BuildDayStatusFieldName.successful;
    final value = Firestore.fieldValues.increment(1);

    test(
      "throws an ArgumentError if the given name is null",
      () {
        expect(
          () => BuildDayStatusField(name: null, value: value),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given value is null",
      () {
        expect(
          () => BuildDayStatusField(name: name, value: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final buildDayStatusField = BuildDayStatusField(
          name: BuildDayStatusFieldName.successful,
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
          name.value: value,
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
