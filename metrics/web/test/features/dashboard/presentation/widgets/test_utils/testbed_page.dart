import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A widget that contains default page configuration used in tests.
class TestbedPage extends StatelessWidget {
  final MetricsThemeData metricsThemeData;
  final Widget body;

  const TestbedPage({
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
