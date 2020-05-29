// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_error_code.dart';
import 'package:metrics/project_groups/presentation/model/project_group_validation_error_message.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupNameValidationErrorMessage", () {
    test(
      "maps the 'isNull' error code to 'projectGroupNameRequired' error message",
      () {
        final errorMessage = ProjectGroupNameValidationErrorMessage(
          ProjectGroupNameValidationErrorCode.isNull,
        );

        expect(
          errorMessage.message,
          ProjectGroupsStrings.projectGroupNameRequired,
        );
      },
    );
  });
}
