import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("LightMetricsThemeData", () {
    test(
      "creates a variation theme",
      () {
        final lightMetricsThemeData = LightMetricsThemeData();

        expect(
          lightMetricsThemeData.metricCirclePercentageThemeData,
          isNotNull,
        );
        expect(lightMetricsThemeData.metricWidgetTheme, isNotNull);
        expect(lightMetricsThemeData.buildResultTheme, isNotNull);
        expect(lightMetricsThemeData.inactiveWidgetTheme, isNotNull);
        expect(lightMetricsThemeData.projectGroupCardTheme, isNotNull);
        expect(lightMetricsThemeData.addProjectGroupCardTheme, isNotNull);
        expect(lightMetricsThemeData.deleteDialogTheme, isNotNull);
        expect(lightMetricsThemeData.projectGroupDialogTheme, isNotNull);
        expect(lightMetricsThemeData.metricsButtonTheme, isNotNull);
        expect(lightMetricsThemeData.textFieldTheme, isNotNull);
        expect(lightMetricsThemeData.dropdownTheme, isNotNull);
        expect(lightMetricsThemeData.dropdownItemTheme, isNotNull);
        expect(lightMetricsThemeData.loginTheme, isNotNull);
        expect(lightMetricsThemeData.projectMetricsTableTheme, isNotNull);
        expect(lightMetricsThemeData.scorecardTheme, isNotNull);
      },
    );
  });
}
