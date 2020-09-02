import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
import 'package:metrics/common/presentation/routes/observers/overlay_entry_route_observer.dart';
import 'package:metrics/common/presentation/widgets/metrics_user_menu.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('MetricsUserMenu', () {
    testWidgets(
      'retrieves an OverlayEntryRouteObserver from the context and applies it to the BasePopup',
      (WidgetTester tester) async {
        final overlayEntryRouteObserver = OverlayEntryRouteObserver();

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            _MetricsUserMenuTestbed(
              overlayEntryRouteObserver: overlayEntryRouteObserver,
            ),
          );
        });

        final basePopupWidget = tester.widget<BasePopup>(
          find.byType(BasePopup),
        );

        expect(basePopupWidget.routeObserver, overlayEntryRouteObserver);
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsUserMenu] widget.
class _MetricsUserMenuTestbed extends StatelessWidget {
  /// An [OverlayEntryRouteObserver] used in tests.
  final OverlayEntryRouteObserver overlayEntryRouteObserver;

  /// Creates the [_MetricsUserMenuTestbed] with the given [overlayEntryRouteObserver].
  const _MetricsUserMenuTestbed({
    Key key,
    this.overlayEntryRouteObserver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [overlayEntryRouteObserver],
      home: const Scaffold(
        body: MetricsUserMenu(),
      ),
    );
  }
}
