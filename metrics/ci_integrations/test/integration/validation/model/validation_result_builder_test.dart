// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';
import 'package:test/test.dart';

import '../../../test_utils/config_field_stub.dart';

void main() {
  group("ValidationResultBuilder", () {
    final firstField = ConfigFieldStub('1');
    final anotherField = ConfigFieldStub('2');

    final successResult = FieldValidationResult.success();
    final failureResult = FieldValidationResult.failure();

    final results = {
      firstField: successResult,
      anotherField: failureResult,
    };

    final fields = [
      firstField,
      anotherField,
    ];

    ValidationResultBuilder builder = ValidationResultBuilder.forFields(fields);

    setUp(() {
      builder = ValidationResultBuilder.forFields(fields);
    });

    test(
      ".forFields() throws an ArgumentError if the given fields is null",
      () {
        expect(
          () => ValidationResultBuilder.forFields(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".forFields() successfully creates an instance with the given fields",
      () {
        expect(
          () => ValidationResultBuilder.forFields(fields),
          returnsNormally,
        );
      },
    );

    test(
      ".setResult() throws an ArgumentError if the field is not available",
      () {
        final nonAvailableField = ConfigFieldStub('non available');

        expect(
          () => builder.setResult(
            nonAvailableField,
            FieldValidationResult.success(),
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".setResult() sets the given field validation result to the given field",
      () {
        builder.setResult(firstField, successResult);
        builder.setResult(anotherField, failureResult);

        final result = builder.build();
        final validationResults = result.results;

        expect(validationResults, containsPair(firstField, successResult));
        expect(validationResults, containsPair(anotherField, failureResult));
      },
    );

    test(
      ".setEmptyResults() sets the empty field validation results to the given result",
      () {
        builder.setEmptyResults(successResult);

        final result = builder.build();
        final fieldValidationResults = result.results.values;

        expect(fieldValidationResults, everyElement(equals(successResult)));
      },
    );

    test(
      ".setEmptyResults() does not override the non-empty field validation results",
      () {
        builder.setResult(firstField, failureResult);

        builder.setEmptyResults(successResult);

        final result = builder.build();
        final validationResults = result.results;

        expect(validationResults, containsPair(firstField, failureResult));
      },
    );

    test(
      ".build() throws a StateError if there are fields with not specified validation result",
      () {
        expect(
          () => builder.build(),
          throwsStateError,
        );
      },
    );

    test(
      ".build() throws a StateError with a message that contains field names with not specified validation result",
      () {
        final emptyFields = [firstField, anotherField];

        expect(
          () => builder.build(),
          throwsA(
            predicate<StateError>(
              (error) {
                return emptyFields.every(
                  (emptyField) => error.message.contains('$emptyField'),
                );
              },
            ),
          ),
        );
      },
    );

    test(
      ".build() returns a validation result containing validation results that were set",
      () {
        builder.setResult(firstField, successResult);
        builder.setResult(anotherField, failureResult);

        final result = builder.build();
        final validationResults = result.results;

        expect(
          validationResults,
          equals(results),
        );
      },
    );
  });
}
