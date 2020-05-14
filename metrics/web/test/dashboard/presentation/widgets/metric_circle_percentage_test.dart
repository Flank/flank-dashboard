import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/presentation/widgets/metric_circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metric_value_theme_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/themed_circle_percentage.dart';
import 'package:metrics_core/metrics_core.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricCirclePercentage", () {
    testWidgets(
      "can be created with null percent",
      (tester) async {
        await tester.pumpWidget(const _MetricCirclePercentageTestbed());

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      "displays the ThemedCirclePercentage with MetricValueThemeStrategy",
      (tester) async {
        await tester.pumpWidget(const _MetricCirclePercentageTestbed());

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
        final percent = PercentValueObject(0.2);

        await tester.pumpWidget(_MetricCirclePercentageTestbed(
          percent: percent,
        ));

        final themedCirclePercentageWidget =
            tester.widget<ThemedCirclePercentage>(
          find.byType(ThemedCirclePercentage),
        );

        expect(themedCirclePercentageWidget.value, percent.value);
      },
    );
  });
}

class _MetricCirclePercentageTestbed extends StatelessWidget {
  final PercentValueObject percent;

  const _MetricCirclePercentageTestbed({
    Key key,
    this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: MetricCirclePercentage(
        percent: percent,
      ),
    );
  }
}
