// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/stability_circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metrics_value_style_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/styled_circle_percentage.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("StabilityCirclePercentage", () {
    testWidgets(
      "throws an AssertionError if the given percent is null",
      (tester) async {
        await tester.pumpWidget(const _StabilityCirclePercentageTestbed(
          stability: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the StyledCirclePercentage with MetricsValueStyleStrategy",
      (tester) async {
        await tester.pumpWidget(const _StabilityCirclePercentageTestbed());

        expect(
          find.byWidgetPredicate((widget) =>
              widget is StyledCirclePercentage &&
              widget.appearanceStrategy is MetricsValueStyleStrategy),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "delegates the percent value to the StyledCirclePercentage widget",
      (tester) async {
        const stability = StabilityViewModel(value: 0.2);

        await tester.pumpWidget(const _StabilityCirclePercentageTestbed(
          stability: stability,
        ));

        final themedCirclePercentageWidget =
            tester.widget<StyledCirclePercentage>(
          find.byType(StyledCirclePercentage),
        );

        expect(themedCirclePercentageWidget.percent, stability);
      },
    );
  });
}

/// A testbed class required to test the [StabilityCirclePercentage] widget.
class _StabilityCirclePercentageTestbed extends StatelessWidget {
  /// The [StabilityViewModel] to display.
  final StabilityViewModel stability;

  /// Creates the testbed instance with the given [stability].
  ///
  /// The [stability] defaults to the empty [StabilityViewModel].
  const _StabilityCirclePercentageTestbed({
    Key key,
    this.stability = const StabilityViewModel(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: StabilityCirclePercentage(
        stability: stability,
      ),
    );
  }
}
