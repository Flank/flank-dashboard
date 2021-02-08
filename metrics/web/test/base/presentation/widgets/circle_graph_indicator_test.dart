// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/circle_graph_indicator.dart';

void main() {
  group("CircleGraphIndicator", () {
    const innerDiameter = 7.0;
    const outerDiameter = 13.0;
    const defaultColor = Colors.red;

    final outerCircleFinder = find.byWidgetPredicate(
      (widget) => widget is Container && widget.child is Container,
    );
    final innerCircleFinder = find.byWidgetPredicate(
      (widget) => widget is Container && widget.child == null,
    );

    testWidgets(
      "throws an AssertionError if the given outer diameter is null",
      (tester) async {
        await tester.pumpWidget(
          const _CircleGraphIndicatorTestbed(
            outerDiameter: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given inner diameter is null",
      (tester) async {
        await tester.pumpWidget(
          const _CircleGraphIndicatorTestbed(
            innerDiameter: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given inner diameter is greater than the outer",
      (tester) async {
        await tester.pumpWidget(
          const _CircleGraphIndicatorTestbed(
            innerDiameter: 10.0,
            outerDiameter: 7.0,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given inner diameter is equal to the outer",
      (tester) async {
        await tester.pumpWidget(
          const _CircleGraphIndicatorTestbed(
            innerDiameter: 7.0,
            outerDiameter: 7.0,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given diameter to the outer circle",
      (tester) async {
        const circleBounds = Size.square(outerDiameter);

        await tester.pumpWidget(
          const _CircleGraphIndicatorTestbed(
            outerDiameter: outerDiameter,
          ),
        );

        final circle = tester.widget<Container>(outerCircleFinder);
        final circleSizeBounds = circle.constraints.biggest;

        expect(circleSizeBounds, equals(circleBounds));
      },
    );

    testWidgets(
      "applies the given diameter to the inner circle",
      (tester) async {
        const circleBounds = Size.square(innerDiameter);

        await tester.pumpWidget(
          const _CircleGraphIndicatorTestbed(
            innerDiameter: innerDiameter,
          ),
        );

        final circle = tester.widget<Container>(innerCircleFinder);
        final circleSizeBounds = circle.constraints.biggest;

        expect(circleSizeBounds, equals(circleBounds));
      },
    );

    testWidgets("displays the given outer color", (tester) async {
      await tester.pumpWidget(
        const _CircleGraphIndicatorTestbed(outerColor: defaultColor),
      );

      final circle = tester.widget<Container>(outerCircleFinder);
      final decoration = circle.decoration as BoxDecoration;

      expect(decoration.color, equals(defaultColor));
    });

    testWidgets("displays the given inner color", (tester) async {
      await tester.pumpWidget(
        const _CircleGraphIndicatorTestbed(innerColor: defaultColor),
      );

      final circle = tester.widget<Container>(innerCircleFinder);
      final decoration = circle.decoration as BoxDecoration;

      expect(decoration.color, equals(defaultColor));
    });
  });
}

/// A testbed class required to test the [CircleGraphIndicator] widget.
class _CircleGraphIndicatorTestbed extends StatelessWidget {
  /// A [Color] of the outer circle.
  final Color outerColor;

  /// A [Color] of the inner circle.
  final Color innerColor;

  /// A diameter of the outer circle.
  final double outerDiameter;

  /// A diameter of the inner circle.
  final double innerDiameter;

  /// Creates an instance of the [_CircleGraphIndicatorTestbed]
  ///
  /// The [outerDiameter] defaults to the `8.0`.
  /// The [innerDiameter] defaults to the `4.0`.
  const _CircleGraphIndicatorTestbed({
    Key key,
    this.outerColor,
    this.innerColor,
    this.outerDiameter = 8.0,
    this.innerDiameter = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CircleGraphIndicator(
          outerColor: outerColor,
          innerColor: innerColor,
          outerDiameter: outerDiameter,
          innerDiameter: innerDiameter,
        ),
      ),
    );
  }
}
