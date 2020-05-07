import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';

import '../../../../test_utils/injection_container_testbed.dart';

void main() {
  testWidgets(
    "Can't build the widget without builder",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _MetricsThemeBuilderTestbed(builder: null));

      expect(tester.takeException(), isAssertionError);
    },
  );

  testWidgets(
    "Changes the theme on notifier changing",
    (WidgetTester tester) async {
      final themeNotifier = ThemeNotifier();

      await tester.pumpWidget(_MetricsThemeBuilderTestbed(
        themeNotifier: themeNotifier,
      ));

      final themeWidget = tester.widget<MetricsTheme>(
        find.byType(MetricsTheme),
      );

      final currentTheme = themeWidget.data;

      themeNotifier.changeTheme();
      await tester.pump();

      final newThemeWidget = tester.widget<MetricsTheme>(
        find.byType(MetricsTheme),
      );

      final newTheme = newThemeWidget.data;

      expect(newTheme, isNot(currentTheme));
    },
  );

  testWidgets(
    "Creates default theme data if nothing was specified",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _MetricsThemeBuilderTestbed());

      final themeWidget =
          tester.widget<MetricsThemeBuilder>(find.byType(MetricsThemeBuilder));

      expect(themeWidget.lightTheme, isA<LightMetricsThemeData>());
      expect(themeWidget.darkTheme, isA<DarkMetricsThemeData>());
    },
  );
}

class _MetricsThemeBuilderTestbed extends StatelessWidget {
  final MetricsThemeData lightTheme;
  final MetricsThemeData darkTheme;
  final ThemeNotifier themeNotifier;
  final ThemeBuilder builder;

  const _MetricsThemeBuilderTestbed({
    Key key,
    this.lightTheme,
    this.darkTheme,
    this.themeNotifier,
    this.builder = _builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InjectionContainerTestbed(
        themeNotifier: themeNotifier,
        child: MetricsThemeBuilder(
          lightTheme: lightTheme,
          darkTheme: darkTheme,
          builder: builder,
        ),
      ),
    );
  }

  static Widget _builder(BuildContext context, ThemeNotifier themeNotifier) {
    return Container();
  }
}
