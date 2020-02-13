import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';

void main() {
  testWidgets(
    "Can't be created when the child is null",
    (WidgetTester tester) async {
      await tester.pumpWidget(const MetricsThemeTestbed(child: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Can't be created without data",
    (WidgetTester tester) async {
      await tester.pumpWidget(const MetricsThemeTestbed(data: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );
}

class MetricsThemeTestbed extends StatelessWidget {
  final MetricsThemeData data;
  final Widget child;

  const MetricsThemeTestbed({
    Key key,
    this.child = const Scaffold(),
    this.data = const MetricsThemeData.light(),
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
