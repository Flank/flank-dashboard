// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_projects_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_projects.dart';
import 'package:metrics/project_groups/presentation/models/project_group_projects_validation_error_message.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupProjectsValidationErrorMessage", () {
    test(".message returns null if the given code is null", () {
      const errorMessage = ProjectGroupProjectsValidationErrorMessage(null);

      expect(errorMessage.message, isNull);
    });

    test(
      ".message returns the projects limit exceeded message if the given code is ProjectGroupProjectsValidationErrorCode.maxProjectsLimitExceeded",
      () {
        const errorMessage = ProjectGroupProjectsValidationErrorMessage(
          ProjectGroupProjectsValidationErrorCode.maxProjectsLimitExceeded,
        );

        expect(
          errorMessage.message,
          ProjectGroupsStrings.getProjectsLimitExceeded(
            ProjectGroupProjects.maxNumberOfProjects,
          ),
        );
      },
    );
  });
}
