import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/strategy/add_project_group_dialog_strategy.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("AddProjectGroupDialog", () {
    testWidgets(
      "displays the ProjectGroupDialog with the add project group strategy",
      (tester) async {
        await tester.pumpWidget(_AddProjectGroupDialogTestbed());

        final projectDialog = tester.widget<ProjectGroupDialog>(
          find.byType(ProjectGroupDialog),
        );
        final strategy = projectDialog?.strategy;

        expect(strategy, isNotNull);
        expect(strategy, isA<AddProjectGroupDialogStrategy>());
      },
    );
  });
}

/// A testbed class required for testing the [AddProjectGroupDialog].
class _AddProjectGroupDialogTestbed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: AddProjectGroupDialog(),
    );
  }
}
