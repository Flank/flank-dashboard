// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_name.dart';
import 'package:metrics/project_groups/presentation/models/project_group_name_validation_error_message.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupNameValidationErrorMessage", () {
    test(".message returns null if the given code is null", () {
      const errorMessage = ProjectGroupNameValidationErrorMessage(null);

      expect(errorMessage.message, isNull);
    });

    test(
      ".message returns project group name required error message if the given code is ProjectGroupNameValidationErrorCode.isNull",
      () {
        const errorMessage = ProjectGroupNameValidationErrorMessage(
          ProjectGroupNameValidationErrorCode.isNull,
        );

        expect(
          errorMessage.message,
          ProjectGroupsStrings.projectGroupNameRequired,
        );
      },
    );

    test(
      ".message returns project group name limit exceeded if the given code is ProjectGroupNameValidationErrorCode.charactersLimitExceeded",
      () {
        const errorMessage = ProjectGroupNameValidationErrorMessage(
          ProjectGroupNameValidationErrorCode.charactersLimitExceeded,
        );

        expect(
          errorMessage.message,
          ProjectGroupsStrings.getProjectGroupNameLimitExceeded(
            ProjectGroupName.charactersLimit,
          ),
        );
      },
    );
  });
}
