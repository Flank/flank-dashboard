import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/util/project_group_validation_util.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupValidationUtil", () {
    test(
      ".validateProjectGroupName() returns the project group name required error message if the given value is null",
      () {
        final validationResult =
            ProjectGroupValidationUtil.validateProjectGroupName(null);

        expect(
          validationResult,
          equals(ProjectGroupsStrings.projectGroupNameRequired),
        );
      },
    );

    test(
      ".validateProjectGroupName() returns null if the given value is valid",
      () {
        final validationResult =
            ProjectGroupValidationUtil.validateProjectGroupName('name');

        expect(validationResult, isNull);
      },
    );
  });
}
