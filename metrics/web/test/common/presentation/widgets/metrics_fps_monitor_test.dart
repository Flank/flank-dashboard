import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_fps_monitor.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/view_models/fps_monitor_local_config_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:statsfl/statsfl.dart';

import '../../../test_utils/debug_menu_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsFPSMonitor", () {
    DebugMenuNotifier debugMenuNotifier;

    setUp(() {
      debugMenuNotifier = DebugMenuNotifierMock();
    });

    testWidgets(
      "throws an AssertionError if the given child is null",
      (tester) async {
        await tester.pumpWidget(
          const _MetricsFPSMonitorTestbed(child: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given child",
      (tester) async {
        const child = Text('child');

        await tester.pumpWidget(
          const _MetricsFPSMonitorTestbed(child: child),
        );

        expect(find.byWidget(child), findsOneWidget);
      },
    );

    testWidgets(
      "displays the disabled FPS monitor if the fps monitor view model is not initialized",
      (tester) async {
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(null);

        await tester.pumpWidget(
          _MetricsFPSMonitorTestbed(
            debugMenuNotifier: debugMenuNotifier,
          ),
        );

        final statsFlWidget = tester.widget<StatsFl>(find.byType(StatsFl));

        expect(statsFlWidget.isEnabled, isFalse);
      },
    );

    testWidgets(
      "displays the enabled FPS monitor if it is enabled in the debug menu notifier",
      (tester) async {
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: true),
        );

        await tester.pumpWidget(
          _MetricsFPSMonitorTestbed(
            debugMenuNotifier: debugMenuNotifier,
          ),
        );

        final statsFlWidget = tester.widget<StatsFl>(find.byType(StatsFl));

        expect(statsFlWidget.isEnabled, isTrue);
      },
    );

    testWidgets(
      "displays the disabled FPS monitor if it is disabled in the debug menu notifier",
      (tester) async {
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: false),
        );

        await tester.pumpWidget(
          _MetricsFPSMonitorTestbed(
            debugMenuNotifier: debugMenuNotifier,
          ),
        );

        final statsFlWidget = tester.widget<StatsFl>(find.byType(StatsFl));

        expect(statsFlWidget.isEnabled, isFalse);
      },
    );
  });
}

/// A testbed class needed to test the [MetricsFPSMonitor] widget.
class _MetricsFPSMonitorTestbed extends StatelessWidget {
  /// A default child widget used in tests.
  static const Widget _defaultChild = Text('default text');

  /// A widget to display.
  final Widget child;

  /// A [DebugMenuNotifier] to use in tests.
  final DebugMenuNotifier debugMenuNotifier;

  /// Creates a new instance of the metrics FPS monitor testbed.
  ///
  /// The [child] defaults to [_defaultChild].
  const _MetricsFPSMonitorTestbed({
    Key key,
    this.child = _defaultChild,
    this.debugMenuNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      debugMenuNotifier: debugMenuNotifier,
      child: MaterialApp(
        home: Scaffold(
          body: MetricsFPSMonitor(
            child: Focus(
              autofocus: true,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
