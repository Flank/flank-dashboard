import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/icon_label_button.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/base/presentation/widgets/padded_card.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/delete_project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/delete_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/edit_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectGroupCard", () {
    const projectGroupCardViewModel = ProjectGroupCardViewModel(
      id: 'id1',
      name: 'name1',
      projectsCount: 1,
    );

    const testPrimaryColor = Colors.blue;
    const testAccentColor = Colors.amberAccent;
    const testBorderColor = Colors.red;
    const testBackgroundColor = Colors.white;
    const testHoverColor = Colors.black;
    const testTitleStyle = TextStyle(color: Colors.grey);
    const testSubtitleStyle = TextStyle(color: Colors.black);

    const testTheme = MetricsThemeData(
      projectGroupCardTheme: ProjectGroupCardThemeData(
        primaryColor: testPrimaryColor,
        accentColor: testAccentColor,
        backgroundColor: testBackgroundColor,
        hoverColor: testHoverColor,
        borderColor: testBorderColor,
        titleStyle: testTitleStyle,
        subtitleStyle: testSubtitleStyle,
      ),
    );

    final mouseRegionFinder = find.descendant(
      of: find.byType(ProjectGroupCard),
      matching: find.byType(MouseRegion),
    );

    Future<void> _hoverProjectGroupCard(WidgetTester tester) async {
      final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
      const pointerEnterEvent = PointerEnterEvent();
      mouseRegion.onEnter(pointerEnterEvent);

      await tester.pump();
    }

    testWidgets(
      "throws an AssertionError if a project group card view model is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _ProjectGroupCardTestbed(projectGroupCardViewModel: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the background color from theme if widget is not hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _ProjectGroupCardTestbed(
            theme: testTheme,
            projectGroupCardViewModel: projectGroupCardViewModel,
          ),
        );

        final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
        const pointerExitEvent = PointerExitEvent();
        mouseRegion.onExit(pointerExitEvent);

        await tester.pump();

        final paddedCard = tester.widget<PaddedCard>(find.descendant(
          of: find.byType(ProjectGroupCard),
          matching: find.byType(PaddedCard),
        ));

        expect(paddedCard.backgroundColor, equals(testBackgroundColor));
      },
    );

    testWidgets(
      "applies the hover color from theme if the widget is hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          theme: testTheme,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        final paddedCard = tester.widget<PaddedCard>(find.descendant(
          of: find.byType(ProjectGroupCard),
          matching: find.byType(PaddedCard),
        ));

        expect(paddedCard.backgroundColor, equals(testHoverColor));
      },
    );

    testWidgets(
      "applies the border color from the metrics theme to the padded card",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          theme: testTheme,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        final paddedCard = tester.widget<PaddedCard>(find.byType(PaddedCard));
        final borderShape = paddedCard.shape as RoundedRectangleBorder;

        expect(borderShape.side.color, equals(testBorderColor));
      },
    );

    testWidgets(
      "applies the title style from the metrics theme to the name text",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          theme: testTheme,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        final textWidget = tester.widget<Text>(
          find.text(projectGroupCardViewModel.name),
        );

        expect(textWidget.style, equals(testTitleStyle));
      },
    );

    testWidgets(
      "applies the subtitle style from the metrics theme to the count text",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          theme: testTheme,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        final textWidget = tester.widget<Text>(
          find.text(
            ProjectGroupsStrings.getProjectsCount(
              projectGroupCardViewModel.projectsCount,
            ),
          ),
        );

        expect(textWidget.style, equals(testSubtitleStyle));
      },
    );

    testWidgets(
      "applies the primary color from the metrics theme to the edit button label",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          theme: testTheme,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        final buttonWidget = tester.widget<IconLabelButton>(
          find.widgetWithText(IconLabelButton, CommonStrings.edit),
        );

        expect(buttonWidget.labelStyle.color, equals(testPrimaryColor));
      },
    );

    testWidgets(
      "applies the primary color from the metrics theme to the delete button label",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          theme: testTheme,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        final buttonWidget = tester.widget<IconLabelButton>(
          find.widgetWithText(IconLabelButton, CommonStrings.delete),
        );

        expect(buttonWidget.labelStyle.color, equals(testAccentColor));
      },
    );

    testWidgets(
      "hides the edit button if the widget is not hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _ProjectGroupCardTestbed(
            projectGroupCardViewModel: projectGroupCardViewModel,
          ),
        );

        final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
        const pointerExitEvent = PointerExitEvent();
        mouseRegion.onExit(pointerExitEvent);

        await tester.pump();

        expect(find.text(CommonStrings.edit), findsNothing);
      },
    );

    testWidgets(
      "shows the edit button if the widget is hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          theme: testTheme,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        expect(find.text(CommonStrings.edit), findsOneWidget);
      },
    );

    testWidgets(
      "hides the delete button if the widget is not hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          theme: testTheme,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
        const pointerExitEvent = PointerExitEvent();
        mouseRegion.onExit(pointerExitEvent);

        await tester.pump();

        expect(find.text(CommonStrings.delete), findsNothing);
      },
    );

    testWidgets(
      "shows the delete button if the widget is hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          theme: testTheme,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        expect(find.text(CommonStrings.delete), findsOneWidget);
      },
    );

    testWidgets(
      "displays a name",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        expect(
          find.widgetWithText(PaddedCard, projectGroupCardViewModel.name),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays a projects count",
      (WidgetTester tester) async {
        final projectsCountText = ProjectGroupsStrings.getProjectsCount(
          projectGroupCardViewModel.projectsCount,
        );

        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        expect(
          find.widgetWithText(PaddedCard, projectsCountText),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays the no projects text if the projects count equals to 0",
      (WidgetTester tester) async {
        const projectGroupCardViewModel = ProjectGroupCardViewModel(
          id: 'id',
          name: 'name',
          projectsCount: 0,
        );

        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        expect(
          find.widgetWithText(PaddedCard, ProjectGroupsStrings.noProjects),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "shows the update project group dialog on tap on the edit button",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupDialogViewModel).thenReturn(
          ProjectGroupDialogViewModel(
            selectedProjectIds: UnmodifiableListView([]),
          ),
        );

        await tester.pumpWidget(_ProjectGroupCardTestbed(
          projectGroupsNotifier: projectGroupsNotifier,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        await tester.tap(
          find.widgetWithText(IconLabelButton, CommonStrings.edit),
        );

        await tester.pump();

        expect(find.byType(EditProjectGroupDialog), findsOneWidget);
      },
    );

    testWidgets(
      "inits project group dialog view model on tap on the edit button",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();
        const projectId = 'id1';

        when(projectGroupsNotifier.projectGroupDialogViewModel).thenReturn(
          ProjectGroupDialogViewModel(
            id: projectId,
            name: 'name',
            selectedProjectIds: UnmodifiableListView([]),
          ),
        );

        await tester.pumpWidget(
          _ProjectGroupCardTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
            projectGroupCardViewModel: projectGroupCardViewModel,
          ),
        );

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        await tester.tap(
          find.widgetWithText(IconLabelButton, CommonStrings.edit),
        );

        verify(projectGroupsNotifier.initProjectGroupDialogViewModel(
          projectId,
        )).called(equals(1));
      },
    );

    testWidgets(
      "resets the project group dialog view model after closing the edit project group dialog",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(
          projectGroupsNotifier.projectGroupDialogViewModel,
        ).thenReturn(
          ProjectGroupDialogViewModel(
            id: 'id1',
            name: 'name',
            selectedProjectIds: UnmodifiableListView([]),
          ),
        );

        await tester.pumpWidget(_ProjectGroupCardTestbed(
          projectGroupCardViewModel: projectGroupCardViewModel,
          projectGroupsNotifier: projectGroupsNotifier,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        await tester.tap(
          find.widgetWithText(IconLabelButton, CommonStrings.edit),
        );
        await tester.pump();

        expect(find.byType(EditProjectGroupDialog), findsOneWidget);

        final closeIconFinder = find
            .descendant(
              of: find.byType(InfoDialog),
              matching: find.byIcon(Icons.close),
            )
            .first;

        await tester.tap(closeIconFinder);
        await tester.pump();

        verify(projectGroupsNotifier.resetProjectGroupDialogViewModel())
            .called(equals(1));
      },
    );

    testWidgets(
      "does not open the edit project group dialog if the project group dialog view model is null",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        await tester.pumpWidget(_ProjectGroupCardTestbed(
          projectGroupsNotifier: projectGroupsNotifier,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        await tester.tap(
          find.widgetWithText(IconLabelButton, CommonStrings.edit),
        );
        await tester.pump();

        verify(projectGroupsNotifier.initProjectGroupDialogViewModel(any))
            .called(equals(1));
        expect(find.byType(ProjectGroupDialogViewModel), findsNothing);
      },
    );

    testWidgets(
      "shows the delete project group dialog on tap on the delete button",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.deleteProjectGroupDialogViewModel)
            .thenReturn(
          const DeleteProjectGroupDialogViewModel(
            id: "id",
            name: "name",
          ),
        );

        await tester.pumpWidget(_ProjectGroupCardTestbed(
          projectGroupsNotifier: projectGroupsNotifier,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        await tester.tap(
          find.widgetWithText(IconLabelButton, CommonStrings.delete),
        );

        await tester.pump();

        expect(find.byType(DeleteProjectGroupDialog), findsOneWidget);
      },
    );

    testWidgets(
      "inits the delete project group dialog view model on tap on the delete button",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(
          projectGroupsNotifier.deleteProjectGroupDialogViewModel,
        ).thenReturn(
          const DeleteProjectGroupDialogViewModel(id: 'id1', name: 'name'),
        );

        await tester.pumpWidget(_ProjectGroupCardTestbed(
          projectGroupsNotifier: projectGroupsNotifier,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        await tester.tap(
          find.widgetWithText(IconLabelButton, CommonStrings.delete),
        );

        verify(projectGroupsNotifier.initDeleteProjectGroupDialogViewModel(any))
            .called(equals(1));
      },
    );

    testWidgets(
      "resets the delete project group dialog view model after closing the delete project group dialog",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(
          projectGroupsNotifier.deleteProjectGroupDialogViewModel,
        ).thenReturn(
          const DeleteProjectGroupDialogViewModel(id: 'id1', name: 'name'),
        );

        await tester.pumpWidget(_ProjectGroupCardTestbed(
          projectGroupCardViewModel: projectGroupCardViewModel,
          projectGroupsNotifier: projectGroupsNotifier,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        await tester.tap(
          find.widgetWithText(IconLabelButton, CommonStrings.delete),
        );

        await tester.pump();

        expect(find.byType(DeleteProjectGroupDialog), findsOneWidget);

        await tester.tap(find.text(CommonStrings.cancel));
        await tester.pump();

        verify(projectGroupsNotifier.resetDeleteProjectGroupDialogViewModel())
            .called(equals(1));
      },
    );

    testWidgets(
      "does not open the delete project group dialog if the delete project group dialog view model is null",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        await tester.pumpWidget(_ProjectGroupCardTestbed(
          projectGroupsNotifier: projectGroupsNotifier,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

        await mockNetworkImagesFor(() async {
          await _hoverProjectGroupCard(tester);
        });

        await tester.tap(
          find.widgetWithText(IconLabelButton, CommonStrings.delete),
        );
        await tester.pump();

        verify(projectGroupsNotifier.initDeleteProjectGroupDialogViewModel(any))
            .called(equals(1));
        expect(find.byType(DeleteProjectGroupDialog), findsNothing);
      },
    );
  });
}

/// A testbed widget, used to test the [ProjectGroupCard] widget.
class _ProjectGroupCardTestbed extends StatelessWidget {
  /// A project group card view model with project group data to display.
  final ProjectGroupCardViewModel projectGroupCardViewModel;

  /// A [ProjectGroupsNotifier] used in testbed.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// The [MetricsThemeData] used in testbed.
  final MetricsThemeData theme;

  /// Creates the [_ProjectGroupCardTestbed] with the given [theme]
  /// and the [projectGroupCardViewModel].
  const _ProjectGroupCardTestbed({
    Key key,
    this.theme = const MetricsThemeData(),
    this.projectGroupsNotifier,
    this.projectGroupCardViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MetricsThemedTestbed(
        metricsThemeData: theme,
        body: ProjectGroupCard(
          projectGroupCardViewModel: projectGroupCardViewModel,
        ),
      ),
    );
  }
}
