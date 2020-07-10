import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/delete_project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/delete_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/project_checkbox_list_tile.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("DeleteProjectGroupDialog", () {
    const deleteProjectGroupDialogViewModel = DeleteProjectGroupDialogViewModel(
      id: 'id',
      name: 'name',
    );

    testWidgets(
      "changes the cursor style for the cancel button",
      (WidgetTester tester) async {
        final notifierMock = ProjectGroupsNotifierMock();

        when(notifierMock.deleteProjectGroupDialogViewModel).thenReturn(
          deleteProjectGroupDialogViewModel,
        );
        await tester.pumpWidget(_DeleteProjectGroupDialogTestbed(
          projectGroupsNotifier: notifierMock,
        ));

        final finder = find.ancestor(
          of: find.text(CommonStrings.cancel),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "changes the cursor style for the delete button",
      (WidgetTester tester) async {
        final notifierMock = ProjectGroupsNotifierMock();

        when(notifierMock.deleteProjectGroupDialogViewModel).thenReturn(
          deleteProjectGroupDialogViewModel,
        );
        await tester.pumpWidget(_DeleteProjectGroupDialogTestbed(
          projectGroupsNotifier: notifierMock,
        ));

        final finder = find.ancestor(
          of: find.text(ProjectGroupsStrings.deleteProjectGroup),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );
  });
}

/// A testbed class required to test the [ProjectCheckboxListTile] widget.
class _DeleteProjectGroupDialogTestbed extends StatelessWidget {
  /// A [ProjectGroupsNotifier] that will be injected and used in tests.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// Creates a new instance of the [_DeleteProjectGroupDialogTestbed]
  /// with the given [projectGroupsNotifier].
  const _DeleteProjectGroupDialogTestbed({
    Key key,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MetricsThemedTestbed(
        body: DeleteProjectGroupDialog(),
      ),
    );
  }
}
