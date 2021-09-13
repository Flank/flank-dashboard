// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/material_container.dart';
import 'package:metrics/common/presentation/manufacturer_banner/theme/theme_data/manufacturer_banner_theme_data.dart';
import 'package:metrics/common/presentation/manufacturer_banner/widget/manufacturer_banner.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../../test_utils/finder_util.dart';
import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ManufacturerBanner", () {
    AnimatedBuilder getAnimatedBuilder(WidgetTester tester) {
      return tester.widget<AnimatedBuilder>(
        find.descendant(
          of: find.byType(MouseRegion),
          matching: find.byType(AnimatedBuilder),
        ),
      );
    }

    MouseRegion getMouseRegion(WidgetTester tester) {
      return tester.widget<MouseRegion>(find.ancestor(
        of: find.byType(AnimatedBuilder),
        matching: find.byType(MouseRegion),
      ));
    }

    void closeBanner(MouseRegion mouseRegion, WidgetTester tester) {
      mouseRegion.onEnter(null);
      mouseRegion.onExit(null);
    }

    testWidgets(
      "displays the material container",
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _ManufacturerBannerTestbed());
        });

        final materialContainerFinder = find.byType(MaterialContainer);

        expect(materialContainerFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the manufacturer logo svg image",
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _ManufacturerBannerTestbed());
        });

        final imageWidget = FinderUtil.findSvgImage(tester);

        expect(imageWidget.src, equals('icons/solid_logo.svg'));
      },
    );

    testWidgets(
      "displays the `Built by Solid Software` text",
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _ManufacturerBannerTestbed());
        });

        final manufacturerText = find.text(CommonStrings.builtBySolidSoftware);

        expect(manufacturerText, findsOneWidget);
      },
    );

    testWidgets(
      "applies the background color from the Metrics theme",
      (tester) async {
        const expectedBackgroundColor = Colors.grey;
        const manufacturerBannerThemeData = ManufacturerBannerThemeData(
          backgroundColor: expectedBackgroundColor,
        );
        const metricsTheme = MetricsThemeData(
          manufacturerBannerThemeData: manufacturerBannerThemeData,
        );

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _ManufacturerBannerTestbed(
            themeData: metricsTheme,
          ));
        });

        final materialContainerWidget = tester.widget<MaterialContainer>(
          find.byType(MaterialContainer),
        );

        expect(
          materialContainerWidget.backgroundColor,
          equals(expectedBackgroundColor),
        );
      },
    );

    testWidgets(
      "applies a text style from the Metrics theme to the `Built by Solid Software` text",
      (tester) async {
        const expectedTextStyle = TextStyle(fontSize: 20.0);
        const manufacturerBannerThemeData = ManufacturerBannerThemeData(
          textStyle: expectedTextStyle,
        );
        const metricsTheme = MetricsThemeData(
          manufacturerBannerThemeData: manufacturerBannerThemeData,
        );

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _ManufacturerBannerTestbed(
            themeData: metricsTheme,
          ));
        });

        final textWidget = tester.widget<Text>(
          find.text(CommonStrings.builtBySolidSoftware),
        );

        expect(textWidget.style, equals(expectedTextStyle));
      },
    );

    testWidgets(
      "closes after the preview period finished",
      (tester) async {
        final fakeAsync = FakeAsync();

        // ignore: unawaited_futures
        fakeAsync.run((async) async {
          await mockNetworkImagesFor(() async {
            await tester.pumpWidget(const _ManufacturerBannerTestbed());
          });

          async.elapse(const Duration(seconds: 10));

          await tester.pumpAndSettle();

          final animatedBuilderWidget = getAnimatedBuilder(tester);

          final animationController =
              animatedBuilderWidget.listenable as AnimationController;

          expect(animationController.value, isZero);
        });

        fakeAsync.flushMicrotasks();
      },
    );

    testWidgets(
      "closes when not hovered",
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _ManufacturerBannerTestbed());
        });

        final mouseRegionWidget = getMouseRegion(tester);
        closeBanner(mouseRegionWidget, tester);

        await tester.pumpAndSettle();

        final animatedBuilderWidget = getAnimatedBuilder(tester);
        final animationController =
            animatedBuilderWidget.listenable as AnimationController;

        expect(animationController.value, isZero);
      },
    );

    testWidgets(
      "opens when hovered",
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _ManufacturerBannerTestbed());
        });

        final mouseRegionWidget = getMouseRegion(tester);
        closeBanner(mouseRegionWidget, tester);

        await tester.pumpAndSettle();

        mouseRegionWidget.onEnter(null);

        await tester.pumpAndSettle();

        final animatedBuilderWidget = getAnimatedBuilder(tester);
        final animationController =
            animatedBuilderWidget.listenable as AnimationController;

        expect(animationController.value, equals(1));
      },
    );

    testWidgets(
      "disposes animation controller on widget dispose",
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _ManufacturerBannerTestbed());
        });

        final animatedBuilderWidget = getAnimatedBuilder(tester);
        final animationController =
            animatedBuilderWidget.listenable as AnimationController;

        await tester.pumpWidget(Container());

        expect(animationController.dispose, throwsFlutterError);
      },
    );

    testWidgets(
      "cancels the preview timer on widget dispose",
      (tester) async {
        final fakeAsync = FakeAsync();

        // ignore: unawaited_futures
        await fakeAsync.run((_) async {
          await mockNetworkImagesFor(() async {
            await tester.pumpWidget(const _ManufacturerBannerTestbed());
          });
        });
        fakeAsync.flushMicrotasks();

        await tester.pumpWidget(Container());

        expect(fakeAsync.pendingTimers, isEmpty);
      },
    );
  });
}

/// A testbed class used to test the [ManufacturerBanner] widget.
class _ManufacturerBannerTestbed extends StatelessWidget {
  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData themeData;

  /// Creates a new instance of the [_ManufacturerBannerTestbed].
  ///
  /// The [themeData] defaults to [MetricsThemeData].
  const _ManufacturerBannerTestbed({
    Key key,
    this.themeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: themeData,
      body: const ManufacturerBanner(),
    );
  }
}
