// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/widgets/metrics_animated_bar.dart';
import 'package:rive/rive.dart';

void main() {
  group("MetricsAnimatedBar", () {
    const inProgressAsset = 'web/animation/in_progress_bar.riv';
    const inProgressAnimationName = 'Animation 1';

    final riveAnimationFinder = find.byType(RiveAnimation);

    RiveAnimation getRiveAnimation(WidgetTester tester) {
      return tester.widget<RiveAnimation>(riveAnimationFinder);
    }

    testWidgets(
      "throws an AssertionError if the given height is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsAnimatedBarTestbed(height: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given is hovered is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsAnimatedBarTestbed(isHovered: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given height",
      (WidgetTester tester) async {
        const expectedHeight = 20.0;

        await tester.pumpWidget(
          const _MetricsAnimatedBarTestbed(height: expectedHeight),
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
          const _MetricsAnimatedBarTestbed(),
        );
        await tester.pump();

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));

        expect(sizedBox.width, equals(expectedWidth));
      },
    );

    testWidgets(
      "displays the rive animation with the in progress asset",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsAnimatedBarTestbed(),
        );

        final riveAnimation = getRiveAnimation(tester);

        expect(riveAnimation.assetName, equals(inProgressAsset));
      },
    );

    testWidgets(
      "aligns the rive animation to the bottom center",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsAnimatedBarTestbed(),
        );

        final align = tester.widget<Align>(find.byType(Align));

        expect(align.alignment, equals(Alignment.bottomCenter));
      },
    );

    testWidgets(
      "displays the rive animation with fit width box fit",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsAnimatedBarTestbed(),
        );

        final riveAnimation = getRiveAnimation(tester);

        expect(riveAnimation.fit, equals(BoxFit.fitWidth));
      },
    );

    testWidgets(
      "displays the rive animation with simple animation as the animation controller",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsAnimatedBarTestbed(),
        );

        final riveAnimation = getRiveAnimation(tester);
        final animationController = riveAnimation.controller;

        expect(animationController, isA<SimpleAnimation>());
      },
    );

    testWidgets(
      "displays the rive animation with correct animation name in the animation controller",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsAnimatedBarTestbed(),
        );

        final riveAnimation = getRiveAnimation(tester);
        final animationController = riveAnimation.controller as SimpleAnimation;

        expect(
          animationController.animationName,
          equals(inProgressAnimationName),
        );
      },
    );
  });
}

/// A testbed widget used to test the [MetricsAnimatedBar] widget.
class _MetricsAnimatedBarTestbed extends StatelessWidget {
  /// A height of this bar to be used in tests.
  final double height;

  /// A flag that indicates whether this bar is hovered.
  final bool isHovered;

  /// Create a new instance of the [_MetricsAnimatedBarTestbed],
  const _MetricsAnimatedBarTestbed({
    Key key,
    this.height = 10,
    this.isHovered = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsAnimatedBar(
          height: height,
          isHovered: isHovered,
        ),
      ),
    );
  }
}
