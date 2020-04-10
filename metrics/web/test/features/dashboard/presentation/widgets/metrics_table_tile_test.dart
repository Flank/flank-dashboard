import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/widgets/metrics_table_tile.dart';

import '../../../../test_utils/testbed_page.dart';

void main() {
  group("MetricsTableTile", () {
    testWidgets(
      "can't be created with null leading",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(leading: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "can't be created with null trailing",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(trailing: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given leading",
      (tester) async {
        const testText = 'test_text';
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(leading: Text(testText)),
        );

        expect(find.text(testText), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given trailing",
      (tester) async {
        const testText = 'test_text';
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(trailing: Text(testText)),
        );

        expect(find.text(testText), findsOneWidget);
      },
    );

    testWidgets(
      "display the leading and trailing with widths in a ratio of 3:5",
      (tester) async {
        final leading = Container();
        final trailing = Container();

        await tester.pumpWidget(_DashboardTableTileTestbed(
          leading: leading,
          trailing: trailing,
        ));

        final leadingSize = tester.getSize(find.byWidget(leading));
        final trailingSize = tester.getSize(find.byWidget(trailing));

        expect(leadingSize.width / trailingSize.width, equals(3 / 5));
      },
    );
  });
}

class _DashboardTableTileTestbed extends StatelessWidget {
  final Widget leading;
  final Widget trailing;

  const _DashboardTableTileTestbed({
    Key key,
    this.leading = const SizedBox(),
    this.trailing = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestbedPage(
      body: MetricsTableTile(
        leading: leading,
        trailing: trailing,
      ),
    );
  }
}
