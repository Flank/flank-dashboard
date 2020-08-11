import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

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
        expect(darkMetricsThemeData.deleteDialogTheme, isNotNull);
        expect(darkMetricsThemeData.projectGroupDialogTheme, isNotNull);
        expect(darkMetricsThemeData.metricsButtonTheme, isNotNull);
        expect(darkMetricsThemeData.textFieldTheme, isNotNull);
        expect(darkMetricsThemeData.dropdownTheme, isNotNull);
        expect(darkMetricsThemeData.dropdownItemTheme, isNotNull);
        expect(darkMetricsThemeData.loginTheme, isNotNull);
        expect(darkMetricsThemeData.projectMetricsTableTheme, isNotNull);
        expect(darkMetricsThemeData.buildNumberScorecardTheme, isNotNull);
        expect(darkMetricsThemeData.performanceSparklineTheme, isNotNull);
        expect(darkMetricsThemeData.projectBuildStatusTheme, isNotNull);
        expect(darkMetricsThemeData.toggleTheme, isNotNull);
        expect(darkMetricsThemeData.userMenuTheme, isNotNull);
      },
    );
  });
}
