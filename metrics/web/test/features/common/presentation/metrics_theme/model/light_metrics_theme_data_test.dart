// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/features/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("LightMetricsThemeData", () {
    test(
      'creates a variation theme',
      () {
        final lightMetricsThemeData = LightMetricsThemeData();

        expect(lightMetricsThemeData.circlePercentagePrimaryTheme, isNotNull);
        expect(lightMetricsThemeData.circlePercentageAccentTheme, isNotNull);
        expect(lightMetricsThemeData.sparklineTheme, isNotNull);
        expect(lightMetricsThemeData.buildResultTheme, isNotNull);
      },
    );
  });
}
