// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("DarkMetricsThemeData", () {
    test(
      "creates a variation theme",
      () {
        final darkMetricsThemeData = DarkMetricsThemeData();

        expect(darkMetricsThemeData.metricsWidgetTheme, isNotNull);
        expect(darkMetricsThemeData.metricsColoredBarTheme, isNotNull);
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
        expect(darkMetricsThemeData.dateRangeTheme, isNotNull);
        expect(darkMetricsThemeData.performanceSparklineTheme, isNotNull);
        expect(darkMetricsThemeData.projectBuildStatusTheme, isNotNull);
        expect(darkMetricsThemeData.toggleTheme, isNotNull);
        expect(darkMetricsThemeData.userMenuButtonTheme, isNotNull);
        expect(darkMetricsThemeData.userMenuTheme, isNotNull);
        expect(darkMetricsThemeData.textPlaceholderTheme, isNotNull);
        expect(darkMetricsThemeData.inputPlaceholderTheme, isNotNull);
        expect(darkMetricsThemeData.circlePercentageTheme, isNotNull);
        expect(darkMetricsThemeData.toastTheme, isNotNull);
        expect(darkMetricsThemeData.pageTitleTheme, isNotNull);
        expect(darkMetricsThemeData.graphIndicatorTheme, isNotNull);
        expect(darkMetricsThemeData.barGraphPopupTheme, isNotNull);
        expect(darkMetricsThemeData.tooltipPopupTheme, isNotNull);
        expect(darkMetricsThemeData.tooltipIconTheme, isNotNull);
        expect(darkMetricsThemeData.debugMenuTheme, isNotNull);
        expect(darkMetricsThemeData.manufacturerBannerThemeData, isNotNull);
      },
    );
  });
}
