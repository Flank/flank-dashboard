import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_project_ids_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_project_ids.dart';
import 'package:metrics/project_groups/presentation/models/project_group_project_ids_validation_error_message.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupProjectIdsValidationErrorMessage", () {
    test(".message returns null if the given code is null", () {
      const errorMessage = ProjectGroupProjectIdsValidationErrorMessage(null);

      expect(errorMessage.message, isNull);
    });

    test(
      ".message returns project group project ids size limit exceeded if the given code is ProjectGroupProjectIdsValidationErrorCode.projectsSelectionLimitExceeded",
      () {
        const errorMessage = ProjectGroupProjectIdsValidationErrorMessage(
          ProjectGroupProjectIdsValidationErrorCode
              .projectsSelectionLimitExceeded,
        );

        expect(
          errorMessage.message,
          ProjectGroupsStrings.getProjectSelectionError(
            ProjectGroupProjectIds.projectIdsSelectionSizeLimit,
          ),
        );
      },
    );
  });
}
