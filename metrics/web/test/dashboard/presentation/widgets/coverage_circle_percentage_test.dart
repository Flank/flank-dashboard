import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/coverage_circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metric_value_theme_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/themed_circle_percentage.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("CoverageCirclePercentage", () {
    testWidgets(
      "can't be created with null percent",
      (tester) async {
        await tester.pumpWidget(const _CoverageCirclePercentageTestbed(
          coverage: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the ThemedCirclePercentage with MetricValueThemeStrategy",
      (tester) async {
        await tester.pumpWidget(const _CoverageCirclePercentageTestbed());

        expect(
          find.byWidgetPredicate((widget) =>
              widget is ThemedCirclePercentage &&
              widget.themeStrategy is MetricValueThemeStrategy),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "delegates the percent value to the ThemedCirclePercentage widget",
      (tester) async {
        const coverage = CoverageViewModel(value: 0.2);

        await tester.pumpWidget(const _CoverageCirclePercentageTestbed(
          coverage: coverage,
        ));

        final themedCirclePercentageWidget =
            tester.widget<ThemedCirclePercentage>(
          find.byType(ThemedCirclePercentage),
        );

        expect(themedCirclePercentageWidget.percent, coverage);
      },
    );
  });
}

/// A testbed class required to test the [CoverageCirclePercentage] widget.
class _CoverageCirclePercentageTestbed extends StatelessWidget {
  /// The [CoverageViewModel] to display.
  final CoverageViewModel coverage;

  /// Creates this testbed instance with the given [coverage].
  ///
  /// The [coverage] defaults to the empty [CoverageViewModel].
  const _CoverageCirclePercentageTestbed({
    Key key,
    this.coverage = const CoverageViewModel(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: CoverageCirclePercentage(
        coverage: coverage,
      ),
    );
  }
}
