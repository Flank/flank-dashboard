import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_dialog.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_delete_dialog.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/project_group_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectGroupDeleteDialog", () {
    testWidgets(
      "contains MetricsDialog widget",
      (tester) async {
        await tester.pumpWidget(const _ProjectGroupDeleteDialogTestbed());

        expect(find.byType(MetricsDialog), findsOneWidget);
      },
    );

    testWidgets("displays the confirmation text", (tester) async {
      await tester.pumpWidget(const _ProjectGroupDeleteDialogTestbed());

      final text = ProjectGroupsStrings.getDeleteTextConfirmation(
        _ProjectGroupDeleteDialogTestbed.projectGroupName,
      );

      expect(find.text(text), findsOneWidget);
    });

    testWidgets("contains a cancel button", (tester) async {
      await tester.pumpWidget(const _ProjectGroupDeleteDialogTestbed());

      expect(
        find.widgetWithText(FlatButton, CommonStrings.cancel),
        findsOneWidget,
      );
    });

    testWidgets("contains a delete button", (tester) async {
      await tester.pumpWidget(const _ProjectGroupDeleteDialogTestbed());

      expect(
        find.widgetWithText(
          RaisedButton,
          ProjectGroupsStrings.deleteProjectGroup,
        ),
        findsOneWidget,
      );
    });

    testWidgets("text on delete button changes after it was tapped",
        (tester) async {
      final projectGroupNotifierMock = ProjectGroupsNotifierMock();

      await tester.pumpWidget(_ProjectGroupDeleteDialogTestbed(
        projectGroupsNotifier: projectGroupNotifierMock,
      ));

      when(projectGroupNotifierMock.deleteProjectGroup(any)).thenAnswer(
        (_) => Future.value(true),
      );

      await tester.tap(
        find.widgetWithText(
          RaisedButton,
          ProjectGroupsStrings.deleteProjectGroup,
        ),
      );

      await tester.pump();

      expect(
        find.widgetWithText(
          RaisedButton,
          ProjectGroupsStrings.deletingProjectGroup,
        ),
        findsOneWidget,
      );
    });

    testWidgets("closes if deleteProjectGroup method returns true",
        (tester) async {
      final projectGroupNotifierMock = ProjectGroupsNotifierMock();

      await tester.pumpWidget(_ProjectGroupDeleteDialogTestbed(
        projectGroupsNotifier: projectGroupNotifierMock,
      ));

      when(projectGroupNotifierMock.deleteProjectGroup(any)).thenAnswer(
        (_) => Future.value(true),
      );

      await tester.tap(
        find.widgetWithText(
          RaisedButton,
          ProjectGroupsStrings.deleteProjectGroup,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MetricsDialog), findsNothing);
    });

    testWidgets("does not close if deleteProjectGroup method returns false",
        (tester) async {
      final projectGroupNotifierMock = ProjectGroupsNotifierMock();

      await tester.pumpWidget(_ProjectGroupDeleteDialogTestbed(
        projectGroupsNotifier: projectGroupNotifierMock,
      ));

      when(projectGroupNotifierMock.deleteProjectGroup(any)).thenAnswer(
        (_) => Future.value(false),
      );

      await tester.tap(
        find.widgetWithText(
          RaisedButton,
          ProjectGroupsStrings.deleteProjectGroup,
        ),
      );

      await tester.pump();

      expect(find.byType(MetricsDialog), findsOneWidget);
    });
  });
}

/// A testbed widget used to test the [ProjectGroupDeleteDialog] widget.
class _ProjectGroupDeleteDialogTestbed extends StatelessWidget {
  static String projectGroupId = 'id';
  static String projectGroupName = 'name';

  /// A [ProjectGroupsNotifier] that will injected and used in tests.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// Creates the [_ProjectGroupDeleteDialogTestbed] with the given [projectGroupsNotifier].
  const _ProjectGroupDeleteDialogTestbed({
    Key key,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MaterialApp(
        home: Scaffold(
          body: ProjectGroupDeleteDialog(
            projectGroupId: projectGroupId,
            projectGroupName: projectGroupName,
          ),
        ),
      ),
    );
  }
}
