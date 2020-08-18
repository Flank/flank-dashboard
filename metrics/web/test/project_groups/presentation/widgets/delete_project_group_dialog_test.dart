import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_negative_button.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_neutral_button.dart';
import 'package:metrics/common/presentation/metrics_theme/model/delete_dialog_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/delete_project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/delete_project_group_dialog.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/finder_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("DeleteProjectGroupDialog", () {
    const deleteProjectGroupDialogViewModel = DeleteProjectGroupDialogViewModel(
      id: 'id',
      name: 'name',
    );

    const backgroundColor = Colors.yellow;
    const titleTextStyle = TextStyle(color: Colors.black);
    const contentTextStyle = TextStyle(inherit: false, color: Colors.red);

    const metricsThemeData = MetricsThemeData(
      deleteDialogTheme: DeleteDialogThemeData(
        backgroundColor: backgroundColor,
        titleTextStyle: titleTextStyle,
        contentTextStyle: contentTextStyle,
      ),
    );

    final themeData = ThemeData(
      textTheme: const TextTheme(bodyText1: contentTextStyle),
    );

    final contentStyle = themeData.textTheme.bodyText1
        .merge(metricsThemeData.deleteDialogTheme.contentTextStyle);

    final cancelButtonFinder = find.widgetWithText(
      MetricsNeutralButton,
      CommonStrings.cancel,
    );

    final deleteButtonFinder = find.widgetWithText(
      MetricsNegativeButton,
      ProjectGroupsStrings.delete,
    );

    List<TextSpan> _getContentTextSpans(WidgetTester tester) {
      final infoDialog = FinderUtil.findInfoDialog(tester);

      final content = infoDialog.content as RichText;
      final textSpan = content.text as TextSpan;
      return List<TextSpan>.from(textSpan.children);
    }

    testWidgets(
      "applies the close icon to the info dialog widget",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _DeleteProjectGroupDialogTestbed());
        });

        final infoDialog = FinderUtil.findInfoDialog(tester);

        final closeIconImage = infoDialog.closeIcon as Image;
        final closeIconNetworkImage = closeIconImage.image as NetworkImage;

        expect(closeIconNetworkImage.url, equals('icons/close.svg'));
      },
    );

    testWidgets(
      "applies the background color from the metrics theme",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _DeleteProjectGroupDialogTestbed(
            metricsThemeData: metricsThemeData,
          ));
        });

        final infoDialog = FinderUtil.findInfoDialog(tester);

        expect(infoDialog.backgroundColor, equals(backgroundColor));
      },
    );

    testWidgets(
      "displays the delete project group title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _DeleteProjectGroupDialogTestbed());
        });

        expect(
          find.text(ProjectGroupsStrings.deleteProjectGroup),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "applies the title style from the metrics theme",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _DeleteProjectGroupDialogTestbed(
            metricsThemeData: metricsThemeData,
          ));
        });

        final title = tester.widget<Text>(
          find.text(ProjectGroupsStrings.deleteProjectGroup),
        );

        expect(title.style, equals(titleTextStyle));
      },
    );

    testWidgets(
      "displays the delete confirmation text as the content of the info dialog widget",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _DeleteProjectGroupDialogTestbed());
        });

        final infoDialog = FinderUtil.findInfoDialog(tester);

        final content = infoDialog.content as RichText;
        final textSpan = content.text as TextSpan;

        expect(textSpan.text, equals(ProjectGroupsStrings.deleteConfirmation));
      },
    );

    testWidgets(
      "applies the content style from the metrics theme",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_DeleteProjectGroupDialogTestbed(
            themeData: themeData,
            metricsThemeData: metricsThemeData,
          ));
        });

        final infoDialog = FinderUtil.findInfoDialog(tester);

        final content = infoDialog.content as RichText;
        final textSpan = content.text as TextSpan;

        expect(textSpan.style, equals(contentStyle));
      },
    );

    testWidgets(
      "applies the delete confirmation question text as the content of the info dialog widget",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _DeleteProjectGroupDialogTestbed());
        });

        final contentTextSpan = _getContentTextSpans(tester);

        final confirmationTextFinder = contentTextSpan.any(
          (span) =>
              span.text == ProjectGroupsStrings.deleteConfirmationQuestion,
        );

        expect(confirmationTextFinder, isTrue);
      },
    );

    testWidgets(
      "applies the name of the deleting project group as the content of the info dialog widget",
      (tester) async {
        final notifierMock = ProjectGroupsNotifierMock();

        when(notifierMock.deleteProjectGroupDialogViewModel).thenReturn(
          deleteProjectGroupDialogViewModel,
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_DeleteProjectGroupDialogTestbed(
            projectGroupsNotifier: notifierMock,
          ));
        });

        final contentTextSpans = _getContentTextSpans(tester);

        final groupNameFinder = contentTextSpans.any(
          (span) => span.text == ' ${deleteProjectGroupDialogViewModel.name} ',
        );

        expect(groupNameFinder, isTrue);
      },
    );

    testWidgets(
      "applies the text style of the deleting project group name text from the metrics theme",
      (tester) async {
        final notifierMock = ProjectGroupsNotifierMock();

        when(notifierMock.deleteProjectGroupDialogViewModel).thenReturn(
          deleteProjectGroupDialogViewModel,
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_DeleteProjectGroupDialogTestbed(
            metricsThemeData: metricsThemeData,
            projectGroupsNotifier: notifierMock,
          ));
        });

        final boldContentStyle = contentStyle.copyWith(
          fontWeight: FontWeight.bold,
        );

        final contentTextSpans = _getContentTextSpans(tester);

        final groupNameSpan = contentTextSpans.firstWhere(
          (span) => span.text == ' ${deleteProjectGroupDialogViewModel.name} ',
          orElse: () => null,
        );

        expect(groupNameSpan?.style, equals(boldContentStyle));
      },
    );

    testWidgets(
      "displays the cancel metrics neutral button",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _DeleteProjectGroupDialogTestbed());
        });

        expect(cancelButtonFinder, findsOneWidget);
      },
    );

    testWidgets(
      "closes the dialog on tap on the cancel button",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _DeleteProjectGroupDialogTestbed());
        });

        await tester.tap(cancelButtonFinder);
        await tester.pumpAndSettle();

        expect(find.byType(DeleteProjectGroupDialog), findsNothing);
      },
    );

    testWidgets(
      "displays the delete metrics negative button",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _DeleteProjectGroupDialogTestbed());
        });

        expect(deleteButtonFinder, findsOneWidget);
      },
    );

    testWidgets(
      "deletes the project group on tap on the delete button",
      (tester) async {
        final notifierMock = ProjectGroupsNotifierMock();

        when(notifierMock.deleteProjectGroupDialogViewModel).thenReturn(
          deleteProjectGroupDialogViewModel,
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_DeleteProjectGroupDialogTestbed(
            projectGroupsNotifier: notifierMock,
          ));
        });

        await tester.tap(deleteButtonFinder);
        await tester.pump();

        verify(
          notifierMock.deleteProjectGroup(deleteProjectGroupDialogViewModel.id),
        ).called(equals(1));
      },
    );

    testWidgets(
      "displays the deleting project group text on tap on the delete button",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _DeleteProjectGroupDialogTestbed());
        });

        await tester.tap(deleteButtonFinder);
        await tester.pump();
        await tester.idle();

        expect(
          find.widgetWithText(
            MetricsNegativeButton,
            ProjectGroupsStrings.deletingProjectGroup,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "closes the dialog if the deletion was successful",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _DeleteProjectGroupDialogTestbed());
        });

        await tester.tap(deleteButtonFinder);
        await tester.pumpAndSettle();

        expect(find.byType(DeleteProjectGroupDialog), findsNothing);
      },
    );

    testWidgets(
      "does not close the dialog if the deletion finished with an error",
      (tester) async {
        final notifierMock = ProjectGroupsNotifierMock();

        when(notifierMock.deleteProjectGroupDialogViewModel).thenReturn(
          deleteProjectGroupDialogViewModel,
        );
        when(notifierMock.projectGroupSavingError).thenReturn('error');

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_DeleteProjectGroupDialogTestbed(
            projectGroupsNotifier: notifierMock,
          ));
        });

        await tester.tap(deleteButtonFinder);
        await tester.pumpAndSettle();

        expect(find.byType(DeleteProjectGroupDialog), findsOneWidget);
      },
    );

    testWidgets(
      "displays the delete project group button text if the deletion finished with an error",
      (tester) async {
        final notifierMock = ProjectGroupsNotifierMock();

        when(notifierMock.deleteProjectGroupDialogViewModel).thenReturn(
          deleteProjectGroupDialogViewModel,
        );
        when(notifierMock.projectGroupSavingError).thenReturn('error');

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_DeleteProjectGroupDialogTestbed(
            projectGroupsNotifier: notifierMock,
          ));
        });

        await tester.tap(deleteButtonFinder);
        await tester.pumpAndSettle();

        expect(deleteButtonFinder, findsOneWidget);
      },
    );
  });
}

/// A testbed class required to test the [DeleteProjectGroupDialog] widget.
class _DeleteProjectGroupDialogTestbed extends StatelessWidget {
  /// A [ProjectGroupsNotifier] that will be injected and used in tests.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// The [MetricsThemeData] used in testbed.
  final MetricsThemeData metricsThemeData;

  /// The [ThemeData] used in testbed.
  final ThemeData themeData;

  /// Creates a new instance of the [_DeleteProjectGroupDialogTestbed]
  /// with the given [projectGroupsNotifier], [metricsThemeData]
  /// and [themeData].
  ///
  /// The [metricsThemeData] defaults to an empty [MetricsThemeData].
  const _DeleteProjectGroupDialogTestbed({
    Key key,
    this.projectGroupsNotifier,
    this.metricsThemeData = const MetricsThemeData(),
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MetricsThemedTestbed(
        metricsThemeData: metricsThemeData,
        themeData: themeData,
        body: DeleteProjectGroupDialog(),
      ),
    );
  }
}
