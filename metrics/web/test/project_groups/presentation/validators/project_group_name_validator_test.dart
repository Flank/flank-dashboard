import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/validators/project_group_name_validator.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupNameValidator", () {
    const expectedErrorMessage = ProjectGroupsStrings.projectGroupNameRequired;

    test(
      ".validate() returns the project group name required error message if the given value is null",
      () {
        final actualErrorMessage = ProjectGroupNameValidator.validate(null);

        expect(actualErrorMessage, equals(expectedErrorMessage));
      },
    );

    test(
      ".validate() returns the project group name required error message if the given value is an empty string",
      () {
        final actualErrorMessage = ProjectGroupNameValidator.validate('');

        expect(actualErrorMessage, equals(expectedErrorMessage));
      },
    );

    test(
      ".validate() returns null if the given value is valid",
      () {
        final actualErrorMessage = ProjectGroupNameValidator.validate('name');

        expect(actualErrorMessage, isNull);
      },
    );
  });
}
