import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_number_text_metric.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/metrics_table.dart';
import 'package:metrics/features/dashboard/presentation/widgets/metrics_table_header.dart';
import 'package:metrics/features/dashboard/presentation/widgets/project_metrics_tile.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';
import 'package:mockito/mockito.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../test_utils/project_metrics_store_stub.dart';

void main() {
  group("MetricsTable", () {
    testWidgets(
      "contains MetricsTableHeader widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(_MetricsTableTestbed());

        expect(find.byType(MetricsTableHeader), findsOneWidget);
      },
    );

    testWidgets(
      "contains a list of projects with their metrics",
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
        const errorMessage = 'Unknown error';
        final metricsStore = _ProjectMetricsStoreMock();

        when(metricsStore.subscribeToProjects()).thenThrow(errorMessage);

        await tester.pumpWidget(_MetricsTableTestbed(
          metricsStore: metricsStore,
        ));

        await tester.pumpAndSettle();

        final loadingErrorMessage =
            CommonStrings.getLoadingErrorMessage('$errorMessage');

        expect(
          find.text(loadingErrorMessage),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays the placeholder when there are no available projects",
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
            matching: find.text(DashboardStrings.performance),
          ),
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

        final buildNumberMetricWidgetCenter = tester.getCenter(
          find.byType(BuildNumberTextMetric),
        );

        final buildNumberTitleCenter = tester.getCenter(
          find.descendant(
            of: find.byType(Expanded),
            matching: find.text(DashboardStrings.builds),
          ),
        );

        expect(
          buildNumberMetricWidgetCenter.dx,
          equals(buildNumberTitleCenter.dx),
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

        final stabilityMetricWidgetCenter = tester.getCenter(
          find.widgetWithText(CirclePercentage, stabilityText),
        );

        final stabilityTitleCenter = tester.getCenter(
          find.descendant(
              of: find.byType(Expanded),
              matching: find.text(DashboardStrings.stability)),
        );

        expect(
          stabilityMetricWidgetCenter.dx,
          equals(stabilityTitleCenter.dx),
        );
      },
    );

    testWidgets(
      "displays coverage title above the coverage circle percentage widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(_MetricsTableTestbed());
        await tester.pumpAndSettle();
        final coveragePercent =
            ProjectMetricsStoreStub.testProjectMetrics.coverage;
        final coverageText = '${(coveragePercent.value * 100).toInt()}%';

        final coverageMetricWidgetCenter = tester.getCenter(
          find.widgetWithText(CirclePercentage, coverageText),
        );

        final coverageTitleCenter = tester.getCenter(
          find.descendant(
            of: find.byType(Expanded),
            matching: find.text(DashboardStrings.coverage),
          ),
        );

        expect(
          coverageMetricWidgetCenter.dx,
          equals(coverageTitleCenter.dx),
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
            return MetricsTable();
          },
        ),
      ),
    );
  }
}

class _ProjectMetricsStoreMock extends Mock implements ProjectMetricsStore {}
