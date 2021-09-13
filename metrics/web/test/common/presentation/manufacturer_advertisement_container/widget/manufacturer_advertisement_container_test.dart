// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/manufacturer_advertisement_container/widget/manufacturer_advertisement_container.dart';
import 'package:metrics/common/presentation/manufacturer_banner/widget/manufacturer_banner.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group("ManufacturerAdvertisementContainer", () {
    final Key childKey = GlobalKey();
    final Widget child = Text('Child widget', key: childKey);

    testWidgets(
      "throws an AssertionError if the isEnabled parameter is null",
      (tester) async {
        expect(
          () => ManufacturerAdvertisementContainer(
            isEnabled: null,
            child: child,
          ),
          throwsAssertionError,
        );
      },
    );

    testWidgets(
      "throws an AssertionError if the child parameter is null",
      (tester) async {
        expect(
          () => ManufacturerAdvertisementContainer(
            isEnabled: true,
            child: null,
          ),
          throwsAssertionError,
        );
      },
    );

    testWidgets(
      "shows the widget passed to the child parameter",
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ManufacturerAdvertisementContainer(
                isEnabled: false,
                child: child,
              ),
            ),
          ),
        );

        final childWidgetFinder = find.byKey(childKey);

        expect(childWidgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "shows the manufacturer banner if isEnabled parameter is true",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ManufacturerAdvertisementContainer(
                  isEnabled: true,
                  child: child,
                ),
              ),
            ),
          );
        });

        final manufacturerBannerFinder = find.byType(ManufacturerBanner);

        expect(manufacturerBannerFinder, findsOneWidget);
      },
    );

    testWidgets(
      "does not show the manufacturer banner if isEnabled parameter is false",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ManufacturerAdvertisementContainer(
                  isEnabled: false,
                  child: child,
                ),
              ),
            ),
          );
        });

        final manufacturerBannerFinder = find.byType(ManufacturerBanner);

        expect(manufacturerBannerFinder, findsNothing);
      },
    );
  });
}
