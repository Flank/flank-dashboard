import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/debug_menu/theme_data/debug_menu_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_text/style/metrics_text_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/toggle/widgets/toggle.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/view_models/fps_monitor_local_config_view_model.dart';
import 'package:metrics/debug_menu/presentation/widgets/metrics_fps_monitor_toggle.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/debug_menu_notifier_mock.dart';
import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("MetricsFpsMonitorToggle", () {
    const metricsThemeData = MetricsThemeData(
      debugMenuTheme: DebugMenuThemeData(
        sectionContentTextStyle: MetricsTextStyle(
          lineHeightInPixels: 10,
        ),
      ),
    );

    DebugMenuNotifierMock debugMenuNotifier;
    final toggleFinder = find.byType(Toggle);

    setUp(() {
      debugMenuNotifier = DebugMenuNotifierMock();
    });

    testWidgets(
      "displays the fps monitor text",
      (WidgetTester tester) async {
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: true),
        );

        await tester.pumpWidget(
          _MetricsFpsMonitorToggleTestbed(
            debugMenuNotifier: debugMenuNotifier,
          ),
        );

        expect(find.text(CommonStrings.fpsMonitor), findsOneWidget);
      },
    );

    testWidgets(
      "displays the toggle widget",
      (WidgetTester tester) async {
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: true),
        );

        await tester.pumpWidget(
          _MetricsFpsMonitorToggleTestbed(
            debugMenuNotifier: debugMenuNotifier,
          ),
        );

        expect(toggleFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the section content text style from the metrics theme",
      (WidgetTester tester) async {
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: true),
        );

        await tester.pumpWidget(
          _MetricsFpsMonitorToggleTestbed(
            debugMenuNotifier: debugMenuNotifier,
            metricsThemeData: metricsThemeData,
          ),
        );

        final content = tester.widget<Text>(
          find.text(CommonStrings.fpsMonitor),
        );

        final expectedStyle =
            metricsThemeData.debugMenuTheme.sectionContentTextStyle;

        expect(content.style, equals(expectedStyle));
      },
    );

    testWidgets(
      "displays the toggle widget with the false value if the fps monitor is disabled in debug menu notifier",
      (WidgetTester tester) async {
        const isFpsMonitorEnabled = false;
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: isFpsMonitorEnabled),
        );

        await tester.pumpWidget(
          _MetricsFpsMonitorToggleTestbed(
            debugMenuNotifier: debugMenuNotifier,
          ),
        );

        final toggle = tester.widget<Toggle>(toggleFinder);

        expect(toggle.value, equals(isFpsMonitorEnabled));
      },
    );

    testWidgets(
      "displays the toggle widget with the true value if the fps monitor is enabled in debug menu notifier",
      (WidgetTester tester) async {
        const isFpsMonitorEnabled = true;
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: isFpsMonitorEnabled),
        );

        await tester.pumpWidget(
          _MetricsFpsMonitorToggleTestbed(
            debugMenuNotifier: debugMenuNotifier,
          ),
        );

        final toggle = tester.widget<Toggle>(toggleFinder);

        expect(toggle.value, equals(isFpsMonitorEnabled));
      },
    );

    testWidgets(
      "calls the .toggleFpsMonitor() method of the debug menu notifier on tap",
      (WidgetTester tester) async {
        const isFpsMonitorEnabled = true;
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: isFpsMonitorEnabled),
        );

        await tester.pumpWidget(
          _MetricsFpsMonitorToggleTestbed(
            debugMenuNotifier: debugMenuNotifier,
          ),
        );

        await tester.tap(toggleFinder);

        verify(debugMenuNotifier.toggleFpsMonitor()).called(1);
      },
    );
  });
}

/// A testbed class needed to test the [MetricsFpsMonitorToggle] widget.
class _MetricsFpsMonitorToggleTestbed extends StatelessWidget {
  /// A [DebugMenuNotifier] to use under tests.
  final DebugMenuNotifier debugMenuNotifier;

  /// A [MetricsThemeData] to use under tests.
  final MetricsThemeData metricsThemeData;

  /// Creates a new instance of this testbed with the given [debugMenuNotifier].
  const _MetricsFpsMonitorToggleTestbed({
    Key key,
    this.debugMenuNotifier,
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      debugMenuNotifier: debugMenuNotifier,
      child: MetricsThemedTestbed(
        metricsThemeData: metricsThemeData,
        body: const MetricsFpsMonitorToggle(),
      ),
    );
  }
}
