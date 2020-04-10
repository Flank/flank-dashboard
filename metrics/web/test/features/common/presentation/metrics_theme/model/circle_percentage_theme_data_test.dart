import 'package:metrics/features/common/presentation/metrics_theme/model/circle_percentage_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("CirclePercentageThemeData", () {
    test(
      "provides a default MetricWidgetThemeData if nothing is passed",
      () {
        const themeData = CirclePercentageThemeData();

        expect(themeData.highPercentTheme, isNotNull);
        expect(themeData.mediumPercentTheme, isNotNull);
        expect(themeData.lowPercentTheme, isNotNull);
      },
    );

    test(
      "provides a default MetricWidgetThemeData if nulls are passed",
      () {
        const themeData = CirclePercentageThemeData(
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
