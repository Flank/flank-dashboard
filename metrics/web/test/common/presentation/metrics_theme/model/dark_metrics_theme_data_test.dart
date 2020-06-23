// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("DarkMetricsThemeData", () {
    test(
      "creates a variation theme",
      () {
        final darkMetricsThemeData = DarkMetricsThemeData();

        expect(darkMetricsThemeData.metricCirclePercentageThemeData, isNotNull);
        expect(darkMetricsThemeData.metricWidgetTheme, isNotNull);
        expect(darkMetricsThemeData.buildResultTheme, isNotNull);
        expect(darkMetricsThemeData.inactiveWidgetTheme, isNotNull);
        expect(darkMetricsThemeData.projectGroupCardTheme, isNotNull);
        expect(darkMetricsThemeData.addProjectGroupCardTheme, isNotNull);
      },
    );
  });
}
