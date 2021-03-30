// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/common/presentation/animated_bar/widgets/metrics_animated_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group('MetricsAnimatedBar', () {
    final coloredBarFinder = find.byType(ColoredBar);

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
      "displays the colored bar",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsAnimatedBarTestbed(),
        );

        expect(coloredBarFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the given height",
      (WidgetTester tester) async {
        const height = 10.0;
        await tester.pumpWidget(
          const _MetricsAnimatedBarTestbed(
            height: height,
          ),
        );

        final coloredBar = tester.widget<ColoredBar>(coloredBarFinder);

        expect(coloredBar.height, equals(height));
      },
    );

    testWidgets(
      "has the DimensionsConfig.graphBarWidth width",
      (WidgetTester tester) async {
        const height = 10.0;
        await tester.pumpWidget(
          const _MetricsAnimatedBarTestbed(
            height: height,
          ),
        );

        final container = tester.firstWidget<Container>(find.byType(Container));
        final constraints = container.constraints;

        expect(constraints.minWidth, equals(DimensionsConfig.graphBarWidth));
        expect(constraints.maxWidth, equals(DimensionsConfig.graphBarWidth));
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsAnimatedBar] widget.
class _MetricsAnimatedBarTestbed extends StatelessWidget {
  /// A height of this bar.
  final double height;

  /// Indicates whether this widget is hovered.
  final bool isHovered;

  /// Creates an instance of the [_MetricsAnimatedBarTestbed].
  ///
  /// The [isHovered] defaults to a `false`.
  const _MetricsAnimatedBarTestbed({
    Key key,
    this.isHovered = false,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsAnimatedBar(
      height: height,
      isHovered: isHovered,
    );
  }
}
