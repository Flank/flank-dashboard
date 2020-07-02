import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_metrics_tile_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("ProjectMetricsTileViewModel", () {
    const projectId = 'id';
    const projectName = 'name';
    const coverage = CoverageViewModel(value: 1);
    const stability = StabilityViewModel(value: 1);
    const buildNumber = BuildNumberScorecardViewModel(numberOfBuilds: 3);
    const performance = PerformanceSparklineViewModel();
    const buildResult = BuildResultMetricViewModel();

    test(
      "uses the default coverage view model if the coverage parameter is not specified",
      () {
        const expectedViewModel = CoverageViewModel();
        const projectMetrics = ProjectMetricsTileViewModel();

        expect(projectMetrics.coverage, equals(expectedViewModel));
      },
    );

    test(
      "uses the default stability view model if the stability parameter is not specified",
      () {
        const expectedViewModel = StabilityViewModel();
        const projectMetrics = ProjectMetricsTileViewModel();

        expect(projectMetrics.stability, equals(expectedViewModel));
      },
    );

    test(
      "equals to another ProjectMetricsTileViewModel with the same params",
      () {
        final firstViewModel = ProjectMetricsTileViewModel(
          projectId: projectId,
          projectName: projectName,
          coverage: coverage,
          stability: stability,
          buildNumberMetric: buildNumber,
          buildResultMetrics: buildResult,
          performanceSparkline: performance,
        );

        final secondViewModel = ProjectMetricsTileViewModel(
          projectId: projectId,
          projectName: projectName,
          coverage: coverage,
          stability: stability,
          buildNumberMetric: buildNumber,
          buildResultMetrics: buildResult,
          performanceSparkline: performance,
        );

        expect(firstViewModel, equals(secondViewModel));
      },
    );

    test(
      ".copyWith() creates a new instance with the same fields if called without params",
      () {
        final firstViewModel = ProjectMetricsTileViewModel(
          projectId: projectId,
          projectName: projectName,
          coverage: coverage,
          stability: stability,
          buildNumberMetric: buildNumber,
          buildResultMetrics: buildResult,
          performanceSparkline: performance,
        );

        final secondViewModel = firstViewModel.copyWith();

        expect(firstViewModel, equals(secondViewModel));
      },
    );

    test(
      ".copyWith() creates a copy of an instance with the given fields replaced with the new values",
      () {
        const id = "id";
        const name = "name";

        final metricsTileViewModel = ProjectMetricsTileViewModel(
          projectId: id,
          projectName: name,
          stability: StabilityViewModel(value: 0.2),
          coverage: CoverageViewModel(value: 0.4),
          performanceSparkline: PerformanceSparklineViewModel(value: 30),
          buildNumberMetric: BuildNumberScorecardViewModel(numberOfBuilds: 1),
          buildResultMetrics: BuildResultMetricViewModel(
            numberOfBuildsToDisplay: 1,
          ),
        );

        final copiedMetricsTileViewModel = metricsTileViewModel.copyWith(
          stability: stability,
          coverage: coverage,
          performanceSparkline: performance,
          buildNumberMetric: buildNumber,
          buildResultMetrics: buildResult,
        );

        expect(
          copiedMetricsTileViewModel.projectId,
          equals(metricsTileViewModel.projectId),
        );
        expect(
          copiedMetricsTileViewModel.projectName,
          equals(metricsTileViewModel.projectName),
        );
        expect(
          copiedMetricsTileViewModel.coverage,
          equals(coverage),
        );
        expect(
          copiedMetricsTileViewModel.stability,
          equals(stability),
        );
        expect(
          copiedMetricsTileViewModel.buildNumberMetric,
          equals(buildNumber),
        );
        expect(
          copiedMetricsTileViewModel.performanceSparkline,
          equals(performance),
        );
        expect(
          copiedMetricsTileViewModel.buildResultMetrics,
          equals(buildResult),
        );
      },
    );
  });
}
