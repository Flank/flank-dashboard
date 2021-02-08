// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/util/validator/string_validator.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("StringValidator", () {
    test(
      "throws an ArgumentError if the given value is null",
      () {
        expect(
          () => StringValidator.checkNotNullOrEmpty(null),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given value is empty",
      () {
        expect(
          () => StringValidator.checkNotNullOrEmpty(''),
          throwsArgumentError,
        );
      },
    );

    test(
      "validates the given value",
      () {
        expect(
          () => StringValidator.checkNotNullOrEmpty('test'),
          returnsNormally,
        );
      },
    );

    test(
      "throws an ArgumentError that contains the name of a validated variable if specified",
      () {
        const testName = 'test';

        expect(
          () => StringValidator.checkNotNullOrEmpty(null, name: testName),
          throwsA(
            (error) => error is ArgumentError && error.name == testName,
          ),
        );
      },
    );

    test(
      "throws an ArgumentError that doesn't contain the name of a validated variable if it wasn't specified",
      () {
        expect(
          () => StringValidator.checkNotNullOrEmpty(null, name: null),
          throwsA(
            (error) => error is ArgumentError && error.name == null,
          ),
        );
      },
    );
  });
}
