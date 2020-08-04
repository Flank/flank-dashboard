import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// Metrics themed page used in tests.
class MetricsThemedTestbed extends StatelessWidget {
  /// A [ThemeData] used in tests.
  final ThemeData themeData;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData metricsThemeData;

  /// The primary content of the scaffold.
  final Widget body;

  /// A [GlobalKey] used to get a [NavigatorState] in tests.
  final GlobalKey<NavigatorState> navigatorKey;

  /// A [MaterialApp.onGenerateRoute] callback to use in tests.
  final RouteFactory onGenerateRoute;

  /// Creates the [MetricsThemedTestbed] with the given [metricsThemeData].
  ///
  /// If the [metricsThemeData] not passed, the default [MetricsThemeData] used.
  const MetricsThemedTestbed({
    @required this.body,
    this.metricsThemeData = const MetricsThemeData(),
    this.themeData,
    this.navigatorKey,
    this.onGenerateRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: themeData,
      onGenerateRoute: onGenerateRoute,
      home: Scaffold(
        body: MetricsTheme(
          data: metricsThemeData,
          child: body,
        ),
      ),
    );
  }
}
