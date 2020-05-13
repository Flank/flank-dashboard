// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:test/test.dart';

void main() {
  test(
    "Creates MetricWidgetThemeData with default primary and accent colors if nothing was passed to constructor",
    () {
      final widgetThemeData = MetricWidgetThemeData();

      expect(widgetThemeData.primaryColor, isNotNull);
      expect(widgetThemeData.accentColor, isNotNull);
    },
  );

  test(
    "Creates an instance with the default primary and accent colors if nulls were passed into constuctor",
    () {
      final widgetThemeData = MetricWidgetThemeData(
        primaryColor: null,
        accentColor: null,
      );

      expect(widgetThemeData.primaryColor, isNotNull);
      expect(widgetThemeData.accentColor, isNotNull);
    },
  );
}
