import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_button_card.dart';

void main() {
  group("MetricsButtonCard", () {
    const title = 'title';
    const iconData = Icons.title;

    testWidgets("displays the given title", (tester) async {
      await tester.pumpWidget(
        _MetricsButtonCardTestbed(
          title: const Text(title),
          iconData: iconData,
          onTap: () {},
        ),
      );

      expect(find.widgetWithText(MetricsButtonCard, title), findsOneWidget);
    });

    testWidgets("has a default title padding equals to 0",
        (tester) async {
      await tester.pumpWidget(
        _MetricsButtonCardTestbed(
          title: const Text(title),
          iconData: iconData,
          onTap: () {},
        ),
      );

      final metricsButtonCard = tester.widget<MetricsButtonCard>(
        find.byType(MetricsButtonCard),
      );

      expect(metricsButtonCard.titlePadding, EdgeInsets.zero);
    });

    testWidgets("displays the given icon data", (tester) async {
      await tester.pumpWidget(
        _MetricsButtonCardTestbed(
          title: const Text(title),
          iconData: iconData,
          onTap: () {},
        ),
      );

      final metricsButtonCard = tester.widget<MetricsButtonCard>(
        find.byType(MetricsButtonCard),
      );

      expect(metricsButtonCard.iconData, equals(iconData));
    });

    testWidgets("has a default icon padding equals to 0",
        (tester) async {
      await tester.pumpWidget(
        _MetricsButtonCardTestbed(
          title: const Text(title),
          iconData: iconData,
          onTap: () {},
        ),
      );

      final metricsButtonCard = tester.widget<MetricsButtonCard>(
        find.byType(MetricsButtonCard),
      );

      expect(metricsButtonCard.iconPadding, EdgeInsets.zero);
    });

    testWidgets("onTap callback is called after tap", (tester) async {
      bool isCalled = false;

      await tester.pumpWidget(
        _MetricsButtonCardTestbed(
          title: const Text(title),
          iconData: iconData,
          onTap: () {
            isCalled = true;
          },
        ),
      );

      await tester.tap(find.byType(MetricsButtonCard));

      expect(isCalled, equals(isTrue));
    });
  });
}

/// A testbed widget, used to test the [MetricsButtonCard] widget.
class _MetricsButtonCardTestbed extends StatelessWidget {
  final Widget title;
  final IconData iconData;
  final VoidCallback onTap;

  /// Creates the [_MetricsButtonCardTestbed] with the given [title], [iconData] and [onTap] function,
  const _MetricsButtonCardTestbed({
    Key key,
    this.title,
    this.iconData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsButtonCard(
          title: title,
          iconData: iconData,
          onTap: onTap,
        ),
      ),
    );
  }
}
