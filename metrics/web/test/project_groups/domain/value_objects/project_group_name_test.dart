// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_exception.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_name.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupName", () {
    const String name = 'projectGroupName';

    test(
      "throws a ProjectGroupNameValidationException with isNull error code when the value is a string with empty spaces",
      () {
        final projectGroupNameIsNullException =
            ProjectGroupNameValidationException(
          ProjectGroupNameValidationErrorCode.isNull,
        );

        expect(
          () => ProjectGroupName(' '),
          throwsA(equals(projectGroupNameIsNullException)),
        );
      },
    );

    test(
      "throws a ProjectGroupNameValidationException with isNull error code when the value is null",
      () {
        final projectGroupNameIsNullException =
            ProjectGroupNameValidationException(
          ProjectGroupNameValidationErrorCode.isNull,
        );

        expect(
          () => ProjectGroupName(null),
          throwsA(equals(projectGroupNameIsNullException)),
        );
      },
    );

    test(
      "throws a ProjectGroupNameValidationException with charactersLimitExceeded error code when the value is greater then max limit",
      () {
        final projectGroupNameException = ProjectGroupNameValidationException(
          ProjectGroupNameValidationErrorCode.charactersLimitExceeded,
        );

        expect(
          () => ProjectGroupName(
            List.generate(255, (index) => index).toString(),
          ),
          throwsA(equals(projectGroupNameException)),
        );
      },
    );

    test(
      "successfully creates an instance with the given value",
      () {
        final projectGroupName = ProjectGroupName(name);

        expect(projectGroupName.value, equals(name));
      },
    );

    test(
      "equals to another ProjectGroupName if their values are the same",
      () {
        final firstProjectGroupName = ProjectGroupName(name);
        final secondProjectGroupName = ProjectGroupName(name);

        expect(firstProjectGroupName, equals(secondProjectGroupName));
      },
    );
  });
}
