// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/field_validation_conclusion.dart';
import 'package:test/test.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("FieldValidationResult", () {
    const additionalContext = 'context';

    const successResult = FieldValidationResult.success();
    const failureResult = FieldValidationResult.failure();
    const unknownResult = FieldValidationResult.unknown();

    test(
      ".success() creates an instance with the valid field validation conclusion",
      () {
        expect(
          successResult.conclusion,
          equals(FieldValidationConclusion.valid),
        );
      },
    );

    test(
      ".success() creates an instance with the given additional context",
      () {
        const result = FieldValidationResult.success(additionalContext);

        expect(result.additionalContext, equals(additionalContext));
      },
    );

    test(
      ".failure() creates an instance with the invalid field validation conclusion",
      () {
        expect(
          failureResult.conclusion,
          equals(FieldValidationConclusion.invalid),
        );
      },
    );

    test(
      ".failure() creates an instance with the given additional context",
      () {
        const result = FieldValidationResult.failure(additionalContext);

        expect(result.additionalContext, equals(additionalContext));
      },
    );

    test(
      ".unknown() creates an instance with the unknown field validation conclusion",
      () {
        expect(
          unknownResult.conclusion,
          equals(FieldValidationConclusion.unknown),
        );
      },
    );

    test(
      ".unknown() creates an instance with the given additional context",
      () {
        const result = FieldValidationResult.unknown(additionalContext);

        expect(result.additionalContext, equals(additionalContext));
      },
    );
  });
}
