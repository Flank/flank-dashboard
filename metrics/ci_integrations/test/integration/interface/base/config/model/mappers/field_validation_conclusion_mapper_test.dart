// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/field_validation_conclusion.dart';
import 'package:ci_integration/integration/interface/base/config/model/mappers/field_validation_conclusion_mapper.dart';
import 'package:test/test.dart';

void main() {
  group("FieldValidationConclusionMapper", () {
    const mapper = FieldValidationConclusionMapper();

    test(
      ".map() maps the valid conclusion to the FieldValidationConclusion.valid",
      () {
        const expectedConclusion = FieldValidationConclusion.valid;

        final conclusion = mapper.map(FieldValidationConclusionMapper.valid);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the invalid conclusion to the FieldValidationConclusion.invalid",
      () {
        const expectedConclusion = FieldValidationConclusion.invalid;

        final conclusion = mapper.map(FieldValidationConclusionMapper.invalid);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the unknown conclusion to the FieldValidationConclusion.unknown",
      () {
        const expectedConclusion = FieldValidationConclusion.unknown;

        final conclusion = mapper.map(FieldValidationConclusionMapper.unknown);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the non existing conclusion to null",
      () {
        final conclusion = mapper.map('test');

        expect(conclusion, isNull);
      },
    );

    test(
      ".map() returns null if the given conclusion is null",
      () {
        final conclusion = mapper.map(null);

        expect(conclusion, isNull);
      },
    );

    test(
      ".unmap() unmaps the FieldValidationConclusion.valid to the the valid conclusion",
      () {
        const expectedConclusion = FieldValidationConclusionMapper.valid;

        final conclusion = mapper.unmap(FieldValidationConclusion.valid);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the FieldValidationConclusion.invalid to the the invalid conclusion",
      () {
        const expectedConclusion = FieldValidationConclusionMapper.invalid;

        final conclusion = mapper.unmap(FieldValidationConclusion.invalid);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the FieldValidationConclusion.unknown to the the unknown conclusion",
      () {
        const expectedConclusion = FieldValidationConclusionMapper.unknown;

        final conclusion = mapper.unmap(FieldValidationConclusion.unknown);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() returns null if the given conclusion is null",
      () {
        final conclusion = mapper.unmap(null);

        expect(conclusion, isNull);
      },
    );
  });
}
