// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/features/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("DarkMetricsThemeData", () {
    test(
      'creates a variation theme',
      () {
        final lightMetricsThemeData = DarkMetricsThemeData();

        expect(lightMetricsThemeData.circlePercentagePrimaryTheme, isNotNull);
        expect(lightMetricsThemeData.circlePercentageAccentTheme, isNotNull);
        expect(lightMetricsThemeData.sparklineTheme, isNotNull);
        expect(lightMetricsThemeData.buildResultTheme, isNotNull);
      },
    );
  });
}
