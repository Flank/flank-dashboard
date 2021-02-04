// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_card.dart';

import '../../../test_utils/finder_util.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsCard", () {
    const child = Text("child");
    const decoration = BoxDecoration(color: Colors.red);

    testWidgets(
      "throws an AssertionError if the given child is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MetricsCardTestbed(
            child: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "uses the default empty BoxDecoration if the decoration is not specified",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MetricsCardTestbed(
            child: child,
          ),
        );

        final boxDecoration = FinderUtil.findBoxDecoration(tester);

        expect(boxDecoration, equals(const BoxDecoration()));
      },
    );

    testWidgets(
      "displays the given child",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MetricsCardTestbed(
            child: child,
          ),
        );

        expect(find.byWidget(child), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given decoration",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MetricsCardTestbed(
            decoration: decoration,
            child: child,
          ),
        );

        final boxDecoration = FinderUtil.findBoxDecoration(tester);

        expect(boxDecoration, equals(decoration));
      },
    );
  });
}

/// A testbed class needed to test the [MetricsCard] widget.
class MetricsCardTestbed extends StatelessWidget {
  /// This card's decoration.
  final BoxDecoration decoration;

  /// A widget to display.
  final Widget child;

  /// Created a new [MetricsCardTestbed] instance.
  const MetricsCardTestbed({
    Key key,
    this.decoration = const BoxDecoration(),
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsCard(
          decoration: decoration,
          child: child,
        ),
      ),
    );
  }
}
