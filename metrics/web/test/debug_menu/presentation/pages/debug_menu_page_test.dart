// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_negative_button.dart';
import 'package:metrics/common/presentation/metrics_theme/model/debug_menu/theme_data/debug_menu_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_text/style/metrics_text_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/page_title/widgets/metrics_page_title.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/debug_menu/presentation/pages/debug_menu_page.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/strings/debug_menu_strings.dart';
import 'package:metrics/debug_menu/presentation/widgets/debug_menu_fps_monitor_toggle.dart';
import 'package:metrics/debug_menu/presentation/widgets/debug_menu_renderer_display.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
import 'package:metrics/feature_config/presentation/view_models/debug_menu_feature_config_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/feature_config_notifier_mock.dart';
import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("DebugMenuPage", () {
    const headerStyle = MetricsTextStyle(lineHeightInPixels: 10);
    const dividerColor = Colors.grey;

    const metricsThemeData = MetricsThemeData(
      debugMenuTheme: DebugMenuThemeData(
        sectionHeaderTextStyle: headerStyle,
        sectionDividerColor: dividerColor,
      ),
    );

    const disabledDebugMenu = DebugMenuFeatureConfigViewModel(isEnabled: false);

    testWidgets(
      "displays the metrics page title widget with the debug menu page text",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _DebugMenuPageTestbed(),
          );
        });

        final finder =
            find.widgetWithText(MetricsPageTitle, CommonStrings.debugMenu);

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the debug menu is disabled text if the debug menu is disabled",
      (WidgetTester tester) async {
        final featureConfigNotifier = FeatureConfigNotifierMock();
        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          disabledDebugMenu,
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _DebugMenuPageTestbed(
              featureConfigNotifier: featureConfigNotifier,
            ),
          );
        });

        expect(find.text(DebugMenuStrings.debugMenuDisabled), findsOneWidget);
      },
    );

    testWidgets(
      "applies the content header text style from the metrics theme to the debug menu is disabled text",
      (WidgetTester tester) async {
        final featureConfigNotifier = FeatureConfigNotifierMock();
        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          disabledDebugMenu,
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _DebugMenuPageTestbed(
              featureConfigNotifier: featureConfigNotifier,
              metricsThemeData: metricsThemeData,
            ),
          );
        });

        final disabledDebugMenuText = tester.widget<Text>(
          find.text(DebugMenuStrings.debugMenuDisabled),
        );

        expect(disabledDebugMenuText.style, equals(headerStyle));
      },
    );

    testWidgets(
      "displays the fps monitor toggle widget",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _DebugMenuPageTestbed(),
          );
        });

        expect(find.byType(DebugMenuFpsMonitorToggle), findsOneWidget);
      },
    );

    testWidgets(
      "displays the renderer display widget",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _DebugMenuPageTestbed(),
          );
        });

        expect(find.byType(DebugMenuRendererDisplay), findsOneWidget);
      },
    );

    testWidgets(
      "throws the exception when the throw exception button is pressed",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _DebugMenuPageTestbed(),
          );
        });

        final finder = find.widgetWithText(
          MetricsNegativeButton,
          DebugMenuStrings.throwException,
        );
        await tester.tap(finder);

        expect(tester.takeException(), isNotNull);
      },
    );

    testWidgets(
      "applies the section header text style from the metrics theme to performance section header",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _DebugMenuPageTestbed(
              metricsThemeData: metricsThemeData,
            ),
          );
        });

        final header = tester.widget<Text>(
          find.text(DebugMenuStrings.performance),
        );

        expect(header.style, equals(headerStyle));
      },
    );

    testWidgets(
      "applies the divider color from the metrics theme",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _DebugMenuPageTestbed(
              metricsThemeData: metricsThemeData,
            ),
          );
        });

        final dividers = tester.widgetList<Divider>(find.byType(Divider));
        final colors = dividers.map((divider) => divider.color);

        expect(colors, everyElement(equals(dividerColor)));
      },
    );
  });
}

/// A testbed class needed to test the [DebugMenuPage].
class _DebugMenuPageTestbed extends StatelessWidget {
  /// A [DebugMenuNotifier] to use under tests.
  final DebugMenuNotifier debugMenuNotifier;

  /// A [FeatureConfigNotifier] to use under tests.
  final FeatureConfigNotifier featureConfigNotifier;

  /// A [MetricsThemeData] to use under tests.
  final MetricsThemeData metricsThemeData;

  /// Creates a new instance of this testbed with the given parameters.
  ///
  /// A [metricsThemeData] defaults to the [MetricsThemeData] instance.
  const _DebugMenuPageTestbed({
    Key key,
    this.debugMenuNotifier,
    this.featureConfigNotifier,
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      debugMenuNotifier: debugMenuNotifier,
      featureConfigNotifier: featureConfigNotifier,
      child: MetricsThemedTestbed(
        metricsThemeData: metricsThemeData,
        body: const DebugMenuPage(),
      ),
    );
  }
}
