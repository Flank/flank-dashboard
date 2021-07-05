// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/src/util/validation/validation_target.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ValidationTarget", () {
    const name = 'name';
    const description = 'description';

    test(
      "throws an AssertionError if the given name is null",
      () {
        expect(
          () => ValidationTarget(name: null),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        const target = ValidationTarget(
          name: name,
          description: description,
        );

        expect(target.name, equals(name));
        expect(target.description, equals(description));
      },
    );
  });
}
