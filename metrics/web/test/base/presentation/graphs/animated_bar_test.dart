// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/animated_bar.dart';
import 'package:rive/rive.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("AnimatedBar", () {
    testWidgets(
      "throws an AssertionError if the given width is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _AnimatedBarTestbed(width: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given width is negative",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _AnimatedBarTestbed(width: -1.0));

        expect(tester.takeException(), isAssertionError);
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

  /// A [BoxFit] that determines how to inscribe this animation in tests.
  final BoxFit fit;

  /// A [RiveAnimationController] to use in tests.
  final RiveAnimationController controller;

  /// An artboard name to use in tests.
  final String artboardName;

  const _AnimatedBarTestbed({
    Key key,
    this.height,
    this.riveAsset,
    this.fit,
    this.controller,
    this.artboardName,
    this.width = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: AnimatedBar(
        fit: fit,
        height: height,
        width: width,
        riveAsset: riveAsset,
        controller: controller,
        artboardName: artboardName,
      ),
    );
  }
}
