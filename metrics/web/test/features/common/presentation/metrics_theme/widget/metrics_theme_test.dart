import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';

void main() {
  testWidgets(
    "Can't be created when the child is null",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _MetricsThemeTestbed(child: null));

      expect(tester.takeException(), isAssertionError);
    },
  );

  testWidgets(
    "Can't be created without data",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _MetricsThemeTestbed(data: null));

      expect(tester.takeException(), isAssertionError);
    },
  );
}

class _MetricsThemeTestbed extends StatelessWidget {
  final MetricsThemeData data;
  final Widget child;

  const _MetricsThemeTestbed({
    Key key,
    this.child = const Scaffold(),
    this.data = const LightMetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MetricsTheme(
        data: data,
        child: child,
      ),
    );
  }
}
