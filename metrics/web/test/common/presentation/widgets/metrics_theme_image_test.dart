// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/widgets/metrics_theme_image.dart';
import 'package:metrics/common/presentation/widgets/theme_mode_builder.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/finder_util.dart';
import '../../../test_utils/test_injection_container.dart';
import '../../../test_utils/theme_notifier_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsThemeImage", () {
    const darkAsset = 'dark-asset.svg';
    const lightAsset = 'light-asset.svg';

    testWidgets(
      "throws AssertionError if the given dark asset is null",
      (tester) async {
        await tester.pumpWidget(const _MetricsThemeImageTestbed(
          darkAsset: null,
          lightAsset: lightAsset,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws AssertionError if the given light asset is null",
      (tester) async {
        await tester.pumpWidget(const _MetricsThemeImageTestbed(
          darkAsset: darkAsset,
          lightAsset: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given width to the image",
      (tester) async {
        const expectedWidth = 20.0;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsThemeImageTestbed(
              darkAsset: darkAsset,
              lightAsset: lightAsset,
              width: expectedWidth,
            ),
          );
        });

        final image = FinderUtil.findSvgImage(tester);

        expect(image.width, equals(expectedWidth));
      },
    );

    testWidgets(
      "applies the given height to the image",
      (tester) async {
        const expectedHeight = 20.0;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsThemeImageTestbed(
              darkAsset: darkAsset,
              lightAsset: lightAsset,
              height: expectedHeight,
            ),
          );
        });

        final image = FinderUtil.findSvgImage(tester);

        expect(image.height, equals(expectedHeight));
      },
    );

    testWidgets(
      "applies the given fit to the image",
      (tester) async {
        const expectedFit = BoxFit.contain;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsThemeImageTestbed(
              darkAsset: darkAsset,
              lightAsset: lightAsset,
              fit: expectedFit,
            ),
          );
        });

        final image = FinderUtil.findSvgImage(tester);

        expect(image.fit, equals(expectedFit));
      },
    );

    testWidgets(
      "displays a theme mode builder to build the image widget",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsThemeImageTestbed(
              darkAsset: darkAsset,
              lightAsset: lightAsset,
            ),
          );
        });

        final themeTypeBuilderFinder = find.ancestor(
          of: find.byType(SvgImage),
          matching: find.byType(ThemeModeBuilder),
        );

        expect(themeTypeBuilderFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the dark asset if the current theme mode is dark",
      (tester) async {
        final notifierMock = ThemeNotifierMock();

        when(notifierMock.isDark).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _MetricsThemeImageTestbed(
              themeNotifier: notifierMock,
              darkAsset: darkAsset,
              lightAsset: lightAsset,
            ),
          );
        });

        final image = FinderUtil.findSvgImage(tester);
        final asset = image.src;

        expect(asset, equals(darkAsset));
      },
    );

    testWidgets(
      "displays the light asset if the current theme mode is dark",
      (tester) async {
        final notifierMock = ThemeNotifierMock();

        when(notifierMock.isDark).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _MetricsThemeImageTestbed(
              themeNotifier: notifierMock,
              darkAsset: darkAsset,
              lightAsset: lightAsset,
            ),
          );
        });

        final image = FinderUtil.findSvgImage(tester);
        final asset = image.src;

        expect(asset, equals(lightAsset));
      },
    );
  });
}

/// A testbed class used to test the [MetricsThemeImage].
class _MetricsThemeImageTestbed extends StatelessWidget {
  /// A [ThemeNotifier] to use in tests.
  final ThemeNotifier themeNotifier;

  /// An dark asset to apply to the widget under tests.
  final String darkAsset;

  /// An light asset to apply to the widget under tests.
  final String lightAsset;

  /// A width of the displayed asset.
  final double width;

  /// A height of the displayed asset.
  final double height;

  /// A parameter that controls how to inscribe an asset into the space
  /// allocated during layout.
  final BoxFit fit;

  /// Creates a new instance of the metrics theme mode image testbed.
  const _MetricsThemeImageTestbed({
    Key key,
    this.themeNotifier,
    this.darkAsset,
    this.lightAsset,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestInjectionContainer(
        themeNotifier: themeNotifier,
        child: MetricsThemeImage(
          darkAsset: darkAsset,
          lightAsset: lightAsset,
          width: width,
          height: height,
          fit: fit,
        ),
      ),
    );
  }
}
