// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/widgets/in_progress_animated_bar.dart';
import 'package:rive/rive.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("InProgressAnimatedBar", () {
    const asset = 'web/animation/in_progress_bar.riv';
    const artboardName = 'In progress bar';

    final controller = SimpleAnimation('Animation 1');

    final riveAnimationFinder = find.byType(RiveAnimation);

    RiveAnimation getRiveAnimation(WidgetTester tester) {
      return tester.widget<RiveAnimation>(riveAnimationFinder);
    }

    testWidgets(
      "throws an AssertionError if the given height is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(height: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given rive asset is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(riveAsset: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given height",
      (WidgetTester tester) async {
        const expectedHeight = 20.0;

        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(
            riveAsset: asset,
            height: expectedHeight,
          ),
        );
        await tester.pump();

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));

        expect(sizedBox.height, equals(expectedHeight));
      },
    );

    testWidgets(
      "applies the bar width from the dimensions config",
      (WidgetTester tester) async {
        const expectedWidth = DimensionsConfig.graphBarWidth;

        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(
            riveAsset: asset,
          ),
        );
        await tester.pump();

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));

        expect(sizedBox.width, equals(expectedWidth));
      },
    );

    testWidgets(
      "displays the rive animation with the given asset",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(
            riveAsset: asset,
          ),
        );

        final riveAnimation = getRiveAnimation(tester);

        expect(riveAnimation.assetName, equals(asset));
      },
    );

    testWidgets(
      "aligns the rive animation to the bottom center",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(riveAsset: asset),
        );

        final align = tester.widget<Align>(find.byType(Align));

        expect(align.alignment, equals(Alignment.bottomCenter));
      },
    );

    testWidgets(
      "displays the rive animation with fit width box fit",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(
            riveAsset: asset,
          ),
        );

        final riveAnimation = getRiveAnimation(tester);

        expect(riveAnimation.fit, equals(BoxFit.fitWidth));
      },
    );

    testWidgets(
      "displays the rive animation with given controller",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _InProgressAnimatedBarTestbed(
            riveAsset: asset,
            controller: controller,
          ),
        );

        final riveAnimation = getRiveAnimation(tester);
        final animationController = riveAnimation.controller;

        expect(animationController, equals(controller));
      },
    );

    testWidgets(
      "displays the rive animation with the given artboard name",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(
            riveAsset: asset,
            artboardName: artboardName,
          ),
        );

        final riveAnimation = getRiveAnimation(tester);

        expect(riveAnimation.artboardName, equals(artboardName));
      },
    );
  });
}

/// A testbed widget used to test the [InProgressAnimatedBar] widget.
class _InProgressAnimatedBarTestbed extends StatelessWidget {
  /// A rive animation asset to be used in tests.
  final String riveAsset;

  /// A [RiveAnimationController] to be used in tests.
  final RiveAnimationController controller;

  /// An artboard name to be used in tests.
  final String artboardName;

  /// A height of this bar to be used in tests.
  final double height;

  /// Create a new instance of the [_InProgressAnimatedBarTestbed],
  const _InProgressAnimatedBarTestbed({
    Key key,
    this.controller,
    this.artboardName,
    this.height = 10,
    this.riveAsset = 'asset',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: InProgressAnimatedBar(
          height: height,
          riveAsset: riveAsset,
          controller: controller,
          artboardName: artboardName,
        ),
      ),
    );
  }
}
