// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/animated_bar.dart';
import 'package:metrics/common/presentation/widgets/in_progress_animated_bar.dart';
import 'package:rive/rive.dart';

import '../../../test_utils/presentation/widgets/rive_animation_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("InProgressAnimatedBar", () {
    final controller = SimpleAnimation('Animation 1');

    final animatedBarFinder = find.byType(AnimatedBar);

    AnimatedBar getAnimatedBar(WidgetTester tester) {
      return tester.widget<AnimatedBar>(animatedBarFinder);
    }

    testWidgets(
      "throws an AssertionError if the given isHovered is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(
            isHovered: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the animated bar with the in progress asset if the given is hovered is false",
      (WidgetTester tester) async {
        const expectedAsset = 'web/animation/in_progress_bar.riv';

        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(
            isHovered: false,
          ),
        );

        final animatedBar = getAnimatedBar(tester);

        expect(animatedBar.riveAsset, equals(expectedAsset));
      },
    );

    testWidgets(
      "displays the animated bar with the hovered in progress asset if the given is hovered is true",
      (WidgetTester tester) async {
        const expectedAsset = 'web/animation/in_progress_bar_hover.riv';

        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(
            isHovered: true,
          ),
        );

        final animatedBar = getAnimatedBar(tester);

        expect(animatedBar.riveAsset, equals(expectedAsset));
      },
    );

    testWidgets(
      "applies the given height to the animated bar",
      (WidgetTester tester) async {
        const expectedHeight = 20.0;

        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(
            height: expectedHeight,
          ),
        );

        final animatedBar = getAnimatedBar(tester);

        expect(animatedBar.height, equals(expectedHeight));
      },
    );

    testWidgets(
      "applies the given width to the animated bar",
      (WidgetTester tester) async {
        const expectedWidth = 20.0;

        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(
            width: expectedWidth,
          ),
        );

        final animatedBar = getAnimatedBar(tester);

        expect(animatedBar.width, equals(expectedWidth));
      },
    );

    testWidgets(
      "aligns the animated bar to the bottom center",
      (WidgetTester tester) async {
        const expectedAlignment = Alignment.bottomCenter;

        await tester.pumpWidget(
          const _InProgressAnimatedBarTestbed(),
        );

        final alignFinder = find.ancestor(
          of: animatedBarFinder,
          matching: find.byType(Align),
        );
        final align = tester.widget<Align>(alignFinder);

        expect(align.alignment, equals(expectedAlignment));
      },
    );

    testWidgets(
      "applies the given controller to the animated bar",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _InProgressAnimatedBarTestbed(
            controller: controller,
          ),
        );

        final animatedBar = getAnimatedBar(tester);
        final animationController = animatedBar.controller;

        expect(animationController, equals(controller));
      },
    );
  });
}

/// A testbed widget used to test the [InProgressAnimatedBar] widget.
class _InProgressAnimatedBarTestbed extends StatelessWidget {
  /// A [RiveAnimationController] to be used in tests.
  final RiveAnimationController controller;

  /// A flag that indicates whether this animated bar is hovered in tests.
  final bool isHovered;

  /// A height of this bar to be used in tests.
  final double height;

  /// A width of this bar to be used in tests.
  final double width;

  /// Creates a new instance of the [_InProgressAnimatedBarTestbed].
  ///
  /// The [isHovered] defaults to `false`.
  /// The [height] defaults to `10.0`.
  /// The [width] defaults to `10.0`.
  const _InProgressAnimatedBarTestbed({
    Key key,
    this.controller,
    this.isHovered = false,
    this.height = 10.0,
    this.width = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RiveAnimationTestbed(
          child: InProgressAnimatedBar(
            height: height,
            width: width,
            isHovered: isHovered,
            controller: controller,
          ),
        ),
      ),
    );
  }
}
