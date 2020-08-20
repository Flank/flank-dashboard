import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_project_ids_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_project_ids_validation_exception.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupProjectIdsValidationException", () {
    test(
      "throws an ArgumentError if the given code is null",
      () {
        expect(
          () => ProjectGroupProjectIdsValidationException(null),
          throwsArgumentError,
        );
      },
    );

    test("successfully creates with the given error code", () {
      const errorCode = ProjectGroupProjectIdsValidationErrorCode
          .projectsSelectionLimitExceeded;

      final validationException = ProjectGroupProjectIdsValidationException(
        errorCode,
      );

      expect(validationException.code, equals(errorCode));
    });
  });
}
