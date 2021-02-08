// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/circle_percentage.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/percent_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metrics_value_style_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/styled_circle_percentage.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("StyledCirclePercentage", () {
    const style = CirclePercentageStyle(
      valueColor: Colors.red,
      strokeColor: Colors.blue,
      backgroundColor: Colors.white,
      valueStyle: TextStyle(
        color: Colors.orange,
      ),
    );

    final styleStrategy = CirclePercentageStyleStrategyMock();

    setUp(() {
      reset(styleStrategy);
      when(styleStrategy.getWidgetAppearance(any, any)).thenReturn(style);
    });

    testWidgets(
      "throws an AssertionError if the given percent is null",
      (tester) async {
        await tester.pumpWidget(
          const _StyledCirclePercentageTestbed(percent: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the value color from the metrics theme given by style strategy",
      (tester) async {
        await tester.pumpWidget(_StyledCirclePercentageTestbed(
          strategy: styleStrategy,
        ));

        final circlePercentageWidget =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));

        expect(
          circlePercentageWidget.valueColor,
          style.valueColor,
        );
      },
    );

    testWidgets(
      "applies the stroke color from the metrics theme given by style strategy",
      (tester) async {
        await tester.pumpWidget(_StyledCirclePercentageTestbed(
          strategy: styleStrategy,
        ));

        final circlePercentageWidget =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));

        expect(
          circlePercentageWidget.strokeColor,
          style.strokeColor,
        );
      },
    );

    testWidgets(
      "applies the background color from the metrics theme given by style strategy",
      (tester) async {
        await tester.pumpWidget(_StyledCirclePercentageTestbed(
          strategy: styleStrategy,
        ));

        final circlePercentageWidget =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));

        expect(
          circlePercentageWidget.backgroundColor,
          style.backgroundColor,
        );
      },
    );

    testWidgets(
      "applies the value style from the metrics theme given by style strategy",
      (tester) async {
        await tester.pumpWidget(_StyledCirclePercentageTestbed(
          strategy: styleStrategy,
        ));

        final circlePercentageWidget =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));

        expect(
          circlePercentageWidget.valueStyle,
          style.valueStyle,
        );
      },
    );

    testWidgets(
      "throws an AssertionError if the given style strategy is null",
      (tester) async {
        await tester.pumpWidget(const _StyledCirclePercentageTestbed(
          strategy: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the no data placeholder if percent value is null",
      (tester) async {
        const percent = PercentViewModel(null);

        await tester.pumpWidget(const _StyledCirclePercentageTestbed(
          percent: percent,
        ));

        expect(find.text(DashboardStrings.noDataPlaceholder), findsOneWidget);
      },
    );
  });
}

/// A testbed class required for testing the [StyledCirclePercentage].
class _StyledCirclePercentageTestbed extends StatelessWidget {
  /// A [MetricsValueStyleStrategy] used to chose the theme to use in widget.
  final MetricsValueStyleStrategy strategy;

  /// A [PercentViewModel] instance to display.
  final PercentViewModel percent;

  /// Creates this testbed instance with the given [percent] value and theme [strategy].
  ///
  /// The [percent] defaults to the [PercentViewModel] instance with value equals to `1.0`.
  /// The [strategy] defaults to the [MetricsValueStyleStrategy].
  const _StyledCirclePercentageTestbed({
    Key key,
    this.percent = const PercentViewModel(1.0),
    this.strategy = const MetricsValueStyleStrategy(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: StyledCirclePercentage(
        percent: percent,
        appearanceStrategy: strategy,
      ),
    );
  }
}

class CirclePercentageStyleStrategyMock extends Mock
    implements MetricsValueStyleStrategy {}
