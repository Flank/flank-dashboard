// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';

import '../../../../test_utils/test_injection_container.dart';

void main() {
  group("MetricsThemeBuilder", () {
    testWidgets(
      "can't be created with the null builder",
      (WidgetTester tester) async {
        await tester
            .pumpWidget(const _MetricsThemeBuilderTestbed(builder: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "creates the default theme data if no parameters provided",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsThemeBuilderTestbed());

        final themeWidget = tester
            .widget<MetricsThemeBuilder>(find.byType(MetricsThemeBuilder));

        expect(themeWidget.lightTheme, isA<LightMetricsThemeData>());
        expect(themeWidget.darkTheme, isA<DarkMetricsThemeData>());
      },
    );

    testWidgets(
      "changes the theme on notifier changing",
      (WidgetTester tester) async {
        final themeNotifier = ThemeNotifier();

        await tester.pumpWidget(_MetricsThemeBuilderTestbed(
          themeNotifier: themeNotifier,
        ));

        final themeWidget = tester.widget<MetricsTheme>(
          find.byType(MetricsTheme),
        );

        final currentTheme = themeWidget.data;

        themeNotifier.toggleTheme();
        await tester.pump();

        final newThemeWidget = tester.widget<MetricsTheme>(
          find.byType(MetricsTheme),
        );

        final newTheme = newThemeWidget.data;

        expect(newTheme, isNot(currentTheme));
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsThemeBuilder] widget.
class _MetricsThemeBuilderTestbed extends StatelessWidget {
  /// A light variant of the [MetricsThemeData].
  final MetricsThemeData lightTheme;

  /// A dark variant of the [MetricsThemeData].
  final MetricsThemeData darkTheme;

  /// A [ThemeNotifier] used in tests.
  final ThemeNotifier themeNotifier;

  /// A [ThemeBuilder] used to build the child with the [ThemeNotifier] provided.
  final ThemeBuilder builder;

  /// Creates a [_MetricsThemeBuilderTestbed].
  ///
  /// If the [builder] is not specified, the default [_builder] function used.
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
      home: TestInjectionContainer(
        themeNotifier: themeNotifier,
        child: MetricsThemeBuilder(
          lightTheme: lightTheme,
          darkTheme: darkTheme,
          builder: builder,
        ),
      ),
    );
  }

  /// A default [ThemeBuilder] function used if the [builder] is not specified.
  static Widget _builder(BuildContext context, ThemeNotifier themeNotifier) {
    return Container();
  }
}
