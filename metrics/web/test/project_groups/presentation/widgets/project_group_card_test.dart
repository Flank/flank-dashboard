import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/padded_card.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ProjectGroupCard", () {
    const testBackgroundColor = Colors.white;
    const testHoverColor = Colors.black;

    const projectGroupCardViewModel = ProjectGroupCardViewModel(
      id: 'id',
      name: 'name',
      projectsCount: 1,
    );

    const testTheme = MetricsThemeData(
      projectGroupCardTheme: ProjectGroupCardThemeData(
        backgroundColor: testBackgroundColor,
        hoverColor: testHoverColor,
      ),
    );

    final mouseRegionFinder = find.descendant(
      of: find.byType(ProjectGroupCard),
      matching: find.byType(MouseRegion),
    );

    testWidgets(
      "applies the background color from theme if widget is not hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          theme: testTheme,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

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
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ProjectGroupCardTestbed(
            theme: testTheme,
            projectGroupCardViewModel: projectGroupCardViewModel,
          ));
        });

        final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
        const pointerEnterEvent = PointerEnterEvent();
        mouseRegion.onEnter(pointerEnterEvent);

        await mockNetworkImagesFor(() => tester.pump());

        final paddedCard = tester.widget<PaddedCard>(find.descendant(
          of: find.byType(ProjectGroupCard),
          matching: find.byType(PaddedCard),
        ));

        expect(paddedCard.backgroundColor, equals(testHoverColor));
      },
    );

    testWidgets(
      "hides the edit button if the widget is not hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupCardTestbed(
          theme: testTheme,
          projectGroupCardViewModel: projectGroupCardViewModel,
        ));

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
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ProjectGroupCardTestbed(
            theme: testTheme,
            projectGroupCardViewModel: projectGroupCardViewModel,
          ));
        });

        final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
        const pointerEnterEvent = PointerEnterEvent();
        mouseRegion.onEnter(pointerEnterEvent);

        await mockNetworkImagesFor(() => tester.pump());

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
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ProjectGroupCardTestbed(
            theme: testTheme,
            projectGroupCardViewModel: projectGroupCardViewModel,
          ));
        });

        final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
        const pointerEnterEvent = PointerEnterEvent();
        mouseRegion.onEnter(pointerEnterEvent);

        await mockNetworkImagesFor(() => tester.pump());

        expect(find.text(CommonStrings.delete), findsOneWidget);
      },
    );
  });
}

/// A testbed class required to test the [ProjectGroupCard] widget.
class _ProjectGroupCardTestbed extends StatelessWidget {
  /// A [ProjectGroupCardViewModel] with project group data to display.
  final ProjectGroupCardViewModel projectGroupCardViewModel;

  /// A [MetricsThemeData] used in this testbed.
  final MetricsThemeData theme;

  /// Creates an instance of this testbed with the given parameters.
  const _ProjectGroupCardTestbed({
    Key key,
    this.projectGroupCardViewModel,
    this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: ProjectGroupCard(
        projectGroupCardViewModel: projectGroupCardViewModel,
      ),
    );
  }
}
