import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/features/common/presentation/scaffold/widget/metrics_scaffold.dart';

void main() {
  group("MetricsScaffold", () {
    const drawer = Drawer();

    testWidgets(
      "thows an AssertionError if trying to create without body",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsScaffoldTestbed(body: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      'displays the given body',
      (WidgetTester tester) async {
        const body = Text('body text');
        await tester.pumpWidget(const _MetricsScaffoldTestbed(body: body));

        expect(find.byWidget(body), findsOneWidget);
      },
    );

    testWidgets(
      "contains the MetricsAppBar",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsScaffoldTestbed());

        expect(find.byType(MetricsAppBar), findsOneWidget);
      },
    );

    testWidgets(
      "contains the icon button with the menu icon if the drawer is passed",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsScaffoldTestbed(drawer: drawer));

        expect(find.widgetWithIcon(IconButton, Icons.menu), findsOneWidget);
      },
    );

    testWidgets(
      'applies the drawer as the Scaffold.endDrawer',
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsScaffoldTestbed(drawer: drawer));

        final scaffoldWidget = tester.widget<Scaffold>(find.byType(Scaffold));

        expect(scaffoldWidget.endDrawer, drawer);
      },
    );

    testWidgets(
      'opens the given drawer on tap on the menu icon button',
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsScaffoldTestbed(drawer: drawer));

        await tester.tap(find.widgetWithIcon(IconButton, Icons.menu));
        await tester.pump();

        expect(find.byWidget(drawer), findsOneWidget);
      },
    );
  });
}

class _MetricsScaffoldTestbed extends StatelessWidget {
  final Widget body;
  final Widget drawer;

  const _MetricsScaffoldTestbed({
    Key key,
    this.body = const SizedBox(),
    this.drawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MetricsScaffold(
        body: body,
        drawer: drawer,
      ),
    );
  }
}
