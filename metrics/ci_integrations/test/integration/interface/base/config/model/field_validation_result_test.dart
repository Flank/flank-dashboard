// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/field_validation_conclusion.dart';
import 'package:ci_integration/integration/interface/base/config/model/mappers/field_validation_conclusion_mapper.dart';
import 'package:test/test.dart';
import 'package:ci_integration/integration/interface/base/config/model/field_validation_result.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("FieldValidationResult", () {
    const field = 'field';
    const additionalContext = 'context';

    final successResult = FieldValidationResult.success(field);
    final failureResult = FieldValidationResult.failure(field);
    final unknownResult = FieldValidationResult.unknown(field);

    const conclusionMapper = FieldValidationConclusionMapper();

    test(
      ".success() throws an ArgumentError if the given field is null",
      () {
        expect(() => FieldValidationResult.success(null), throwsArgumentError);
      },
    );
    test(
      ".success() creates an instance with the given field and additional context",
      () {
        final result = FieldValidationResult.success(field, additionalContext);

        expect(result.field, equals(field));
        expect(result.additionalContext, equals(additionalContext));
      },
    );

    test(
      ".isSuccess returns true if the field validation result is success",
      () {
        expect(successResult.isSuccess, isTrue);
      },
    );

    test(
      ".isFailure returns false if the field validation result is success",
      () {
        expect(successResult.isFailure, isFalse);
      },
    );

    test(
      ".isUnknown returns false if the field validation result is success",
      () {
        expect(successResult.isUnknown, isFalse);
      },
    );

    test(
      ".failure() throws an ArgumentError if the given field is null",
      () {
        expect(() => FieldValidationResult.failure(null), throwsArgumentError);
      },
    );

    test(
      ".failure() creates an instance with the given field and additional context",
      () {
        final result = FieldValidationResult.failure(field, additionalContext);

        expect(result.field, equals(field));
        expect(result.additionalContext, equals(additionalContext));
      },
    );

    test(
      ".isSuccess returns false if the field validation result is failure",
      () {
        expect(failureResult.isSuccess, isFalse);
      },
    );

    test(
      ".isFailure returns true if the field validation result is failure",
      () {
        expect(failureResult.isFailure, isTrue);
      },
    );

    test(
      ".isUnknown returns false if the field validation result is failure",
      () {
        expect(failureResult.isUnknown, isFalse);
      },
    );

    test(
      ".unknown() throws an ArgumentError if the given field is null",
      () {
        expect(() => FieldValidationResult.unknown(null), throwsArgumentError);
      },
    );

    test(
      ".unknown() creates an instance with the given field and additional context",
      () {
        final result = FieldValidationResult.unknown(field, additionalContext);

        expect(result.field, equals(field));
        expect(result.additionalContext, equals(additionalContext));
      },
    );

    test(
      ".isSuccess returns false if the field validation result is unknown",
      () {
        expect(unknownResult.isSuccess, isFalse);
      },
    );

    test(
      ".isFailure returns false if the field validation result is unknown",
      () {
        expect(unknownResult.isFailure, isFalse);
      },
    );

    test(
      ".isUnknown returns true if the field validation result is unknown",
      () {
        expect(unknownResult.isUnknown, isTrue);
      },
    );

    test(
      ".toString() contains the field name",
      () {
        final result = FieldValidationResult.success(field);

        final string = result.toString();

        expect(string, contains(field));
      },
    );

    test(
      ".toString() contains the valid field conclusion value if the result is success",
      () {
        final expectedConclusion = conclusionMapper.unmap(
          FieldValidationConclusion.valid,
        );

        final string = successResult.toString();

        expect(string, contains(expectedConclusion));
      },
    );

    test(
      ".toString() contains the invalid field conclusion value if the result is failure",
      () {
        final expectedConclusion = conclusionMapper.unmap(
          FieldValidationConclusion.invalid,
        );

        final string = failureResult.toString();

        expect(string, contains(expectedConclusion));
      },
    );

    test(
      ".toString() contains the unknown field conclusion value if the result is unknown",
      () {
        final expectedConclusion = conclusionMapper.unmap(
          FieldValidationConclusion.unknown,
        );

        final string = unknownResult.toString();

        expect(string, contains(expectedConclusion));
      },
    );

    test(
      ".toString() contains the given additional context",
      () {
        final result = FieldValidationResult.success(field, additionalContext);
        final string = result.toString();

        expect(string, contains(additionalContext));
      },
    );

    test(
      ".toString() does not contain additional context if the given additional context is null",
      () {
        final result = FieldValidationResult.success(field, null);
        final string = result.toString();

        final containsAdditionalContext = string.contains(
          'Additional context:',
        );

        expect(containsAdditionalContext, isFalse);
      },
    );
  });
}
