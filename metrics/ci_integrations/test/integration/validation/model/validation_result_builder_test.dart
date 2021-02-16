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

    final fieldResult = FieldValidationResult.success();
    final anotherFieldResult = FieldValidationResult.failure();

    final results = {
      firstField: fieldResult,
      anotherField: anotherFieldResult,
    };

    final fields = [
      firstField,
      anotherField,
    ];

    ValidationResultBuilder builder = ValidationResultBuilder.forFields(fields);

    tearDown(() {
      builder = ValidationResultBuilder.forFields(fields);
    });

    test(
      ".forFields() throws an argument error if the given fields is null",
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
        builder.setResult(firstField, fieldResult);

        final result = builder.build();
        final validationResults = result.results;

        expect(validationResults, containsPair(firstField, fieldResult));
      },
    );

    test(
      ".setEmptyResults() sets the null field validation results to the given result",
      () {
        builder.setEmptyResults(fieldResult);

        final result = builder.build();
        final fieldValidationResults = result.results.values;

        expect(fieldValidationResults, everyElement(equals(fieldResult)));
      },
    );

    test(
      ".setEmptyResults() does not override the non-null field validation results",
      () {
        builder.setResult(firstField, anotherFieldResult);

        builder.setEmptyResults(fieldResult);

        final result = builder.build();
        final validationResults = result.results;

        expect(validationResults, containsPair(firstField, anotherFieldResult));
      },
    );

    test(
      ".build() sets the null field validation results to unknown field validation results",
      () {
        final result = builder.build();
        final fieldValidationResults = result.results.values;

        expect(
          fieldValidationResults,
          everyElement(
            predicate((element) {
              return element is FieldValidationResult && element.isUnknown;
            }),
          ),
        );
      },
    );

    test(
      ".build() returns a validation result with the given field validation results",
      () {
        builder.setResult(firstField, fieldResult);
        builder.setResult(anotherField, anotherFieldResult);

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
