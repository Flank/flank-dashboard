import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/features/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_number_text_metric.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/dashboard_table.dart';
import 'package:metrics/features/dashboard/presentation/widgets/dashboard_table_header.dart';
import 'package:metrics/features/dashboard/presentation/widgets/project_metrics_tile.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../test_utils/project_metrics_store_stub.dart';

void main() {
  group("DashboardTable", () {
    testWidgets(
      "contains MetricsTitle widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(_MetricsTableTestbed());

        expect(find.byType(DashboardTableHeader), findsOneWidget);
      },
    );

    testWidgets(
      "contains ListView with ProjectMetricTile widgets",
      (WidgetTester tester) async {
        await tester.pumpWidget(_MetricsTableTestbed());
        await tester.pumpAndSettle();

        expect(
          find.descendant(
            of: find.byType(ListView),
            matching: find.byType(ProjectMetricsTile),
            matchRoot: true,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays an error, occured during loading the metrics data",
      (WidgetTester tester) async {
        const metricsStore = _MetricsStoreErrorStub();

        await tester.pumpWidget(_MetricsTableTestbed(
          metricsStore: metricsStore,
        ));

        await tester.pumpAndSettle();

        expect(
          find.text(DashboardStrings.getLoadingErrorMessage(
              '${_MetricsStoreErrorStub.errorMessage}')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'displays the placeholder when there are no available projects',
      (WidgetTester tester) async {
        const metricsStore = ProjectMetricsStoreStub(projectMetrics: []);
        await tester.pumpWidget(_MetricsTableTestbed(
          metricsStore: metricsStore,
        ));

        await tester.pumpAndSettle();

        expect(
          find.text(DashboardStrings.noConfiguredProjects),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays performance title above the sparkline graph widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(_MetricsTableTestbed());
        await tester.pumpAndSettle();

        final performanceMetricWidgetCenter = tester.getCenter(
          find.byType(SparklineGraph),
        );

        final performanceTitleCenter = tester.getCenter(
          find.descendant(
              of: find.byType(Expanded),
              matching: find.text(DashboardStrings.performance)),
        );

        expect(
          performanceMetricWidgetCenter.dx,
          equals(performanceTitleCenter.dx),
        );
      },
    );

    testWidgets(
      "displays builds title above the build number text metric widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(_MetricsTableTestbed());
        await tester.pumpAndSettle();

        final performanceMetricWidgetCenter = tester.getCenter(
          find.byType(BuildNumberTextMetric),
        );

        final performanceTitleCenter = tester.getCenter(
          find.descendant(
              of: find.byType(Expanded),
              matching: find.text(DashboardStrings.builds)),
        );

        expect(
          performanceMetricWidgetCenter.dx,
          equals(performanceTitleCenter.dx),
        );
      },
    );

    testWidgets(
      "displays stability title above the stability circle percentage widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(_MetricsTableTestbed());
        await tester.pumpAndSettle();
        final stabilityPercent =
            ProjectMetricsStoreStub.testProjectMetrics.stability;
        final stabilityText = '${(stabilityPercent.value * 100).toInt()}%';

        final performanceMetricWidgetCenter = tester.getCenter(
          find.widgetWithText(CirclePercentage, stabilityText),
        );

        final performanceTitleCenter = tester.getCenter(
          find.descendant(
              of: find.byType(Expanded),
              matching: find.text(DashboardStrings.stability)),
        );

        expect(
          performanceMetricWidgetCenter.dx,
          equals(performanceTitleCenter.dx),
        );
      },
    );

    testWidgets(
      "displays stability title above the stability circle percentage widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(_MetricsTableTestbed());
        await tester.pumpAndSettle();
        final coveragePercent =
            ProjectMetricsStoreStub.testProjectMetrics.coverage;
        final coverageText = '${(coveragePercent.value * 100).toInt()}%';

        final performanceMetricWidgetCenter = tester.getCenter(
          find.widgetWithText(CirclePercentage, coverageText),
        );

        final performanceTitleCenter = tester.getCenter(
          find.descendant(
              of: find.byType(Expanded),
              matching: find.text(DashboardStrings.coverage)),
        );

        expect(
          performanceMetricWidgetCenter.dx,
          equals(performanceTitleCenter.dx),
        );
      },
    );
  });
}

class _MetricsTableTestbed extends StatelessWidget {
  final ThemeStore themeStore = ThemeStore();
  final ProjectMetricsStore metricsStore;

  _MetricsTableTestbed({
    Key key,
    this.metricsStore = const ProjectMetricsStoreStub(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Injector(
        inject: [
          Inject<ProjectMetricsStore>(() => metricsStore),
          Inject<ThemeStore>(() => ThemeStore()),
        ],
        initState: () {
          Injector.getAsReactive<ProjectMetricsStore>().setState(
            (store) => store.subscribeToProjects(),
            catchError: true,
          );
          Injector.getAsReactive<ThemeStore>()
              .setState((store) => store.isDark = false);
        },
        builder: (BuildContext context) => MetricsThemeBuilder(
          builder: (_, __) {
            return DashboardTable();
          },
        ),
      ),
    );
  }
}

class _MetricsStoreErrorStub extends ProjectMetricsStoreStub {
  static const String errorMessage = "Unknown error";

  const _MetricsStoreErrorStub();

  @override
  Stream<List<ProjectMetricsData>> get projectsMetrics => throw errorMessage;

  @override
  Future<void> subscribeToProjects() {
    throw errorMessage;
  }

  @override
  void dispose() {}
}
