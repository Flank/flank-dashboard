import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/value_image/strategy/value_based_image_strategy.dart';
import 'package:metrics/common/presentation/value_image/widgets/value_image.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../../test_utils/finder_util.dart';

void main() {
  group("ValueImage", () {
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

        final image = tester.widget<Image>(find.byType(Image));

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

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.height, equals(height));
      },
    );

    testWidgets(
      "applies the given image from the strategy to the network image",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ValueImageTestbed());
        });

        final image = FinderUtil.findNetworkImageWidget(tester);

        expect(image.url, equals(_ValueImageAppearanceStrategyStub.image));
      },
    );
  });
}

/// A stub implementation for the [ValueBasedImageStrategy] to use
/// in tests. Always returns [image].
class _ValueImageAppearanceStrategyStub extends ValueBasedImageStrategy<int> {
  /// A test image to use in stub.
  static const String image = "testImage";

  /// Creates a new instance of the [_ValueImageAppearanceStrategyStub].
  const _ValueImageAppearanceStrategyStub();

  @override
  String getIconImage(int value) {
    return image;
  }
}

/// A testbed widget, used to test the [ValueImage] widget.
class _ValueImageTestbed extends StatelessWidget {
  /// An image appearance strategy to apply to the value image widget.
  final ValueBasedImageStrategy<int> strategy;

  /// A width of this image.
  final double width;

  /// A height of this image.
  final double height;

  /// A value used by [strategy].
  final int value;

  /// Creates a new instance of the [_ValueImageTestbed].
  const _ValueImageTestbed({
    Key key,
    this.strategy = const _ValueImageAppearanceStrategyStub(),
    this.value,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ValueImage(
          strategy: strategy,
          value: value,
          height: height,
          width: width,
        ),
      ),
    );
  }
}
