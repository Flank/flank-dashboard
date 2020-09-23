import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_fps_monitor.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsFPSMonitor", () {
    testWidgets(
      "throws an AssertionError if the given child is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsFPSMonitorTestbed(child: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given child",
      (WidgetTester tester) async {},
    );
  });
}

/// A testbed class needed to test the [MetricsFPSMonitor] widget.
class _MetricsFPSMonitorTestbed extends StatelessWidget {
  /// A widget to display.
  final Widget child;

  /// Created a new [_MetricsFPSMonitorTestbed] instance.
  const _MetricsFPSMonitorTestbed({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsFPSMonitor(
          child: child,
        ),
      ),
    );
  }
}
