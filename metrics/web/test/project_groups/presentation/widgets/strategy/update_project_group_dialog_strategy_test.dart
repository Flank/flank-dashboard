import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:metrics/project_groups/presentation/widgets/strategy/update_project_group_dialog_strategy.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

void main() {
  group("UpdateProjectGroupDialogStrategy", () {
    final strategy = UpdateProjectGroupDialogStrategy();

    test(
      ".loadingText equals to ProjectGroupsStrings.savingProjectGroup",
      () {
        expect(
          strategy.loadingText,
          equals(ProjectGroupsStrings.savingProjectGroup),
        );
      },
    );

    test(".text equals to ProjectGroupString.saveChanges", () {
      expect(
        strategy.text,
        equals(ProjectGroupsStrings.saveChanges),
      );
    });

    test(".title equals to ProjectGroupString.editProjectGroup", () {
      expect(
        strategy.title,
        equals(ProjectGroupsStrings.editProjectGroup),
      );
    });

    test(
      ".action() delegates updating a project group to the given notifier",
      () {
        const id = 'groupId';
        const name = 'groupName';
        const projectIds = <String>[];
        final notifier = ProjectGroupNotifierMock();

        strategy.action(notifier, id, name, projectIds);

        verify(
          notifier.updateProjectGroup(id, name, projectIds),
        ).called(equals(1));
      },
    );
  });
}

class ProjectGroupNotifierMock extends Mock implements ProjectGroupsNotifier {}
