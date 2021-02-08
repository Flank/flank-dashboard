// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

void main() {
  group("MetricsTheme", () {
    testWidgets(
      "can't be created when the child is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsThemeTestbed(child: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "can't be created without data",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsThemeTestbed(data: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      ".of() provides the theme data from the given context",
      (WidgetTester tester) async {
        final childKey = GlobalKey();
        const metricsThemeData = MetricsThemeData();

        await tester.pumpWidget(_MetricsThemeTestbed(
          data: metricsThemeData,
          child: Container(
            key: childKey,
          ),
        ));

        final context = childKey.currentContext;

        final theme = MetricsTheme.of(context);

        expect(theme, equals(metricsThemeData));
      },
    );

    testWidgets(
      ".of() provides the default theme data if the given context does not contain the MetricsTheme",
      (WidgetTester tester) async {
        final materialAppKey = GlobalKey();
        const metricsThemeData = MetricsThemeData(
          metricsWidgetTheme: MetricsWidgetThemeData(
            primaryColor: Colors.grey,
          ),
        );

        await tester.pumpWidget(_MetricsThemeTestbed(
          data: metricsThemeData,
          materialAppKey: materialAppKey,
        ));

        final context = materialAppKey.currentContext;

        final theme = MetricsTheme.of(context);

        expect(theme == metricsThemeData, isFalse);
      },
    );
  });
}

/// A testbed class used to test the [MetricsTheme].
class _MetricsThemeTestbed extends StatelessWidget {
  /// A [MetricsThemeData] provided by the [MetricsTheme].
  final MetricsThemeData data;

  /// A child widget of the [MetricsTheme].
  final Widget child;

  /// A [Key] of the [MaterialApp] widget.
  final Key materialAppKey;

  /// Creates a [_MetricsThemeTestbed].
  ///
  /// If the [child] is not specified, the [Scaffold] used.
  /// If the [data] is not specified, the [LightMetricsThemeData] used.
  const _MetricsThemeTestbed({
    Key key,
    this.child = const Scaffold(),
    this.data = const LightMetricsThemeData(),
    this.materialAppKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: materialAppKey,
      home: MetricsTheme(
        data: data,
        child: child,
      ),
    );
  }
}
