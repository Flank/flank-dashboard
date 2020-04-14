import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/metrics_table_header.dart';
import 'package:metrics/features/dashboard/presentation/widgets/metrics_table_tile.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricsTableHeader", () {
    testWidgets(
      "contains MetricsTableTile",
      (tester) async {
        await tester.pumpWidget(_DashboardTableHeaderTestbed());

        expect(find.byType(MetricsTableTile), findsOneWidget);
      },
    );

    testWidgets(
      "displays the performance title",
      (tester) async {
        await tester.pumpWidget(_DashboardTableHeaderTestbed());

        expect(find.text(DashboardStrings.performance), findsOneWidget);
      },
    );

    testWidgets(
      "displays the builds title",
      (tester) async {
        await tester.pumpWidget(_DashboardTableHeaderTestbed());

        expect(find.text(DashboardStrings.builds), findsOneWidget);
      },
    );

    testWidgets(
      "displays the stability title",
      (tester) async {
        await tester.pumpWidget(_DashboardTableHeaderTestbed());

        expect(find.text(DashboardStrings.stability), findsOneWidget);
      },
    );

    testWidgets(
      "displays the coverage title",
      (tester) async {
        await tester.pumpWidget(_DashboardTableHeaderTestbed());

        expect(find.text(DashboardStrings.coverage), findsOneWidget);
      },
    );
  });
}

class _DashboardTableHeaderTestbed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MetricsThemedTestbed(
      body: MetricsTableHeader(),
    );
  }
}
