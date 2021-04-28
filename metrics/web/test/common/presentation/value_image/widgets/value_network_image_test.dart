// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/asset/strategy/value_based_asset_strategy.dart';
import 'package:metrics/common/presentation/value_image/widgets/value_network_image.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../../test_utils/finder_util.dart';

void main() {
  group("ValueNetworkImage", () {
    testWidgets(
      "throws an AssertionError if the given strategy is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _ValueImageTestbed(strategy: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given width to the network image",
      (WidgetTester tester) async {
        const width = 10.0;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ValueImageTestbed(
            width: width,
          ));
        });

        final image = FinderUtil.findSvgImage(tester);

        expect(image.width, equals(width));
      },
    );

    testWidgets(
      "applies the given height to the network image",
      (WidgetTester tester) async {
        const height = 10.0;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ValueImageTestbed(
            height: height,
          ));
        });

        final image = FinderUtil.findSvgImage(tester);

        expect(image.height, equals(height));
      },
    );

    testWidgets(
      "applies the asset from the given strategy to the network image",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ValueImageTestbed());
        });

        final image = FinderUtil.findSvgImage(tester);

        expect(
          image.src,
          equals(_ValueBasedAssetStrategyStub.testAsset),
        );
      },
    );
  });
}

/// A stub implementation for the [ValueBasedAssetStrategy] to use
/// in tests. This always returns the [testAsset].
class _ValueBasedAssetStrategyStub extends ValueBasedAssetStrategy<int> {
  /// An image asset to use in tests.
  static const String testAsset = "testImage";

  /// Creates a new instance of the [_ValueBasedAssetStrategyStub].
  const _ValueBasedAssetStrategyStub();

  @override
  String getAsset(int value) {
    return testAsset;
  }
}

/// A testbed widget used to test the [ValueNetworkImage] widget.
class _ValueImageTestbed extends StatelessWidget {
  /// An asset strategy to apply to the widget under tests.
  final ValueBasedAssetStrategy<int> strategy;

  /// A width to apply to the widget under tests.
  final double width;

  /// A height to apply to the widget under tests.
  final double height;

  /// A value the [strategy] uses to select an image asset to display.
  final int value;

  /// Creates a new instance of the [_ValueImageTestbed].
  const _ValueImageTestbed({
    Key key,
    this.strategy = const _ValueBasedAssetStrategyStub(),
    this.value,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ValueNetworkImage(
          strategy: strategy,
          value: value,
          height: height,
          width: width,
        ),
      ),
    );
  }
}
