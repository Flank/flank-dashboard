import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_fps_monitor.dart';
import 'package:statsfl/statsfl.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsFPSMonitor", () {
    const child = Text('child');

    testWidgets(
      "throws an AssertionError if the given child is null",
      (tester) async {
        await tester.pumpWidget(
          const _MetricsFPSMonitorTestbed(child: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets("displays the given child", (tester) async {
      await tester.pumpWidget(
        const _MetricsFPSMonitorTestbed(child: child),
      );

      expect(find.byWidget(child), findsOneWidget);
    });

    testWidgets(
      "enable status of the statsfl widget is false initially",
      (tester) async {
        await tester.pumpWidget(
          const _MetricsFPSMonitorTestbed(child: child),
        );

        final statsFlWidget = tester.widget<StatsFl>(find.byType(StatsFl));

        expect(statsFlWidget.isEnabled, isFalse);
      },
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
