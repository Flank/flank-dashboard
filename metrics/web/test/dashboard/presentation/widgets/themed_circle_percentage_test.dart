import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metric_value_theme_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/themed_circle_percentage.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ThemedCirclePercentage", () {
    testWidgets(
      "applies the colors from the MetricWidgetThemeData given by theme strategy",
      (tester) async {
        const metricWidgetTheme = MetricWidgetThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.blue,
          backgroundColor: Colors.white,
        );
        final themeStrategy = CirclePercentageThemeStrategyMock();

        when(themeStrategy.getWidgetTheme(any, any))
            .thenReturn(metricWidgetTheme);

        await tester.pumpWidget(_ThemedCirclePercentageTestbed(
          strategy: themeStrategy,
        ));

        final circlePercentageWidget =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));

        expect(
          circlePercentageWidget.valueColor,
          metricWidgetTheme.primaryColor,
        );
        expect(
          circlePercentageWidget.strokeColor,
          metricWidgetTheme.accentColor,
        );
        expect(
          circlePercentageWidget.backgroundColor,
          metricWidgetTheme.backgroundColor,
        );
      },
    );

    testWidgets(
      "can't be created with null themeStrategy",
      (tester) async {
        await tester.pumpWidget(const _ThemedCirclePercentageTestbed(
          strategy: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );
  });
}

class _ThemedCirclePercentageTestbed extends StatelessWidget {
  final MetricValueThemeStrategy strategy;
  final double value;

  const _ThemedCirclePercentageTestbed({
    Key key,
    this.value = 1.0,
    this.strategy = const MetricValueThemeStrategy(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: ThemedCirclePercentage(
        value: value,
        themeStrategy: strategy,
      ),
    );
  }
}

class CirclePercentageThemeStrategyMock extends Mock
    implements MetricValueThemeStrategy {}
