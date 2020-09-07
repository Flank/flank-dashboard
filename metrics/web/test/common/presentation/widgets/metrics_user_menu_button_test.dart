import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/common/presentation/routes/observers/overlay_entry_route_observer.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_user_menu.dart';
import 'package:metrics/common/presentation/widgets/metrics_user_menu_button.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/finder_util.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group('MetricsUserMenuButton', () {
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
      "displays an avatar image, when the popup is closed",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(_MetricsUserMenuButtonTestbed());
        });

        final image = FinderUtil.findNetworkImageWidget(tester);

        expect(image.url, equals("icons/avatar.svg"));
      },
    );

    testWidgets(
      "displays an avatar active image, when the popup is opened",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(_MetricsUserMenuButtonTestbed());
        });

        await tester.tap(find.byTooltip(CommonStrings.openUserMenu));
        await tester.pumpAndSettle();

        final image = FinderUtil.findNetworkImageWidget(tester);

        expect(image.url, equals("icons/avatar_active.svg"));
      },
    );

    testWidgets(
      "applies a hand cursor to the user menu image",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_MetricsUserMenuButtonTestbed());
        });

        final finder = find.ancestor(
          of: find.byType(Image),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
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
  });
}

/// A testbed widget, used to test the [MetricsUserMenuButton] widget.
class _MetricsUserMenuButtonTestbed extends StatelessWidget {
  /// A [RouteObserver] used in tests.
  final RouteObserver routeObserver;

  /// Creates the [_MetricsUserMenuButtonTestbed] with the given [routeObserver].
  _MetricsUserMenuButtonTestbed({
    Key key,
    RouteObserver routeObserver,
  })  : routeObserver = routeObserver ?? RouteObserver(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        home: const Scaffold(
          body: MetricsUserMenuButton(),
        ),
      ),
    );
  }
}
