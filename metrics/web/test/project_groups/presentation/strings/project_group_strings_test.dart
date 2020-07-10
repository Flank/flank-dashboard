import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:test/test.dart';

void main() {
  group('ProjectGroupsStrings', () {
    const count = 2;

    test(
      ".getDeleteTextConfirmation() returns a message that contains the given name",
      () {
        const name = "name";

        expect(
          ProjectGroupsStrings.getDeleteTextConfirmation(name),
          contains(name),
        );
      },
    );

    test(
      ".getProjectsCount() returns a message that contains the given count",
      () {
        expect(
          ProjectGroupsStrings.getProjectsCount(count),
          contains(count.toString()),
        );
      },
    );

    test(".getSelectedCount() returns a message that contains the given count",
        () {
      expect(
        ProjectGroupsStrings.getSelectedCount(count),
        contains(count.toString()),
      );
    });
  });
}
