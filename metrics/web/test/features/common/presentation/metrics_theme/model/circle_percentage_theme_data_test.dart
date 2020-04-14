import 'package:metrics/features/common/presentation/metrics_theme/model/project_metrics_circle_percentage_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectMetricsCirclePercentageThemeData", () {
    test(
      "provides a default MetricWidgetThemeData if nothing is passed",
      () {
        const themeData = ProjectMetricsCirclePercentageThemeData();

        expect(themeData.highPercentTheme, isNotNull);
        expect(themeData.mediumPercentTheme, isNotNull);
        expect(themeData.lowPercentTheme, isNotNull);
      },
    );

    test(
      "provides a default MetricWidgetThemeData if nulls are passed",
      () {
        const themeData = ProjectMetricsCirclePercentageThemeData(
          lowPercentTheme: null,
          mediumPercentTheme: null,
          highPercentTheme: null,
        );

        expect(themeData.highPercentTheme, isNotNull);
        expect(themeData.mediumPercentTheme, isNotNull);
        expect(themeData.lowPercentTheme, isNotNull);
      },
    );
  });
}
