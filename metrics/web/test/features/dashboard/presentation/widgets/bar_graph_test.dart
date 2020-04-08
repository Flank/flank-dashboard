import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/model/bar_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/bar_graph.dart';

import 'test_utils/testbed_page.dart';

void main() {
  testWidgets(
    "Can't create widget without data",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _BarGraphTestbed(data: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Can create widget from empty data",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _BarGraphTestbed(data: []));

      expect(tester.takeException(), isNull);
      expect(find.byType(_BarGraphTestbed), findsOneWidget);
    },
  );

  testWidgets(
    "Applies graph padding",
    (WidgetTester tester) async {
      const padding = EdgeInsets.all(8.0);

      await tester.pumpWidget(
        const _BarGraphTestbed(graphPadding: padding),
      );

      final paddingWidget = tester.widget<Padding>(find.byWidgetPredicate(
        (widget) => widget is Padding && widget.child is LayoutBuilder,
      ));

      expect(paddingWidget.padding, padding);
    },
  );

  testWidgets(
    "Graph bars are tapable",
    (WidgetTester tester) async {
      int tappedBarValue;

      await tester.pumpWidget(_BarGraphTestbed(
        onBarTap: (data) => tappedBarValue = data.value,
      ));

      final barWidgets =
          tester.widgetList<_GraphTestBar>(find.byType(_GraphTestBar));

      for (final barWidget in barWidgets) {
        await tester.tap(find.byWidget(barWidget));

        expect(tappedBarValue, barWidget.value);
      }
    },
  );

  testWidgets(
    "Builds all bar data from data list with the given order",
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

        expect(bar.value, _BarGraphTestbed.graphBarTestData[i].value);
      }
    },
  );

  testWidgets(
    "Builds the graph bars with the height ratio equal to data value ratio",
    (WidgetTester tester) async {
      const barGraphData = [
        _TestBarData(value: 1),
        _TestBarData(value: 3),
        _TestBarData(value: 7),
      ];

      final barGraphDataValues =
          barGraphData.map((data) => data.value).toList();

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
        barGraphDataValues[0] / barGraphDataValues[1],
      );
      expect(
        barHeights[0] / barHeights[2],
        barGraphDataValues[0] / barGraphDataValues[2],
      );
      expect(
        barHeights[1] / barHeights[2],
        barGraphDataValues[1] / barGraphDataValues[2],
      );
    },
  );
}

class _BarGraphTestbed extends StatelessWidget {
  static const graphBarTestData = [
    _TestBarData(value: 1),
    _TestBarData(value: 6),
    _TestBarData(value: 18),
    _TestBarData(value: 13),
    _TestBarData(value: 6),
    _TestBarData(value: 19),
  ];

  final String title;
  final TextStyle titleStyle;
  final EdgeInsets graphPadding;
  final List<_TestBarData> data;
  final ValueChanged<_TestBarData> onBarTap;

  const _BarGraphTestbed({
    Key key,
    this.title = 'title',
    this.data = graphBarTestData,
    this.graphPadding = const EdgeInsets.all(16.0),
    this.titleStyle,
    this.onBarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestbedPage(
      body: BarGraph(
        data: data,
        graphPadding: graphPadding,
        onBarTap: onBarTap,
        barBuilder: (_TestBarData data) => _GraphTestBar(
          value: data.value,
        ),
      ),
    );
  }
}

class _TestBarData implements BarData {
  @override
  final int value;

  const _TestBarData({this.value});
}

class _GraphTestBar extends StatelessWidget {
  final int value;

  const _GraphTestBar({Key key, this.value}) : super(key: key);

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
