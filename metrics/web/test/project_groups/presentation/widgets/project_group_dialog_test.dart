import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_positive_button.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_dialog_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/validators/project_group_name_validator.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_checkbox_list.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/strategy/project_group_dialog_strategy.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectGroupDialog", () {
    const title = 'title';
    const buttonText = 'testText';
    const loadingText = 'loading...';
    const backgroundColor = Colors.red;
    const contentBorderColor = Colors.yellow;
    const titleTextStyle = TextStyle(
      color: Colors.grey,
    );
    const counterTextStyle = TextStyle(
      color: Colors.blue,
    );

    final projectGroupDialogViewModel = ProjectGroupDialogViewModel(
      id: "id",
      name: "name",
      selectedProjectIds: UnmodifiableListView<String>([]),
    );

    const theme = MetricsThemeData(
      projectGroupDialogTheme: ProjectGroupDialogThemeData(
        backgroundColor: backgroundColor,
        contentBorderColor: contentBorderColor,
        titleTextStyle: titleTextStyle,
        counterTextStyle: counterTextStyle,
      ),
    );

    final strategy = ProjectGroupDialogStrategyMock();
    ProjectGroupsNotifier projectGroupsNotifier;

    setUp(() {
      when(strategy.title).thenReturn(title);
      when(strategy.text).thenReturn(buttonText);
      when(strategy.loadingText).thenReturn(loadingText);

      projectGroupsNotifier = ProjectGroupsNotifierMock();

      when(projectGroupsNotifier.projectGroupDialogViewModel)
          .thenReturn(projectGroupDialogViewModel);
    });

    tearDown(() {
      reset(strategy);
      reset(projectGroupsNotifier);
    });

    testWidgets(
      "throws an AssertionError if the given strategy is null",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ProjectGroupDialogTestbed(
            strategy: null,
          ));
        });

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies a hand cursor to the project group dialog action button",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
            strategy: strategy,
          ));
        });

        final finder = find.ancestor(
          of: find.text(buttonText),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the background color from the metrics theme",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            theme: theme,
            strategy: strategy,
          ));
        });

        final infoDialog = tester.widget<InfoDialog>(
          find.byType(InfoDialog),
        );

        expect(infoDialog.backgroundColor, equals(backgroundColor));
      },
    );

    testWidgets(
      "applies the title text style from the metrics theme",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            theme: theme,
            strategy: strategy,
          ));
        });

        final titleWidget = tester.widget<Text>(
          find.text(title),
        );

        expect(titleWidget.style, equals(titleTextStyle));
      },
    );

    testWidgets(
      "applies the counter text style from the metrics theme",
      (WidgetTester tester) async {
        final selectedProjects = ['1'];
        final projectGroup = ProjectGroupDialogViewModel(
          selectedProjectIds: UnmodifiableListView(selectedProjects),
        );

        final notifier = ProjectGroupsNotifierMock();

        when(notifier.projectGroupDialogViewModel).thenReturn(projectGroup);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            theme: theme,
            strategy: strategy,
            projectGroupsNotifier: notifier,
          ));
        });

        final titleWidget = tester.widget<Text>(
          find.text(ProjectGroupsStrings.getSelectedCount(
            selectedProjects.length,
          )),
        );

        expect(titleWidget.style, equals(counterTextStyle));
      },
    );

    testWidgets(
      "applies the content border color from the metrics theme",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            theme: theme,
            strategy: strategy,
          ));
        });

        final contentContainer = tester.widget<DecoratedContainer>(
          find.byWidgetPredicate((widget) =>
              widget is DecoratedContainer && widget.child is Column),
        );

        final decoration = contentContainer.decoration as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.top.color, equals(contentBorderColor));
        expect(border.bottom.color, equals(contentBorderColor));
        expect(border.left.color, equals(contentBorderColor));
        expect(border.right.color, equals(contentBorderColor));
      },
    );

    testWidgets(
      "displays the title from the given strategy",
      (WidgetTester tester) async {
        const title = "test title";

        when(strategy.title).thenReturn(title);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
          ));
        });

        expect(find.text(title), findsOneWidget);
      },
    );

    testWidgets(
      "applies the text from the given strategy to the action button",
      (WidgetTester tester) async {
        const text = "test title";

        when(strategy.text).thenReturn(text);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
          ));
        });

        expect(
          find.widgetWithText(MetricsPositiveButton, text),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays the loading text from the strategy if the widget is in the loading state",
      (WidgetTester tester) async {
        const loading = "loading";

        when(strategy.loadingText).thenReturn(loading);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
          ));
        });

        await tester.tap(find.text(strategy.text));
        await tester.pump();
        await tester.idle();

        expect(find.text(loading), findsOneWidget);
      },
    );

    testWidgets(
      "calls the action of the given strategy on tap on the action button",
      (WidgetTester tester) async {
        const groupId = "id";
        const groupName = "name";
        final projectIds = UnmodifiableListView<String>([]);

        final projectGroupDialogViewModel = ProjectGroupDialogViewModel(
          id: groupId,
          name: groupName,
          selectedProjectIds: projectIds,
        );

        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupDialogViewModel)
            .thenReturn(projectGroupDialogViewModel);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
            projectGroupsNotifier: projectGroupsNotifier,
          ));
        });

        await tester.tap(find.text(strategy.text));
        await tester.pump();

        verify(strategy.action(any, groupId, groupName, projectIds))
            .called(equals(1));
      },
    );

    testWidgets(
      "does not call the action callback if the project group name is not valid",
      (WidgetTester tester) async {
        final projectGroupDialogViewModel = ProjectGroupDialogViewModel(
          selectedProjectIds: UnmodifiableListView<String>([]),
        );

        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupDialogViewModel)
            .thenReturn(projectGroupDialogViewModel);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
            projectGroupsNotifier: projectGroupsNotifier,
          ));
        });

        await tester.tap(find.text(strategy.text));
        await tester.pump();

        verifyNever(strategy.action(any, any, any, any));
      },
    );

    testWidgets(
      "does not call the action if the widget is in the loading state",
      (WidgetTester tester) async {
        final invocationCompleter = Completer();

        when(strategy.action(any, any, any, any))
            .thenAnswer((realInvocation) => invocationCompleter.future);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
          ));
        });

        await tester.tap(find.text(strategy.text));
        await tester.pump();

        await tester.tap(find.text(strategy.loadingText));
        await tester.pump();

        verify(strategy.action(any, any, any, any)).called(equals(1));
        invocationCompleter.complete();
      },
    );

    testWidgets(
      "closes after the action completes successfully",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
          ));
        });

        await tester.tap(find.text(strategy.text));
        await tester.pumpAndSettle();

        expect(find.byType(ProjectGroupDialog), findsNothing);
      },
    );

    testWidgets(
      "changes the state from the loading to not loading on action failed",
      (WidgetTester tester) async {
        when(projectGroupsNotifier.projectGroupSavingError).thenReturn("error");

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
            projectGroupsNotifier: projectGroupsNotifier,
          ));
        });

        await tester.tap(find.text(strategy.text));
        await tester.pump();

        expect(find.text(strategy.text), findsOneWidget);
      },
    );

    testWidgets(
      "displays the search icon as a prefix icon of the metrics text form field",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
          ));
        });

        final finder = find.byWidgetPredicate((widget) {
          if (widget is MetricsTextFormField) {
            final image = widget.prefixIcon as Image;
            final networkImage = image?.image as NetworkImage;

            return networkImage?.url == 'icons/search.svg';
          }

          return false;
        });

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "searches for the projects on the search text field value changed",
      (tester) async {
        const searchText = "search";

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
            projectGroupsNotifier: projectGroupsNotifier,
          ));
        });

        final searchFieldFinder = find.byWidgetPredicate(
          (widget) =>
              widget is MetricsTextFormField &&
              widget.hint == CommonStrings.searchForProject,
        );

        await tester.enterText(searchFieldFinder, searchText);

        verify(projectGroupsNotifier.filterByProjectName(searchText))
            .called(equals(1));
      },
    );

    testWidgets(
      "displays a project group name in a group name text field",
      (tester) async {
        const name = "search";
        final projectGroupDialogViewModel = ProjectGroupDialogViewModel(
          name: name,
          selectedProjectIds: UnmodifiableListView<String>([]),
        );

        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupDialogViewModel)
            .thenReturn(projectGroupDialogViewModel);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
            projectGroupsNotifier: projectGroupsNotifier,
          ));
        });

        final groupNameFinder = find.byWidgetPredicate(
          (widget) =>
              widget is MetricsTextFormField && widget.controller?.text == name,
        );

        expect(groupNameFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the project group name validator to the project group name text field",
      (tester) async {
        final projectGroupDialogViewModel = ProjectGroupDialogViewModel(
          selectedProjectIds: UnmodifiableListView<String>([]),
        );

        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupDialogViewModel)
            .thenReturn(projectGroupDialogViewModel);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
            projectGroupsNotifier: projectGroupsNotifier,
          ));
        });

        final projectGroupNameTextField = tester.widget<MetricsTextFormField>(
          find.widgetWithText(
            MetricsTextFormField,
            ProjectGroupsStrings.nameYourGroup,
          ),
        );

        expect(
          projectGroupNameTextField.validator,
          equals(ProjectGroupNameValidator.validate),
        );
      },
    );

    testWidgets(
      "validates the project group name field on tap on the action button",
      (tester) async {
        final projectGroupDialogViewModel = ProjectGroupDialogViewModel(
          selectedProjectIds: UnmodifiableListView<String>([]),
        );

        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupDialogViewModel)
            .thenReturn(projectGroupDialogViewModel);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
            projectGroupsNotifier: projectGroupsNotifier,
          ));
        });

        await tester.tap(find.text(strategy.text));
        await tester.pump();

        expect(
          find.text(ProjectGroupsStrings.projectGroupNameRequired),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays the search for project text as a hint of the metrics text form field",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            strategy: strategy,
          ));
        });

        final metricsTextFormField = find.byWidgetPredicate(
          (widget) =>
              widget is MetricsTextFormField &&
              widget.hint == CommonStrings.searchForProject,
        );

        expect(metricsTextFormField, findsOneWidget);
      },
    );

    testWidgets(
      "contains the project checkbox list",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectGroupDialogTestbed(strategy: strategy),
          );
        });

        expect(find.byType(ProjectCheckboxList), findsOneWidget);
      },
    );

    testWidgets(
      "displays a counter of the selected projects",
      (tester) async {
        final selectedProjectIds = ['1', '2'];
        final projectGroup = ProjectGroupDialogViewModel(
          selectedProjectIds: UnmodifiableListView(selectedProjectIds),
        );

        final notifier = ProjectGroupsNotifierMock();

        when(notifier.projectGroupDialogViewModel).thenReturn(projectGroup);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            projectGroupsNotifier: notifier,
            strategy: strategy,
          ));
        });

        final expectedCounterText = ProjectGroupsStrings.getSelectedCount(
          selectedProjectIds.length,
        );

        expect(find.text(expectedCounterText), findsOneWidget);
      },
    );

    testWidgets(
      "does not display a counter of the selected projects if no projects selected",
      (tester) async {
        final selectedProjectIds = <String>[];
        final projectGroup = ProjectGroupDialogViewModel(
          selectedProjectIds: UnmodifiableListView(selectedProjectIds),
        );

        final notifier = ProjectGroupsNotifierMock();

        when(notifier.projectGroupDialogViewModel).thenReturn(projectGroup);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectGroupDialogTestbed(
            projectGroupsNotifier: notifier,
            strategy: strategy,
          ));
        });

        final expectedCounterText = ProjectGroupsStrings.getSelectedCount(
          selectedProjectIds.length,
        );

        expect(find.text(expectedCounterText), findsNothing);
      },
    );
  });
}

/// A testbed class required to test the [ProjectGroupDialog] widget.
class _ProjectGroupDialogTestbed extends StatelessWidget {
  /// A [ProjectGroupsNotifier] that will be injected and used in tests.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// A [ProjectGroupDialogStrategy] strategy applied to the [ProjectGroupDialog].
  final ProjectGroupDialogStrategy strategy;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData theme;

  /// Creates a new instance of the [_ProjectGroupDialogTestbed]
  /// with the given [strategy], [projectGroupsNotifier] and [theme].
  ///
  /// The [theme] defaults to an empty [MetricsThemeData].
  const _ProjectGroupDialogTestbed({
    Key key,
    this.strategy,
    this.projectGroupsNotifier,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MetricsThemedTestbed(
        metricsThemeData: theme,
        body: ProjectGroupDialog(
          strategy: strategy,
        ),
      ),
    );
  }
}

class ProjectGroupDialogStrategyMock extends Mock
    implements ProjectGroupDialogStrategy {}
