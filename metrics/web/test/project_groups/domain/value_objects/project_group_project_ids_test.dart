import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_project_ids_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_project_ids_validation_exception.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_project_ids.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupProjectIds", () {
    const List<String> projectIds = ['projectId'];

    test(
      "throws a ProjectGroupProjectIdsValidationException with projectsSelectionLimitExceeded error code when the value length exceeds the selection limit",
      () {
        final validationException = ProjectGroupProjectIdsValidationException(
          ProjectGroupProjectIdsValidationErrorCode
              .projectsSelectionLimitExceeded,
        );

        final projectIds = List.generate(
            ProjectGroupProjectIds.projectIdsSelectionSizeLimit + 1,
            (index) => index.toString()).toList();

        expect(
          () => ProjectGroupProjectIds(projectIds),
          throwsA(equals(validationException)),
        );
      },
    );

    test(
      "successfully creates an instance with the given value",
      () {
        final projectGroupProjectIds = ProjectGroupProjectIds(projectIds);

        expect(projectGroupProjectIds.value, equals(projectIds));
      },
    );

    test(
      "equals to another ProjectGroupName if their values are the same",
      () {
        final firstProjectGroupProjectIds = ProjectGroupProjectIds(projectIds);
        final secondProjectGroupProjectIds = ProjectGroupProjectIds(projectIds);

        expect(
          firstProjectGroupProjectIds,
          equals(secondProjectGroupProjectIds),
        );
      },
    );
  });
}
