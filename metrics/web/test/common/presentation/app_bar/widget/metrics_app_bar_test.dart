import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../../test_utils/test_injection_container.dart';

void main() {
  group("MetricsAppBar", () {
    testWidgets("displays the app logo", (WidgetTester tester) async {
      await mockNetworkImagesFor(() {
        return tester.pumpWidget(const _MetricsAppBarTestbed());
      });

      final finder = find.descendant(
        of: find.byTooltip(CommonStrings.home),
        matching: find.byType(Image),
      );

      expect(finder, findsOneWidget);
    });

    testWidgets(
      "applies a hand cursor to the app logo",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsAppBarTestbed());
        });

        final finder = find.descendant(
          of: find.byTooltip(CommonStrings.home),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets("displays the user menu icon", (WidgetTester tester) async {
      await mockNetworkImagesFor(() {
        return tester.pumpWidget(const _MetricsAppBarTestbed());
      });

      final finder = find.descendant(
        of: find.byTooltip(CommonStrings.openUserMenu),
        matching: find.byType(Image),
      );

      expect(finder, findsOneWidget);
    });

    testWidgets(
      "applies a hand cursor to the user menu icon",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsAppBarTestbed());
        });

        final finder = find.descendant(
          of: find.byTooltip(CommonStrings.openUserMenu),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "navigates to the dashboard page when the app logo is tapped",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsAppBarTestbed());
        });

        await tester.tap(
          find.byTooltip(CommonStrings.home),
        );
        await mockNetworkImagesFor(() {
          return tester.pumpAndSettle();
        });

        expect(find.byType(DashboardPage), findsOneWidget);
      },
    );

    testWidgets(
      "app bar width equals to the dimensions config content width",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsAppBarTestbed());
        });

        final sizedBox = tester.widget<SizedBox>(find.descendant(
          of: find.byType(MetricsAppBar),
          matching: find.byType(SizedBox),
        ));

        expect(sizedBox.width, DimensionsConfig.contentWidth);
      },
    );

    testWidgets(
      "app bar height equals to the dimensions config app bar height",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsAppBarTestbed());
        });

        final sizedBox = tester.widget<SizedBox>(find.descendant(
          of: find.byType(MetricsAppBar),
          matching: find.byType(SizedBox),
        ));

        expect(sizedBox.height, DimensionsConfig.appBarHeight);
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsAppBar] widget.
class _MetricsAppBarTestbed extends StatelessWidget {
  /// Creates the [_MetricsAppBarTestbed].
  const _MetricsAppBarTestbed({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      child: MaterialApp(
        routes: {
          '/dashboard': (context) => DashboardPage(),
        },
        home: const Scaffold(
          body: MetricsAppBar(),
        ),
      ),
    );
  }
}
