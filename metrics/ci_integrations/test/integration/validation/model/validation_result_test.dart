// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:test/test.dart';

import '../../../test_utils/config_field_stub.dart';

void main() {
  group("ValidationResult", () {
    final field = ConfigFieldStub('value');
    final fieldResult = FieldValidationResult.success();

    final results = {
      field: fieldResult,
    };

    test(
      "throws an ArgumentError if the given results is null",
      () {
        expect(() => ValidationResult(null), throwsArgumentError);
      },
    );

    test(
      "creates an instance with the given results",
      () {
        final result = ValidationResult(results);

        expect(result.results, equals(results));
      },
    );
  });
}
