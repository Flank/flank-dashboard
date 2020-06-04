import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_dialog.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';

import '../../../test_utils/new_test_injection_container.dart';
import '../../../test_utils/project_group_notifier_stub.dart';

void main() {
  group("ProjectGroupDialog", () {
    testWidgets(
      "contains MetricsDialog widget",
      (tester) async {
        final projectGroupNotifier = ProjectGroupsNotifierStub();

        await tester.pumpWidget(_ProjectGroupDialogTestbed(
          projectGroupsNotifier: projectGroupNotifier,
        ));        

        expect(find.byType(MetricsDialog), findsOneWidget);
      },
    );

    testWidgets(
      "contains MetricsDialog widget",
      (tester) async {
        await tester.pumpWidget(const _ProjectGroupDialogTestbed());

        expect(find.byType(MetricsDialog), findsOneWidget);
      },
    );
  });
}

/// A testbed widget used to test the [ProjectGroupDialog] widget.
class _ProjectGroupDialogTestbed extends StatelessWidget {
  /// A [ProjectGroupsNotifier] that will injected and used in tests.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// Creates the [_ProjectGroupDeleteDialogTestbed] with the given [projectGroupsNotifier].
  const _ProjectGroupDialogTestbed({
    Key key,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewTestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MaterialApp(
        home: Scaffold(
          body: ProjectGroupDialog(),
        ),
      ),
    );
  }
}
