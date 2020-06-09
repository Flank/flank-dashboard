import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/validators/project_group_name_validator.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupNameValidator", () {
    test(
      ".validate() returns the project group name required error message if the given value is null",
      () {
        final validationResult =
            ProjectGroupNameValidator.validate(null);

        expect(
          validationResult,
          equals(ProjectGroupsStrings.projectGroupNameRequired),
        );
      },
    );

    test(
      ".validate() returns null if the given value is valid",
      () {
        final validationResult =
            ProjectGroupNameValidator.validate('name');

        expect(validationResult, isNull);
      },
    );
  });
}
