import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_projects_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_projects_validation_exception.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_projects.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupProjects", () {
    const List<String> projectIds = ['projectId'];

    test(
      "throws a ProjectGroupProjectsValidationException with projectsSelectionLimitExceeded error code when the value length exceeds the selection limit",
      () {
        final validationException = ProjectGroupProjectsValidationException(
          ProjectGroupProjectsValidationErrorCode
              .maxProjectsLimitExceeded,
        );

        final projectIds = List.generate(
            ProjectGroupProjects.maxNumberOfProjects + 1,
            (index) => index.toString()).toList();

        expect(
          () => ProjectGroupProjects(projectIds),
          throwsA(equals(validationException)),
        );
      },
    );

    test(
      "successfully creates an instance with the valid value",
      () {
        final projectGroupProjects = ProjectGroupProjects(projectIds);

        expect(projectGroupProjects.value, equals(projectIds));
      },
    );

    test(
      "equals to another ProjectGroupName if their values are the same",
      () {
        final firstProjectGroupProjects = ProjectGroupProjects(projectIds);
        final secondProjectGroupProjects = ProjectGroupProjects(projectIds);

        expect(
          firstProjectGroupProjects,
          equals(secondProjectGroupProjects),
        );
      },
    );
  });
}
