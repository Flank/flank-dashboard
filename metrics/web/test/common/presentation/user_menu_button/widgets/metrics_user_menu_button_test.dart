import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/routes/observers/overlay_entry_route_observer.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/user_menu_button/theme/user_menu_button_theme_data.dart';
import 'package:metrics/common/presentation/user_menu_button/widgets/metrics_user_menu_button.dart';
import 'package:metrics/common/presentation/widgets/metrics_user_menu.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../../test_utils/finder_util.dart';
import '../../../../test_utils/metrics_themed_testbed.dart';
import '../../../../test_utils/test_injection_container.dart';

void main() {
  group('MetricsUserMenuButton', () {
    const activeColor = Colors.red;
    const inactiveColor = Colors.blue;
    const themeData = MetricsThemeData(
      userMenuButtonTheme: UserMenuButtonThemeData(
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ),
    );

    testWidgets(
      'retrieves an OverlayEntryRouteObserver from the context and applies it to the BasePopup',
      (WidgetTester tester) async {
        final overlayEntryRouteObserver = OverlayEntryRouteObserver();

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            _MetricsUserMenuButtonTestbed(
              routeObserver: overlayEntryRouteObserver,
            ),
          );
        });

        final basePopupWidget = tester.widget<BasePopup>(
          find.byType(BasePopup),
        );

        expect(basePopupWidget.routeObserver, overlayEntryRouteObserver);
      },
    );

    testWidgets(
      "displays an open user menu tooltip, when popup is closed",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(_MetricsUserMenuButtonTestbed());
        });

        expect(find.byTooltip(CommonStrings.openUserMenu), findsOneWidget);
      },
    );

    testWidgets(
      "displays a close user menu tooltip, when popup is opened",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(_MetricsUserMenuButtonTestbed());
        });

        await tester.tap(find.byTooltip(CommonStrings.openUserMenu));
        await tester.pumpAndSettle();

        expect(find.byTooltip(CommonStrings.closeUserMenu), findsOneWidget);
      },
    );

    testWidgets(
      "displays an avatar image",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(_MetricsUserMenuButtonTestbed());
        });

        final image = FinderUtil.findNetworkImageWidget(tester);

        expect(image.url, equals("icons/avatar.svg"));
      },
    );

    testWidgets(
      "applies an active color from the metrics theme to the image, when the popup is opened",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(_MetricsUserMenuButtonTestbed(
            metricsThemeData: themeData,
          ));
        });

        await tester.tap(find.byTooltip(CommonStrings.openUserMenu));
        await tester.pumpAndSettle();

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.color, equals(activeColor));
      },
    );

    testWidgets(
      "applies an inactive color from the metrics theme to the image, when the popup is closed",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(_MetricsUserMenuButtonTestbed(
            metricsThemeData: themeData,
          ));
        });

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.color, equals(inactiveColor));
      },
    );

    testWidgets(
      "displays the metrics user menu on the user menu button tap",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_MetricsUserMenuButtonTestbed());
        });

        await tester.tap(find.byType(MetricsUserMenuButton));
        await tester.pumpAndSettle();

        expect(find.byType(MetricsUserMenu), findsOneWidget);
      },
    );

    testWidgets(
      "displays the metrics user menu on the user menu button tap",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_MetricsUserMenuButtonTestbed());
        });

        await tester.tap(find.byType(MetricsUserMenuButton));
        await tester.pumpAndSettle();

        expect(find.byType(MetricsUserMenu), findsOneWidget);
      },
    );

    testWidgets(
      "applies a tappable area to the avatar image",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_MetricsUserMenuButtonTestbed());
        });

        final finder = find.descendant(
          of: find.byTooltip(CommonStrings.openUserMenu),
          matching: find.byType(TappableArea),
        );

        expect(finder, findsOneWidget);
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsUserMenuButton] widget.
class _MetricsUserMenuButtonTestbed extends StatelessWidget {
  /// A [RouteObserver] used in tests.
  final RouteObserver routeObserver;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData metricsThemeData;

  /// Creates the [_MetricsUserMenuButtonTestbed] with the given [routeObserver].
  ///
  /// The [metricsThemeData] defaults to an empty [MetricsThemeData] instance.
  _MetricsUserMenuButtonTestbed({
    Key key,
    RouteObserver routeObserver,
    this.metricsThemeData = const MetricsThemeData(),
  })  : routeObserver = routeObserver ?? RouteObserver(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      child: MetricsThemedTestbed(
        metricsThemeData: metricsThemeData,
        navigatorObservers: [routeObserver],
        body: const MetricsUserMenuButton(),
      ),
    );
  }
}
