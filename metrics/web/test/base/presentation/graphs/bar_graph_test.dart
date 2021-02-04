// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BarGraph", () {
    testWidgets(
      "throws an AssertionError if the bar builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _BarGraphTestbed(barBuilder: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "can be created if the given data is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _BarGraphTestbed(data: null));

        final graphFinder = find.descendant(
          of: find.byWidgetPredicate((widget) => widget is BarGraph),
          matching: find.byWidgetPredicate(
            (widget) => widget is Row && widget.children.isEmpty,
          ),
        );

        expect(tester.takeException(), isNull);
        expect(graphFinder, findsOneWidget);
      },
    );

    testWidgets(
      "can be created with an empty data",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _BarGraphTestbed(data: []));

        expect(tester.takeException(), isNull);
        expect(find.byType(_BarGraphTestbed), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given graph padding",
      (WidgetTester tester) async {
        const padding = EdgeInsets.all(8.0);

        await tester.pumpWidget(
          const _BarGraphTestbed(graphPadding: padding),
        );

        final paddingWidget = tester.widget<Padding>(find.byWidgetPredicate(
          (widget) => widget is Padding && widget.child is LayoutBuilder,
        ));

        expect(paddingWidget.padding, equals(padding));
      },
    );

    testWidgets(
      "builds all bar data from data list in the given order",
      (WidgetTester tester) async {
        const graphBarTestData = [1, 6, 18, 13, 6, 19];
        await tester.pumpWidget(const _BarGraphTestbed(data: graphBarTestData));

        final barsRow = tester.widget<Row>(find.byType(Row));
        final bars = barsRow.children;
        final values = bars.cast<_GraphTestBar>().map((bar) => bar.value);

        expect(bars, hasLength(equals(graphBarTestData.length)));
        expect(values, equals(graphBarTestData));
      },
    );

    testWidgets(
      "builds the graph bars with the height ratio equal to data value ratio",
      (WidgetTester tester) async {
        const barGraphData = [
          1,
          3,
          7,
        ];

        await tester.pumpWidget(const _BarGraphTestbed(
          data: barGraphData,
        ));

        final barsRow = tester.widget<Row>(find.byType(Row));

        final barExpandedContainers = barsRow.children;

        final List<double> barHeights = [];

        for (final bar in barExpandedContainers) {
          final barContainer = tester.firstWidget<Container>(find.descendant(
            of: find.byWidget(bar),
            matching: find.byType(Container),
          ));

          barHeights.add(barContainer.constraints.minHeight);
        }

        expect(
          barHeights[0] / barHeights[1],
          barGraphData[0] / barGraphData[1],
        );
        expect(
          barHeights[0] / barHeights[2],
          barGraphData[0] / barGraphData[2],
        );
        expect(
          barHeights[1] / barHeights[2],
          barGraphData[1] / barGraphData[2],
        );
      },
    );
  });
}

/// A testbed class required to test the [BarGraph] widget.
class _BarGraphTestbed extends StatelessWidget {
  /// A default bar builder used in tests.
  static Widget createBar(List<int> data, int index, double height) {
    return _GraphTestBar(
      value: data[index],
      height: height,
    );
  }

  /// The padding to inset the [BarGraph].
  final EdgeInsets graphPadding;

  /// The list of data to be displayed on the [BarGraph].
  final List<int> data;

  /// The function for the [BarGraph.barBuilder] callback.
  final Widget Function(List<int>, int, double) barBuilder;

  /// Creates the instance of this testbed.
  ///
  /// The [graphPadding] defaults to [EdgeInsets.all] with parameter `16.0`.
  /// The [barBuilder] defaults to the [createBar] function.
  const _BarGraphTestbed({
    Key key,
    this.data,
    this.barBuilder = createBar,
    this.graphPadding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: BarGraph(
        data: data,
        graphPadding: graphPadding,
        barBuilder: barBuilder == null
            ? null
            : (index, height) => barBuilder(data, index, height),
      ),
    );
  }
}

/// A test bar for the [_BarGraphTestbed].
class _GraphTestBar extends StatelessWidget {
  /// The value of this bar.
  final int value;

  /// The height of this bar.
  final double height;

  /// Creates this test bar with the [value].
  const _GraphTestBar({
    Key key,
    this.value,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: height,
      child: Text('$value'),
    );
  }
}
