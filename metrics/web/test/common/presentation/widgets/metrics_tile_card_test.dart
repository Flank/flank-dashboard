import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_tile_card.dart';

void main() {
  group("MetricsTileCard", () {
    const title = 'title';
    const subtitle = 'subtitle';

    testWidgets("displays the given title", (tester) async {
      await tester.pumpWidget(
        const _MetricsTileCardTestbed(
          title: Text(title),
          subtitle: Text(subtitle),
          actions: <Widget>[],
        ),
      );

      expect(find.widgetWithText(MetricsTileCard, title), findsOneWidget);
    });

    testWidgets("displays the given subtitle", (tester) async {
      await tester.pumpWidget(
        const _MetricsTileCardTestbed(
          title: Text(title),
          subtitle: Text(subtitle),
          actions: <Widget>[],
        ),
      );

      expect(find.widgetWithText(MetricsTileCard, subtitle), findsOneWidget);
    });

    testWidgets("displays the given actions", (tester) async {
      const firstAction = 'action1';
      const secondAction = 'action2';

      await tester.pumpWidget(
        const _MetricsTileCardTestbed(
          title: Text(title),
          subtitle: Text(subtitle),
          actions: <Widget>[Text(firstAction), Text(secondAction)],
        ),
      );

      expect(find.text(firstAction), findsOneWidget);
      expect(find.text(secondAction), findsOneWidget);
    });

    testWidgets("sets the given background color", (tester) async {
      const color = Colors.red;

      await tester.pumpWidget(
        const _MetricsTileCardTestbed(
          title: Text(title),
          subtitle: Text(subtitle),
          actions: <Widget>[],
          backgroundColor: color,
        ),
      );

      final metricsTileCard = tester.widget<MetricsTileCard>(
        find.byType(MetricsTileCard),
      );

      expect(metricsTileCard.backgroundColor, equals(color));
    });
  });
}

/// A testbed widget, used to test the [MetricsTileCard] widget.
class _MetricsTileCardTestbed extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final List<Widget> actions;
  final Color backgroundColor;

  const _MetricsTileCardTestbed({
    Key key,
    this.title,
    this.subtitle,
    this.actions,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsTileCard(
          title: title,
          subtitle: subtitle,
          actions: actions,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
