import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/fps_monitor.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("FPSMonitor", () {
    final containerFinder = find.descendant(
      of: find.byType(FPSMonitor),
      matching: find.byType(Container).first,
    );

    testWidgets(
      "throws an AssertionError if the given child is null",
      (tester) async {
        await tester.pumpWidget(const _FPSMonitorTestbed(child: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given width is null",
      (tester) async {
        await tester.pumpWidget(const _FPSMonitorTestbed(width: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given height is null",
      (tester) async {
        await tester.pumpWidget(const _FPSMonitorTestbed(height: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given width",
      (tester) async {},
    );

    testWidgets(
      "applies the given height",
      (tester) async {},
    );

    testWidgets(
      "applies the given is enabled parameter to the statsfl widget",
      (tester) async {},
    );

    testWidgets(
      "displays the given child",
      (tester) async {},
    );
  });
}

/// A testbed class required to test the [FPSMonitor] widget.
class _FPSMonitorTestbed extends StatelessWidget {
  /// A default child widget used in tests.
  static const Widget _defaultChild = Text('default text');

  /// A child widget to be displayed.
  final Widget child;

  /// A width of the [FPSMonitor].
  final double width;

  /// A height of the [FPSMonitor].
  final double height;

  /// Enable or disable the [FPSMonitor].
  final bool isEnabled;

  /// Creates a new instance of the fps monitor testbed.
  ///
  /// The [child] defaults to the [_defaultChild].
  /// The [isEnabled] defaults to `false`.
  const _FPSMonitorTestbed({
    Key key,
    this.width = 130,
    this.height = 40,
    this.child = _defaultChild,
    this.isEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FPSMonitor(
          isEnabled: isEnabled,
          height: height,
          width: width,
          child: child,
        ),
      ),
    );
  }
}
