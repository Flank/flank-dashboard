// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectGroupsStrings", () {
    const count = 2;
    const projectGroupName = 'project group name';

    test(
      ".getProjectsCount() returns a message that contains the given count",
      () {
        expect(
          ProjectGroupsStrings.getProjectsCount(count),
          contains('$count'),
        );
      },
    );

    test(
      ".getSelectedCount() returns a message that contains the given count",
      () {
        expect(
          ProjectGroupsStrings.getSelectedCount(count),
          contains('$count'),
        );
      },
    );

    test(
      ".getProjectGroupNameLimitExceeded() returns a message that contains the given count",
      () {
        expect(
          ProjectGroupsStrings.getProjectGroupNameLimitExceeded(count),
          contains('$count'),
        );
      },
    );

    test(
      ".getProjectsLimitExceeded() returns a message that contains the given count",
      () {
        expect(
          ProjectGroupsStrings.getProjectsLimitExceeded(count),
          contains('$count'),
        );
      },
    );

    test(
      ".getCreatedProjectGroupMessage() returns a message that contains the given project group name",
      () {
        expect(
          ProjectGroupsStrings.getCreatedProjectGroupMessage(projectGroupName),
          contains(projectGroupName),
        );
      },
    );

    test(
      ".getEditedProjectGroupMessage() returns a message that contains the given project group name",
      () {
        expect(
          ProjectGroupsStrings.getEditedProjectGroupMessage(projectGroupName),
          contains(projectGroupName),
        );
      },
    );

    test(
      ".getDeletedProjectGroupMessage() returns a message that contains the given project group name",
      () {
        expect(
          ProjectGroupsStrings.getDeletedProjectGroupMessage(projectGroupName),
          contains(projectGroupName),
        );
      },
    );
  });
}
