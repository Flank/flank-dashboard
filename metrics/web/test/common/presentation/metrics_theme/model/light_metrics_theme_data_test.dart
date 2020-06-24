// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("LightMetricsThemeData", () {
    test(
      "creates a variation theme",
      () {
        final lightMetricsThemeData = LightMetricsThemeData();

        expect(
            lightMetricsThemeData.metricCirclePercentageThemeData, isNotNull);
        expect(lightMetricsThemeData.metricWidgetTheme, isNotNull);
        expect(lightMetricsThemeData.buildResultTheme, isNotNull);
        expect(lightMetricsThemeData.inactiveWidgetTheme, isNotNull);
        expect(lightMetricsThemeData.projectGroupCardTheme, isNotNull);
        expect(lightMetricsThemeData.addProjectGroupCardTheme, isNotNull);
      },
    );
  });
}
