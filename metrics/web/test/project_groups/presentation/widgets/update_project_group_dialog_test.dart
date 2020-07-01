import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/edit_project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/strategy/update_project_group_dialog_strategy.dart';
import 'package:metrics/project_groups/presentation/widgets/update_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("UpdateProjectGroupDialog", () {
    testWidgets(
      "displays the ProjectGroupDialog with the update project group strategy",
      (WidgetTester tester) async {
        const projectGroup = EditProjectGroupDialogViewModel(
          id: 'id',
          name: 'name',
        );
        final notifierMock = ProjectGroupsNotifierMock();
        when(notifierMock.projectGroupDialogViewModel).thenReturn(projectGroup);

        await tester.pumpWidget(_UpdateProjectGroupDialogTestbed(
          projectGroupsNotifier: notifierMock,
        ));

        final projectDialog = tester.widget<ProjectGroupDialog>(
          find.byType(ProjectGroupDialog),
        );
        final strategy = projectDialog?.strategy;

        expect(strategy, isNotNull);
        expect(strategy, isA<UpdateProjectGroupDialogStrategy>());
      },
    );
  });
}

/// A testbed class required for testing the [UpdateProjectGroupDialog].
class _UpdateProjectGroupDialogTestbed extends StatelessWidget {
  /// A [ProjectGroupsNotifier] that will be injected and used in tests.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// Creates a new instance of the [_UpdateProjectGroupDialogTestbed]
  /// with the given [projectGroupsNotifier].
  const _UpdateProjectGroupDialogTestbed({
    Key key,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MetricsThemedTestbed(
        body: UpdateProjectGroupDialog(),
      ),
    );
  }
}
