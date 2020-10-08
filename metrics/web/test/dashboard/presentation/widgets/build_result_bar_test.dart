import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/colored_bar/theme/attention_level/metrics_colored_bar_attention_level.dart';
import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:metrics/common/presentation/colored_bar/theme/theme_data/metrics_colored_bar_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("BuildResultBar", () {
    const successfulColor = Colors.blue;
    const failedColor = Colors.red;
    const canceledColor = Colors.grey;

    const themeData = MetricsThemeData(
      metricsColoredBarTheme: MetricsColoredBarThemeData(
        attentionLevel: MetricsColoredBarAttentionLevel(
          positive: MetricsColoredBarStyle(
            color: successfulColor,
            backgroundColor: successfulColor,
          ),
          neutral: MetricsColoredBarStyle(
            color: canceledColor,
            backgroundColor: canceledColor,
          ),
          negative: MetricsColoredBarStyle(
            color: failedColor,
            backgroundColor: failedColor,
          ),
        ),
      ),
    );

    final buildResultPopupViewModel = BuildResultPopupViewModel(
      duration: const Duration(seconds: 20),
      date: DateTime.now(),
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
          buildResultPopupViewModel: buildResultPopupViewModel,
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
          buildResultPopupViewModel: buildResultPopupViewModel,
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
      "applies the successful color from the theme to the ColoredBar if the build status equals to successful",
      (tester) async {
        final buildResult = BuildResultViewModel(
          buildResultPopupViewModel: buildResultPopupViewModel,
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
          buildResultPopupViewModel: buildResultPopupViewModel,
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
          buildResultPopupViewModel: buildResultPopupViewModel,
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

    testWidgets(
      "applies the padding returned from the given build result bar strategy",
      (tester) async {
        final buildResult = BuildResultViewModel(
          buildResultPopupViewModel: buildResultPopupViewModel,
          buildStatus: BuildStatus.cancelled,
        );
        final strategy = BuildResultBarPaddingStrategy(
          buildResults: [buildResult],
        );
        final expectedPadding = strategy.getBarPadding(buildResult);

        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: buildResult,
          strategy: strategy,
          themeData: themeData,
        ));

        final paddingWidget = tester.widget<Padding>(find.byWidgetPredicate(
          (widget) => widget is Padding && widget.child is Stack,
        ));

        expect(paddingWidget.padding, equals(expectedPadding));
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

  /// A class that provides an [EdgeInsets] based
  /// on the [BuildResultViewModel].
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
