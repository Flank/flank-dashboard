// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/metrics_theme/model/metrics_widget_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  test(
    "Creates a MetricsWidgetThemeData with default primary and accent colors if nothing was passed to constructor",
    () {
      const widgetThemeData = MetricsWidgetThemeData();

      expect(widgetThemeData.primaryColor, isNotNull);
      expect(widgetThemeData.accentColor, isNotNull);
    },
  );

  test(
    "Creates an instance with the default primary and accent colors if nulls were passed into constuctor",
    () {
      const widgetThemeData = MetricsWidgetThemeData(
        primaryColor: null,
        accentColor: null,
      );

      expect(widgetThemeData.primaryColor, isNotNull);
      expect(widgetThemeData.accentColor, isNotNull);
    },
  );
}
