import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_dialog.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/project_selector_list.dart';
import '../../../test_utils/project_group_notifier_stub.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectGroupDialog", () {
    testWidgets(
      "contains the MetricsDialog widget",
      (tester) async {
        final projectGroupNotifier = ProjectGroupsNotifierStub();

        await tester.pumpWidget(_ProjectGroupDialogTestbed(
          projectGroupsNotifier: projectGroupNotifier,
        ));

        expect(find.byType(MetricsDialog), findsOneWidget);
      },
    );

    testWidgets(
      "contains the MetricsTextFormField widget",
      (tester) async {
        final projectGroupNotifier = ProjectGroupsNotifierStub();

        await tester.pumpWidget(_ProjectGroupDialogTestbed(
          projectGroupsNotifier: projectGroupNotifier,
        ));

        expect(find.byType(MetricsTextFormField), findsOneWidget);
      },
    );

    testWidgets(
      "contains the ProjectSelectorList widget",
      (tester) async {
        final projectGroupNotifier = ProjectGroupsNotifierStub();

        await tester.pumpWidget(_ProjectGroupDialogTestbed(
          projectGroupsNotifier: projectGroupNotifier,
        ));

        expect(find.byType(ProjectSelectorList), findsOneWidget);
      },
    );

    testWidgets(
      "contains a different title, according to the active view model id",
      (tester) async {
        final projectGroupNotifier = ProjectGroupsNotifierStub();

        await tester.pumpWidget(_ProjectGroupDialogTestbed(
          projectGroupsNotifier: projectGroupNotifier,
        ));

        projectGroupNotifier.generateActiveProjectGroupViewModel();

        await tester.pump();

        expect(
          find.widgetWithText(
            ProjectGroupDialog,
            ProjectGroupsStrings.addProjectGroup,
          ),
          findsOneWidget,
        );

        projectGroupNotifier.generateActiveProjectGroupViewModel('id');

        await tester.pump();

        expect(
          find.widgetWithText(
            ProjectGroupDialog,
            ProjectGroupsStrings.editProjectGroup,
          ),
          findsOneWidget,
        );
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
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MaterialApp(
        home: Scaffold(
          body: ProjectGroupDialog(),
        ),
      ),
    );
  }
}
