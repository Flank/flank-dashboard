// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/coverage_circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metrics_value_style_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/styled_circle_percentage.dart';

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
      "displays the ThemedCirclePercentage with MetricsValueThemeStrategy",
      (tester) async {
        await tester.pumpWidget(const _CoverageCirclePercentageTestbed());

        expect(
          find.byWidgetPredicate((widget) =>
              widget is StyledCirclePercentage &&
              widget.appearanceStrategy is MetricsValueStyleStrategy),
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
            tester.widget<StyledCirclePercentage>(
          find.byType(StyledCirclePercentage),
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
