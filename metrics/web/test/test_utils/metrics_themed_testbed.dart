import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// Metrics themed page used in tests.
class MetricsThemedTestbed extends StatelessWidget {
  final MetricsThemeData metricsThemeData;
  final Widget body;

  /// Creates the [MetricsThemedTestbed] with the given [metricsThemeData].
  ///
  /// If the [metricsThemeData] not passed, the default [MetricsThemeData] used.
  const MetricsThemedTestbed({
    @required this.body,
    this.metricsThemeData = const MetricsThemeData(),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsTheme(
          data: metricsThemeData,
          child: body,
        ),
      ),
    );
  }
}
