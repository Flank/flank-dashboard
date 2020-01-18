import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/coverage_store.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  group("Dashboard configuration", () {
    testWidgets(
      "Contains Circle percentage with coverage",
      (WidgetTester tester) async {
        await tester.pumpWidget(DashboardTestbed());
        await tester.pumpAndSettle();
        expect(find.byType(CirclePercentage), findsOneWidget);
      },
    );
  });
}

class DashboardTestbed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Injector(
        inject: [
          Inject<CoverageStore>(() => CoverageStoreStub()),
        ],
        initState: () {
          Injector.getAsReactive<CoverageStore>()
              .setState((store) => store.getCoverage('projectId'));
        },
        builder: (BuildContext context) => DashboardPage(),
      ),
    );
  }
}

class CoverageStoreStub implements CoverageStore {
  @override
  Coverage get coverage => Coverage(percent: 0.3);

  @override
  void getCoverage(String projectId) {}
}
