import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

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
      "throws an AssertionError if the given data is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _BarGraphTestbed(data: null));

        expect(tester.takeException(), isNull);
        expect(find.byType(_BarGraphTestbed), findsOneWidget);
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
      "applies the graph padding",
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
        await tester.pumpWidget(const _BarGraphTestbed());

        final barsRow = tester.widget<Row>(find.byType(Row));

        final rowWidgets = barsRow.children;

        expect(rowWidgets.length, _BarGraphTestbed.graphBarTestData.length);

        for (int i = 0; i < rowWidgets.length; i++) {
          final rowWidget = rowWidgets[i];
          final bar = tester.widget<_GraphTestBar>(find.descendant(
            of: find.byWidget(rowWidget),
            matching: find.byType(_GraphTestBar),
          ));

          expect(bar.value, _BarGraphTestbed.graphBarTestData[i]);
        }
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
  /// The test data for the [BarGraph].
  static const graphBarTestData = [
    1,
    6,
    18,
    13,
    6,
    19,
  ];

  /// A default bar builder used in tests.
  static Widget createBar(List<int> data, int index) {
    return _GraphTestBar(
      value: data[index].toInt(),
    );
  }

  /// The padding to inset the [BarGraph].
  final EdgeInsets graphPadding;

  /// The list of data to be displayed on the [BarGraph].
  final List<int> data;

  /// The function for the [BarGraph.barBuilder] callback.
  final Widget Function(List<int>, int) barBuilder;

  /// Creates the instance of this testbed.
  ///
  /// The [graphPadding] defaults to [EdgeInsets.all] with parameter `16.0`.
  /// The [barBuilder] defaults to the [createBar] function.
  const _BarGraphTestbed({
    Key key,
    this.data = graphBarTestData,
    this.barBuilder = createBar,
    this.graphPadding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: BarGraph(
        data: data,
        graphPadding: graphPadding,
        barBuilder:
            barBuilder == null ? null : (index) => barBuilder(data, index),
      ),
    );
  }
}

/// A test bar for the [_BarGraphTestbed].
class _GraphTestBar extends StatelessWidget {
  /// The value of this bar.
  final int value;

  /// Creates this test bar with the [value].
  const _GraphTestBar({
    Key key,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: FittedBox(
        child: Text('$value'),
      ),
    );
  }
}
