import 'package:metrics/common/presentation/metrics_theme/model/metrics_circle_percentage_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("MetricCirclePercentageThemeData", () {
    test(
      "provides a default MetricWidgetThemeData if nothing is passed",
      () {
        const themeData = MetricCirclePercentageThemeData();

        expect(themeData.highPercentTheme, isNotNull);
        expect(themeData.mediumPercentTheme, isNotNull);
        expect(themeData.lowPercentTheme, isNotNull);
      },
    );

    test(
      "provides a default MetricWidgetThemeData if nulls are passed",
      () {
        const themeData = MetricCirclePercentageThemeData(
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
