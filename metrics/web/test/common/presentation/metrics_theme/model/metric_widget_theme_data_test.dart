import 'package:metrics/common/presentation/metrics_theme/model/metrics_widget_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  test(
    "Creates a MetricsWidgetThemeData with default primary and accent colors if nothing was passed to constructor",
    () {
      final widgetThemeData = MetricsWidgetThemeData();

      expect(widgetThemeData.primaryColor, isNotNull);
      expect(widgetThemeData.accentColor, isNotNull);
    },
  );

  test(
    "Creates an instance with the default primary and accent colors if nulls were passed into constuctor",
    () {
      final widgetThemeData = MetricsWidgetThemeData(
        primaryColor: null,
        accentColor: null,
      );

      expect(widgetThemeData.primaryColor, isNotNull);
      expect(widgetThemeData.accentColor, isNotNull);
    },
  );
}
