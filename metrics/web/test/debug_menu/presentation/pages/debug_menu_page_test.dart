import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/debug_menu/theme_data/debug_menu_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_text/style/metrics_text_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/page_title/widgets/metrics_page_title.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/debug_menu/presentation/pages/debug_menu_page.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/view_models/fps_monitor_local_config_view_model.dart';
import 'package:metrics/debug_menu/presentation/widgets/metrics_fps_monitor_toggle.dart';
import 'package:metrics/debug_menu/presentation/widgets/metrics_renderer_display.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/debug_menu_notifier_mock.dart';
import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("DebugMenuPage", () {
    const metricsThemeData = MetricsThemeData(
      debugMenuTheme: DebugMenuThemeData(
        sectionHeaderTextStyle: MetricsTextStyle(
          lineHeightInPixels: 10,
        ),
        sectionDividerColor: Colors.grey,
      ),
    );

    DebugMenuNotifier debugMenuNotifier;

    setUp(() {
      debugMenuNotifier = DebugMenuNotifierMock();
    });

    testWidgets(
      "displays the metrics page title widget with the debug menu page text",
      (WidgetTester tester) async {
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: true),
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _DebugMenuPageTestbed(
              debugMenuNotifier: debugMenuNotifier,
            ),
          );
        });

        expect(
          find.widgetWithText(MetricsPageTitle, CommonStrings.debugMenu),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays the metrics fps monitor toggle widget",
      (WidgetTester tester) async {
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: true),
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _DebugMenuPageTestbed(
              debugMenuNotifier: debugMenuNotifier,
            ),
          );
        });

        expect(find.byType(MetricsFpsMonitorToggle), findsOneWidget);
      },
    );

    testWidgets(
      "displays the metrics renderer display widget",
      (WidgetTester tester) async {
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: true),
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _DebugMenuPageTestbed(
              debugMenuNotifier: debugMenuNotifier,
            ),
          );
        });

        expect(find.byType(MetricsRendererDisplay), findsOneWidget);
      },
    );

    testWidgets(
      "applies the section header text style from the metrics theme",
      (WidgetTester tester) async {
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: true),
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _DebugMenuPageTestbed(
              debugMenuNotifier: debugMenuNotifier,
              metricsThemeData: metricsThemeData,
            ),
          );
        });

        final header = tester.widget<Text>(
          find.text(CommonStrings.performance),
        );

        final expectedTextStyle =
            metricsThemeData.debugMenuTheme.sectionHeaderTextStyle;

        expect(header.style, equals(expectedTextStyle));
      },
    );

    testWidgets(
      "applies the divider color from the metrics theme",
      (WidgetTester tester) async {
        when(debugMenuNotifier.fpsMonitorLocalConfigViewModel).thenReturn(
          const FpsMonitorLocalConfigViewModel(isEnabled: true),
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _DebugMenuPageTestbed(
              debugMenuNotifier: debugMenuNotifier,
              metricsThemeData: metricsThemeData,
            ),
          );
        });

        final divider = tester.widget<Divider>(find.byType(Divider));

        final expectedColor =
            metricsThemeData.debugMenuTheme.sectionDividerColor;

        expect(divider.color, equals(expectedColor));
      },
    );
  });
}

/// A testbed class needed to test the [DebugMenuPage].
class _DebugMenuPageTestbed extends StatelessWidget {
  /// A [DebugMenuNotifier] to use under tests.
  final DebugMenuNotifier debugMenuNotifier;

  /// A [MetricsThemeData] to use under tests.
  final MetricsThemeData metricsThemeData;

  /// Creates a new instance of this testbed with the given [debugMenuNotifier].
  const _DebugMenuPageTestbed({
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
        body: const DebugMenuPage(),
      ),
    );
  }
}
