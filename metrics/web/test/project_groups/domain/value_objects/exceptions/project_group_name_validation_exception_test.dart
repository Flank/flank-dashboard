import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_exception.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupNameValidationException", () {
    test(
      "throws an ArgumentError if the given code is null",
      () {
        expect(
          () => ProjectGroupNameValidationException(null),
          throwsArgumentError,
        );
      },
    );

    test("successfully creates with the given error code", () {
      const errorCode = ProjectGroupNameValidationErrorCode.isNull;

      final validationException =
          ProjectGroupNameValidationException(errorCode);

      expect(validationException.code, equals(errorCode));
    });
  });
}
