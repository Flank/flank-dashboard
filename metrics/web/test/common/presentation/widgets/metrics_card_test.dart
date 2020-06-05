import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_card.dart';

void main() {
  group("MetricsCard", () {
    testWidgets("has a default elevation value equals to 0.0", (tester) async {
      await tester.pumpWidget(const _MetricsCardTestbed());

      final metricsCard = tester.widget<MetricsCard>(find.byType(MetricsCard));

      expect(metricsCard.elevation, equals(0.0));
    });

    testWidgets("has a default margin value equals to 0", (tester) async {
      await tester.pumpWidget(const _MetricsCardTestbed());

      final metricsCard = tester.widget<MetricsCard>(find.byType(MetricsCard));

      expect(metricsCard.margin, equals(EdgeInsets.zero));
    });

    testWidgets("has a default padding value equals to 0", (tester) async {
      await tester.pumpWidget(const _MetricsCardTestbed());

      final metricsCard = tester.widget<MetricsCard>(find.byType(MetricsCard));

      expect(metricsCard.padding, equals(EdgeInsets.zero));
    });

    testWidgets("displays the given child widget", (tester) async {
      const text = 'test';

      await tester.pumpWidget(
        const _MetricsCardTestbed(
          child: Text(text),
        ),
      );

      expect(find.text(text), findsOneWidget);
    });

    testWidgets("sets the given background color", (tester) async {
      const color = Colors.red;

      await tester.pumpWidget(
        const _MetricsCardTestbed(
          backgroundColor: color,
        ),
      );

      final metricsCard = tester.widget<MetricsCard>(find.byType(MetricsCard));

      expect(metricsCard.backgroundColor, color);
    });
  });
}

/// A testbed widget, used to test the [MetricsCard] widget.
class _MetricsCardTestbed extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const _MetricsCardTestbed({
    Key key,
    this.backgroundColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsCard(
          key: key,
          backgroundColor: backgroundColor,
          child: child,
        ),
      ),
    );
  }
}
