import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/project_metrics_circle_percentage_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/project_metric_circle_percentage.dart';

import '../../../../test_utils/testbed_page.dart';

void main() {
  group("ProjectMetricCirclePercentage", () {
    const lowPercentMaterialColor = Colors.red;
    const mediumPercentMaterialColor = Colors.yellow;
    const highPercentMaterialColor = Colors.green;
    const inactiveMaterialColor = Colors.grey;

    final circlePercentageTheme = ProjectMetricsCirclePercentageThemeData(
      lowPercentTheme: MetricWidgetThemeData(
        primaryColor: lowPercentMaterialColor[100],
        accentColor: lowPercentMaterialColor[200],
        backgroundColor: lowPercentMaterialColor[300],
      ),
      mediumPercentTheme: MetricWidgetThemeData(
        primaryColor: mediumPercentMaterialColor[100],
        accentColor: mediumPercentMaterialColor[200],
        backgroundColor: mediumPercentMaterialColor[300],
      ),
      highPercentTheme: MetricWidgetThemeData(
        primaryColor: highPercentMaterialColor[100],
        accentColor: highPercentMaterialColor[200],
        backgroundColor: highPercentMaterialColor[300],
      ),
    );
    final MetricsThemeData theme = MetricsThemeData(
      projectMetricsCirclePercentageTheme: circlePercentageTheme,
      inactiveWidgetTheme: MetricWidgetThemeData(
        primaryColor: inactiveMaterialColor[100],
        accentColor: inactiveMaterialColor[200],
        backgroundColor: inactiveMaterialColor[300],
      ),
    );

    testWidgets(
      "applies circle percentage low percent theme",
      (WidgetTester tester) async {
        await tester.pumpWidget(_ProjectMetricCirclePercentageTestbed(
          theme: theme,
          value: 0.1,
        ));
        await tester.pumpAndSettle();

        final circlePercentage =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));
        final expectedTheme = circlePercentageTheme.lowPercentTheme;

        expect(circlePercentage.valueColor, expectedTheme.primaryColor);
        expect(
          circlePercentage.backgroundColor,
          expectedTheme.backgroundColor,
        );
        expect(circlePercentage.strokeColor, expectedTheme.accentColor);
      },
    );

    testWidgets(
      "applies circle percentage medium percent theme",
      (WidgetTester tester) async {
        await tester.pumpWidget(_ProjectMetricCirclePercentageTestbed(
          theme: theme,
          value: 0.6,
        ));
        await tester.pumpAndSettle();

        final circlePercentage =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));

        final expectedTheme = circlePercentageTheme.mediumPercentTheme;

        expect(circlePercentage.valueColor, expectedTheme.primaryColor);
        expect(
          circlePercentage.backgroundColor,
          expectedTheme.backgroundColor,
        );
        expect(circlePercentage.strokeColor, expectedTheme.accentColor);
      },
    );

    testWidgets(
      "applies circle percentage high percent theme",
      (WidgetTester tester) async {
        await tester.pumpWidget(_ProjectMetricCirclePercentageTestbed(
          theme: theme,
          value: 0.9,
        ));
        await tester.pumpAndSettle();

        final circlePercentage =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));
        final expectedTheme = circlePercentageTheme.highPercentTheme;

        expect(circlePercentage.valueColor, expectedTheme.primaryColor);
        expect(
          circlePercentage.backgroundColor,
          expectedTheme.backgroundColor,
        );
        expect(circlePercentage.strokeColor, expectedTheme.accentColor);
      },
    );

    testWidgets(
      "applies inactive theme color to CirclePercentage widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(_ProjectMetricCirclePercentageTestbed(
          theme: theme,
          value: 0.0,
        ));
        await tester.pumpAndSettle();

        final circlePercentage =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));

        final expectedTheme = theme.inactiveWidgetTheme;

        expect(circlePercentage.valueColor, expectedTheme.primaryColor);
        expect(
          circlePercentage.backgroundColor,
          expectedTheme.backgroundColor,
        );
        expect(circlePercentage.strokeColor, expectedTheme.accentColor);
      },
    );

    testWidgets(
      "applies inactive theme colors to CirclePercentage",
      (WidgetTester tester) async {
        await tester.pumpWidget(_ProjectMetricCirclePercentageTestbed(
          theme: theme,
          value: null,
        ));
        await tester.pumpAndSettle();

        final circlePercentage =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));
        final expectedTheme = theme.inactiveWidgetTheme;

        expect(circlePercentage.valueColor, expectedTheme.primaryColor);
        expect(
          circlePercentage.backgroundColor,
          expectedTheme.backgroundColor,
        );
        expect(circlePercentage.strokeColor, expectedTheme.accentColor);
      },
    );
  });
}

class _ProjectMetricCirclePercentageTestbed extends StatelessWidget {
  final MetricsThemeData theme;
  final double value;

  const _ProjectMetricCirclePercentageTestbed({
    Key key,
    this.theme,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestbedPage(
      metricsThemeData: theme,
      body: ProjectMetricCirclePercentage(
        value: value,
      ),
    );
  }
}
