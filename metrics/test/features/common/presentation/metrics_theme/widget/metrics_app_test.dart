import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_app.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';

void main() {
  testWidgets(
    "Provides the default theme if theme and theme type was not specified",
    (WidgetTester tester) async {
      await tester.pumpWidget(const MetricsAppTestbed());

      final metricsThemeWidget = tester.widget<MetricsTheme>(
        find.byType(MetricsTheme),
      );

      expect(metricsThemeWidget, isNotNull);
    },
  );

  testWidgets(
    'Provides the themeData corresponding to MetricsThemeType',
    (WidgetTester tester) async {
      const darkTheme = MetricsThemeData.dark();
      const lightTheme = MetricsThemeData.light();

      for (final themeType in MetricsThemeType.values) {
        await tester.pumpWidget(MetricsAppTestbed(
          darkTheme: darkTheme,
          lightTheme: lightTheme,
          themeType: themeType,
        ));

        final metricThemeWidget = tester.widget<MetricsTheme>(
          find.byType(MetricsTheme),
        );

        if (themeType == MetricsThemeType.light) {
          expect(metricThemeWidget.data, lightTheme);
        } else {
          expect(metricThemeWidget.data, darkTheme);
        }
      }
    },
  );
}

class MetricsAppTestbed extends StatelessWidget {
  final Widget child;
  final MetricsThemeData lightTheme;
  final MetricsThemeData darkTheme;
  final MetricsThemeType themeType;

  const MetricsAppTestbed({
    Key key,
    this.child = const Scaffold(),
    this.lightTheme,
    this.darkTheme,
    this.themeType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MetricsApp(
        lightTheme: lightTheme,
        darkTheme: darkTheme,
        themeType: themeType,
        child: child,
      ),
    );
  }
}
