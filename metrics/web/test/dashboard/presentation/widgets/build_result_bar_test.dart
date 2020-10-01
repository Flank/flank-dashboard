import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/dashboard_popup_card_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("BuildResultBar", () {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    const successfulColor = Colors.green;
    const failedColor = Colors.red;
    const canceledColor = Colors.grey;

    const themeData = MetricsThemeData(
      buildResultTheme: BuildResultsThemeData(
        successfulColor: successfulColor,
        failedColor: failedColor,
        canceledColor: canceledColor,
      ),
    );

    final dashboardPopupCardViewModel = DashboardPopupCardViewModel(
      value: 20,
      startDate: DateTime.now(),
    );

    testWidgets(
      "display the PlaceholderBar if the given buildResult is null",
      (tester) async {
        await tester.pumpWidget(const _BuildResultBarTestbed());

        expect(find.byType(PlaceholderBar), findsOneWidget);
      },
    );

    testWidgets(
      "shows the PlaceholderBar if the build result status is null",
      (WidgetTester tester) async {
        final buildResult = BuildResultViewModel(
          dashboardPopupCardViewModel: dashboardPopupCardViewModel,
        );

        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: buildResult,
        ));

        expect(find.byType(PlaceholderBar), findsOneWidget);
      },
    );

    testWidgets(
      "does not change the cursor style for the PlaceholderBar",
      (WidgetTester tester) async {
        final buildResult = BuildResultViewModel(
          dashboardPopupCardViewModel: dashboardPopupCardViewModel,
        );

        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: buildResult,
        ));

        final finder = find.ancestor(
          of: find.byType(PlaceholderBar),
          matching: find.byType(TappableArea),
        );

        expect(finder, findsNothing);
      },
    );

    testWidgets(
      "applies a tappable area to the ColoredBar",
      (WidgetTester tester) async {
        final buildResult = BuildResultViewModel(
          dashboardPopupCardViewModel: dashboardPopupCardViewModel,
          buildStatus: BuildStatus.successful,
        );

        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: buildResult,
        ));

        final finder = find.ancestor(
          of: find.byType(ColoredBar),
          matching: find.byType(TappableArea),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the successful color from the theme to the ColoredBar if the build status equals to successful",
      (tester) async {
        final buildResult = BuildResultViewModel(
          dashboardPopupCardViewModel: dashboardPopupCardViewModel,
          buildStatus: BuildStatus.successful,
        );

        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: buildResult,
          themeData: themeData,
        ));

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.color, equals(successfulColor));
      },
    );

    testWidgets(
      "applies the failed color from the theme to the ColoredBar if the build status equals to failed",
      (tester) async {
        final buildResult = BuildResultViewModel(
          dashboardPopupCardViewModel: dashboardPopupCardViewModel,
          buildStatus: BuildStatus.failed,
        );

        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: buildResult,
          themeData: themeData,
        ));

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.color, equals(failedColor));
      },
    );

    testWidgets(
      "applies the cancelled color from the theme to the ColoredBar if the build status equals to cancelled",
      (tester) async {
        final buildResult = BuildResultViewModel(
          dashboardPopupCardViewModel: dashboardPopupCardViewModel,
          buildStatus: BuildStatus.cancelled,
        );

        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: buildResult,
          themeData: themeData,
        ));

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.color, equals(canceledColor));
      },
    );
  });
}

/// A testbed class required to test the [BuildResultBar].
class _BuildResultBarTestbed extends StatelessWidget {
  /// A [BuildResultViewModel] to display.
  final BuildResultViewModel buildResult;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData themeData;

  /// A height of the [BuildResultBar].
  final double barHeight;

  /// Creates an instance of this testbed.
  ///
  /// If the [themeData] is not specified, an empty [MetricsThemeData] used.
  /// The [barHeight] default value is `20.0`.
  const _BuildResultBarTestbed({
    Key key,
    this.themeData = const MetricsThemeData(),
    this.barHeight = 20.0,
    this.buildResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: themeData,
      body: BuildResultBar(
        buildResult: buildResult,
      ),
    );
  }
}
