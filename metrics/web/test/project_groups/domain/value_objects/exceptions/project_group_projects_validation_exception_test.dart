// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_projects_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_projects_validation_exception.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupProjectsValidationException", () {
    test(
      "throws an ArgumentError if the given code is null",
      () {
        expect(
          () => ProjectGroupProjectsValidationException(null),
          throwsArgumentError,
        );
      },
    );

    test("successfully creates with the given error code", () {
      const expectedErrorCode =
          ProjectGroupProjectsValidationErrorCode.maxProjectsLimitExceeded;

      final validationException = ProjectGroupProjectsValidationException(
        expectedErrorCode,
      );

      expect(validationException.code, equals(expectedErrorCode));
    });
  });
}
