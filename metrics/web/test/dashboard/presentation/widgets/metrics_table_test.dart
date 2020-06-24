import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/build_number_text_metric.dart';
import 'package:metrics/dashboard/presentation/widgets/coverage_circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_header.dart';
import 'package:metrics/dashboard/presentation/widgets/performance_sparkline_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/project_metrics_tile.dart';
import 'package:metrics/dashboard/presentation/widgets/stability_circle_percentage.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/project_metrics_notifier_mock.dart';
import '../../../test_utils/project_metrics_notifier_stub.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("MetricsTable", () {
    testWidgets(
      "contains MetricsTableHeader widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsTableTestbed());

        expect(find.byType(MetricsTableHeader), findsOneWidget);
      },
    );

    testWidgets(
      "contains a list of projects with their metrics",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsTableTestbed());
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
      "displays an error description, occurred during loading the metrics data",
      (WidgetTester tester) async {
        const errorMessage = 'Unknown error';
        final metricsNotifier = ProjectMetricsNotifierMock();

        when(metricsNotifier.projectsErrorMessage).thenReturn(errorMessage);

        await tester.pumpWidget(_MetricsTableTestbed(
          metricsNotifier: metricsNotifier,
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
        final metricsNotifier = ProjectMetricsNotifierStub(projectsMetrics: []);
        await tester.pumpWidget(_MetricsTableTestbed(
          metricsNotifier: metricsNotifier,
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
        await tester.pumpWidget(const _MetricsTableTestbed());
        await tester.pumpAndSettle();

        final performanceMetricWidgetCenter = tester.getCenter(
          find.byType(PerformanceSparklineGraph),
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
        await tester.pumpWidget(const _MetricsTableTestbed());
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
        await tester.pumpWidget(const _MetricsTableTestbed());
        await tester.pumpAndSettle();

        final stabilityMetricWidgetCenter = tester.getCenter(
          find.byType(StabilityCirclePercentage),
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
        await tester.pumpWidget(const _MetricsTableTestbed());
        await tester.pumpAndSettle();

        final coverageMetricWidgetCenter = tester.getCenter(
          find.byType(CoverageCirclePercentage),
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

/// A testbed widget used to test the [MetricsTable] widget.
class _MetricsTableTestbed extends StatelessWidget {
  /// A [ProjectMetricsNotifier] that will injected and used in tests.
  final ProjectMetricsNotifier metricsNotifier;

  /// Creates the [_MetricsTableTestbed] with the given [metricsNotifier].
  const _MetricsTableTestbed({
    Key key,
    this.metricsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestInjectionContainer(
        metricsNotifier: metricsNotifier,
        child: MetricsTable(),
      ),
    );
  }
}
