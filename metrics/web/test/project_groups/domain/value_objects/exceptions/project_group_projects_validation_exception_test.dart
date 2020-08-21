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
      const errorCode = ProjectGroupProjectsValidationErrorCode
          .maxProjectsLimitExceeded;

      final expectedValidationException = ProjectGroupProjectsValidationException(
        errorCode,
      );

      expect(expectedValidationException.code, equals(errorCode));
    });
  });
}
