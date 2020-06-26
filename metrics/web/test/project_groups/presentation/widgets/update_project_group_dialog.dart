import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/project_groups/presentation/widgets/strategy/update_project_group_dialog_strategy.dart';
import 'package:metrics/project_groups/presentation/widgets/update_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("UpdateProjectGroupDialog", () {
    testWidgets(
      "displays the ProjectGroupDialog with the update project group strategy",
      (WidgetTester tester) async {
        await tester.pumpWidget(_UpdateProjectGroupDialogTestbed());

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
  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: UpdateProjectGroupDialog(),
    );
  }
}
