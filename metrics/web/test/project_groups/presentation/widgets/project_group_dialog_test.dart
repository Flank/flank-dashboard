import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/strategy/project_group_dialog_strategy.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectGroupDialog", () {
    const title = 'title';
    const buttonText = 'testText';

    testWidgets(
      "applies a hand cursor to the project group dialog action button",
      (WidgetTester tester) async {
        final projectGroup = ProjectGroupDialogViewModel(
          id: 'id',
          name: 'name',
          selectedProjectIds: UnmodifiableListView([]),
        );
        final notifierMock = ProjectGroupsNotifierMock();
        final strategyMock = ProjectGroupDialogStrategyMock();

        when(notifierMock.projectGroupDialogViewModel).thenReturn(projectGroup);
        when(strategyMock.title).thenReturn(title);
        when(strategyMock.text).thenReturn(buttonText);

        await tester.pumpWidget(_ProjectGroupDialogTestbed(
          projectGroupsNotifier: notifierMock,
          strategy: strategyMock,
        ));

        final finder = find.ancestor(
          of: find.text(buttonText),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );
  });
}

/// A testbed class required to test the [ProjectGroupDialog] widget.
class _ProjectGroupDialogTestbed extends StatelessWidget {
  /// A [ProjectGroupsNotifier] that will be injected and used in tests.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// A [ProjectGroupDialogStrategy] strategy applied to this dialog.
  final ProjectGroupDialogStrategy strategy;

  /// Creates a new instance of the [_ProjectGroupDialogTestbed]
  /// with the given [strategy] and [projectGroupsNotifier].
  const _ProjectGroupDialogTestbed({
    Key key,
    this.strategy,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MetricsThemedTestbed(
        body: ProjectGroupDialog(
          strategy: strategy,
        ),
      ),
    );
  }
}

class ProjectGroupDialogStrategyMock extends Mock
    implements ProjectGroupDialogStrategy {}
