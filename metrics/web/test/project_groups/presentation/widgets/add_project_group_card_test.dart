import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/base/presentation/widgets/padded_card.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_dialog.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("AddProjectGroupCard", () {
    const style = TextStyle(color: Colors.red);
    const backgroundColor = Colors.red;
    const primaryColor = Colors.red;

    const metricsTheme = MetricsThemeData(
      addProjectGroupCardTheme: ProjectGroupCardThemeData(
        backgroundColor: backgroundColor,
        primaryColor: primaryColor,
        titleStyle: style,
      ),
    );

    testWidgets(
      "displays the padded card",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(const _AddProjectGroupCardTestbed()),
        );

        expect(find.byType(PaddedCard), findsOneWidget);
      },
    );

    testWidgets(
      "applies a hand cursor to the card",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _AddProjectGroupCardTestbed());
        });

        final finder = find.byWidgetPredicate(
          (widget) => widget is PaddedCard && widget.child is HandCursor,
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "applies a background color from the metrics theme to the padded card widget",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _AddProjectGroupCardTestbed(theme: metricsTheme),
          ),
        );

        final cardWidget = tester.widget<PaddedCard>(find.byType(PaddedCard));

        expect(cardWidget.backgroundColor, equals(backgroundColor));
      },
    );

    testWidgets(
      "applies a primary color from the metrics theme to the image widget color",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _AddProjectGroupCardTestbed(theme: metricsTheme),
          ),
        );

        final imageWidget = tester.widget<Image>(find.byType(Image));

        expect(imageWidget.color, equals(primaryColor));
      },
    );

    testWidgets(
      "applies a text style from the metrics theme to the add project group text style",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _AddProjectGroupCardTestbed(theme: metricsTheme),
          ),
        );

        final textWidget = tester.widget<Text>(
          find.text(ProjectGroupsStrings.addProjectGroup),
        );

        expect(textWidget.style, equals(style));
      },
    );

    testWidgets(
      "shows the add project group dialog on tap",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupDialogViewModel).thenReturn(
          ProjectGroupDialogViewModel(
            selectedProjectIds: UnmodifiableListView([]),
          ),
        );

        await mockNetworkImagesFor(
          () => tester.pumpWidget(_AddProjectGroupCardTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
          )),
        );

        await tester.tap(find.byType(AddProjectGroupCard));
        await tester.pump();

        expect(find.byType(AddProjectGroupDialog), findsOneWidget);
      },
    );

    testWidgets(
      "does not open the add project group dialog if the project group dialog view model is null",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        await mockNetworkImagesFor(
          () => tester.pumpWidget(_AddProjectGroupCardTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
          )),
        );

        await tester.tap(find.byType(AddProjectGroupCard));
        await tester.pump();

        expect(find.byType(AddProjectGroupDialog), findsNothing);
      },
    );

    testWidgets(
      "inits the project group dialog view model on tap on the card",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupDialogViewModel).thenReturn(
          ProjectGroupDialogViewModel(
            id: 'id',
            name: 'name',
            selectedProjectIds: UnmodifiableListView([]),
          ),
        );

        await mockNetworkImagesFor(
          () => tester.pumpWidget(_AddProjectGroupCardTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
          )),
        );

        await tester.tap(find.byType(AddProjectGroupCard));
        await tester.pump();

        verify(projectGroupsNotifier.initProjectGroupDialogViewModel())
            .called(equals(1));
      },
    );

    testWidgets(
      "displays the network image with an add button svg",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(const _AddProjectGroupCardTestbed()),
        );

        final imageWidget = tester.widget<Image>(find.byType(Image));
        final networkImage = imageWidget.image as NetworkImage;

        expect(networkImage.url, equals('icons/add.svg'));
      },
    );

    testWidgets(
      "displays the add project group text",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(const _AddProjectGroupCardTestbed()),
        );

        expect(
          find.text(ProjectGroupsStrings.addProjectGroup),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "resets a project group dialog view model after closing the add project group dialog",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupDialogViewModel).thenReturn(
          ProjectGroupDialogViewModel(
            selectedProjectIds: UnmodifiableListView([]),
          ),
        );

        await mockNetworkImagesFor(
          () => tester.pumpWidget(_AddProjectGroupCardTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
          )),
        );

        await tester.tap(find.byType(AddProjectGroupCard));
        await tester.pump();

        expect(find.byType(AddProjectGroupDialog), findsOneWidget);

        final dialog = tester.widget<InfoDialog>(find.byType(InfoDialog));
        final closeIcon = dialog.closeIcon;

        await tester.tap(find.byWidget(closeIcon));
        await tester.pump();

        verify(projectGroupsNotifier.resetProjectGroupDialogViewModel())
            .called(equals(1));
      },
    );
  });
}

/// A testbed widget, used to test the [AddProjectGroupCard] widget.
class _AddProjectGroupCardTestbed extends StatelessWidget {
  /// A [ProjectGroupsNotifier] used in tests.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData theme;

  /// Creates the [_AddProjectGroupCardTestbed] with the given [theme]
  /// and the [projectGroupsNotifier].
  ///
  /// The [theme] defaults to [MetricsThemeData].
  const _AddProjectGroupCardTestbed({
    Key key,
    this.projectGroupsNotifier,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MetricsThemedTestbed(
        metricsThemeData: theme,
        body: AddProjectGroupCard(),
      ),
    );
  }
}
