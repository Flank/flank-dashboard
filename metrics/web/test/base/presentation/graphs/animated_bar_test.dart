// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/animated_bar.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:rive/rive.dart';

import '../../../test_utils/test_animation_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("AnimatedBar", () {
    const asset = 'asset';
    final riveAnimationFinder = find.byType(RiveAnimation);

    testWidgets(
      "throws an AssertionError if the given height is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _AnimatedBarTestbed(
            height: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given height is negative",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _AnimatedBarTestbed(
            height: -1.0,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given width is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _AnimatedBarTestbed(
            width: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given width is negative",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _AnimatedBarTestbed(
            width: -1.0,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the rive animation with the given asset",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _AnimatedBarTestbed(
            riveAsset: asset,
          ),
        );

        final rive = tester.widget<RiveAnimation>(riveAnimationFinder);

        expect(rive.assetName, equals(asset));
      },
    );

    testWidgets(
      "displays the rive animation with the given controller",
      (WidgetTester tester) async {
        final controller = SimpleAnimation('1');

        await tester.pumpWidget(
          _AnimatedBarTestbed(
            controller: controller,
          ),
        );

        final rive = tester.widget<RiveAnimation>(riveAnimationFinder);

        expect(rive.controller, equals(controller));
      },
    );

    testWidgets(
      "displays the rive animation with the given artboard name",
      (WidgetTester tester) async {
        const artboardName = 'name';

        await tester.pumpWidget(
          const _AnimatedBarTestbed(
            artboardName: artboardName,
          ),
        );

        final rive = tester.widget<RiveAnimation>(riveAnimationFinder);

        expect(rive.artboardName, equals(artboardName));
      },
    );

    testWidgets(
      "applies the BoxFit.fitWidth to the rive animation",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _AnimatedBarTestbed(),
        );

        final rive = tester.widget<RiveAnimation>(riveAnimationFinder);

        expect(rive.fit, equals(BoxFit.fitWidth));
      },
    );
  });
}

/// A testbed class required to test the [AnimatedBar] widget.
class _AnimatedBarTestbed extends StatelessWidget {
  /// A width to use in tests.
  final double width;

  /// A height to use in tests.
  final double height;

  /// A rive animation asset to use in tests.
  final String riveAsset;

  /// A [RiveAnimationController] to use in tests.
  final RiveAnimationController controller;

  /// An artboard name to use in tests.
  final String artboardName;

  const _AnimatedBarTestbed({
    Key key,
    this.controller,
    this.artboardName,
    this.riveAsset = 'some asset',
    this.width = 1.0,
    this.height = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TestAnimationContainer(
          child: AnimatedBar(
            height: height,
            width: width,
            riveAsset: riveAsset,
            controller: controller,
            artboardName: artboardName,
          ),
        ),
      ),
    );
  }
}
