import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/common/presentation/colored_bar/widgets/metrics_colored_bar.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/negative_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/neutral_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/positive_graph_indicator.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_widget_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_bar_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_appearance_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildResultBar", () {
    const metricsTheme = MetricsThemeData(
      inactiveWidgetTheme: MetricsWidgetThemeData(
        primaryColor: Colors.red,
      ),
    );
    final successfulBuildResult = BuildResultBarViewModel(
      duration: const Duration(seconds: 20),
      date: DateTime.now(),
      buildStatus: BuildStatus.successful,
    );
    final placeholderFinder = find.byType(PlaceholderBar);
    final mouseRegionFinder = find.ancestor(
      of: find.byType(GestureDetector),
      matching: find.byType(MouseRegion),
    );

    Future<void> _hoverBar(WidgetTester tester) async {
      final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
      mouseRegion.onEnter(const PointerEnterEvent());
      await mockNetworkImagesFor(() {
        return tester.pumpAndSettle();
      });
    }

    testWidgets(
      "displays the PlaceholderBar if the given buildResult is null",
      (tester) async {
        await tester.pumpWidget(const _BuildResultBarTestbed(
          buildResult: null,
        ));

        expect(placeholderFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the bar color from the inactive widget theme to the PlaceholderBar",
      (WidgetTester tester) async {
        final expectedColor = metricsTheme.inactiveWidgetTheme.primaryColor;

        await tester.pumpWidget(const _BuildResultBarTestbed(
          buildResult: null,
          themeData: metricsTheme,
        ));

        final placeholderBar = tester.widget<PlaceholderBar>(placeholderFinder);

        expect(placeholderBar.color, expectedColor);
      },
    );

    testWidgets(
      "applies the bar width from the dimension config to the PlaceholderBar",
      (WidgetTester tester) async {
        const expectedWidth = DimensionsConfig.graphBarWidth;

        await tester.pumpWidget(const _BuildResultBarTestbed(
          buildResult: null,
        ));

        final placeholderBar = tester.widget<PlaceholderBar>(placeholderFinder);

        expect(placeholderBar.width, expectedWidth);
      },
    );

    testWidgets(
      "opens the BuildResultPopupCard widget on hover",
      (WidgetTester tester) async {
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        await _hoverBar(tester);

        expect(find.byType(BuildResultPopupCard), findsOneWidget);
      },
    );

    testWidgets(
      "closes the BuildResultPopupCard widget on exit",
      (WidgetTester tester) async {
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        await _hoverBar(tester);
        final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
        mouseRegion.onExit(const PointerExitEvent());
        await tester.pumpAndSettle();

        expect(find.byType(BuildResultPopupCard), findsNothing);
      },
    );

    testWidgets(
      "does not displays the graph indicator if the popup is closed",
      (tester) async {
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        final graphIndicatorFinder = find.byWidgetPredicate(
          (widget) => widget is GraphIndicator,
        );

        expect(graphIndicatorFinder, findsNothing);
      },
    );

    testWidgets(
      "displays the positive graph indicator if the build status is successful and the popup is opened",
      (tester) async {
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        await _hoverBar(tester);

        final graphIndicatorFinder = find.byType(PositiveGraphIndicator);

        expect(graphIndicatorFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the negative graph indicator if the build status is failed and the popup is opened",
      (tester) async {
        final buildResult = BuildResultBarViewModel(
          duration: Duration.zero,
          date: DateTime.now(),
          buildStatus: BuildStatus.failed,
        );

        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: buildResult,
        ));

        await _hoverBar(tester);

        final graphIndicatorFinder = find.byType(NegativeGraphIndicator);

        expect(graphIndicatorFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the neutral graph indicator if the build status is unknown and the popup is opened",
      (tester) async {
        final buildResult = BuildResultBarViewModel(
          duration: Duration.zero,
          date: DateTime.now(),
          buildStatus: BuildStatus.unknown,
        );

        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: buildResult,
        ));

        await _hoverBar(tester);

        final graphIndicatorFinder = find.byType(NeutralGraphIndicator);

        expect(graphIndicatorFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the padding returned from the given build result bar strategy",
      (tester) async {
        final strategy = BuildResultBarPaddingStrategy(
          buildResults: [successfulBuildResult],
        );
        final expectedPadding = strategy.getBarPadding(successfulBuildResult);

        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
          strategy: strategy,
        ));

        final paddingWidget = tester.widget<Padding>(find.byWidgetPredicate(
          (widget) => widget is Padding && widget.child is Stack,
        ));

        expect(paddingWidget.padding, equals(expectedPadding));
      },
    );

    testWidgets(
      "displays the MetricsColoredBar with the BuildResultBarAppearanceStrategy",
      (tester) async {
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        final bar = tester.widget<MetricsColoredBar>(find.byWidgetPredicate(
          (widget) => widget is MetricsColoredBar<BuildStatus>,
        ));

        expect(bar.strategy, isA<BuildResultBarAppearanceStrategy>());
      },
    );
  });
}

/// A testbed class required to test the [BuildResultBar].
class _BuildResultBarTestbed extends StatelessWidget {
  /// A [BuildResultBarViewModel] to display.
  final BuildResultBarViewModel buildResult;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData themeData;

  /// A height of the [BuildResultBar].
  final double barHeight;

  /// A class that provides an [EdgeInsets] based
  /// on the [BuildResultBarViewModel].
  final BuildResultBarPaddingStrategy strategy;

  /// Creates an instance of this testbed.
  ///
  /// The [themeData] default value is an empty [MetricsThemeData] instance.
  /// The [strategy] default value is an empty
  /// [BuildResultBarPaddingStrategy] instance.
  /// The [barHeight] default value is `20.0`.
  const _BuildResultBarTestbed({
    Key key,
    this.themeData = const MetricsThemeData(),
    this.strategy = const BuildResultBarPaddingStrategy(),
    this.barHeight = 20.0,
    this.buildResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: themeData,
      body: BuildResultBar(
        strategy: strategy,
        buildResult: buildResult,
      ),
    );
  }
}
