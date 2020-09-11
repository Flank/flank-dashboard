import 'package:collection/collection.dart';
import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metrics_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_metrics_tile_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("ProjectMetricsTileViewModel", () {
    const projectId = 'id';
    const projectName = 'name';
    const coverage = CoverageViewModel(value: 1);
    const stability = StabilityViewModel(value: 1);
    const buildNumber = BuildNumberScorecardViewModel(numberOfBuilds: 3);
    final performance = PerformanceSparklineViewModel(
      performance: UnmodifiableListView([]),
    );
    final buildResult = BuildResultMetricsViewModel(
      buildResults: UnmodifiableListView([]),
    );
    final buildStatus = ProjectBuildStatusViewModel(
      value: BuildStatus.successful,
    );

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
      "uses the default project build status view model if the build status parameter is not specified",
      () {
        const expectedViewModel = ProjectBuildStatusViewModel();
        const projectMetrics = ProjectMetricsTileViewModel();

        expect(projectMetrics.buildStatus, equals(expectedViewModel));
      },
    );

    test(
      "uses the default project build status view model if the build status parameter is not specified",
      () {
        const expectedViewModel = ProjectBuildStatusViewModel();
        const projectMetrics = ProjectMetricsTileViewModel();

        expect(projectMetrics.buildStatus, equals(expectedViewModel));
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
          buildNumberMetrics: buildNumber,
          buildResultMetrics: buildResult,
          performanceSparkline: performance,
          buildStatus: buildStatus,
        );

        final secondViewModel = ProjectMetricsTileViewModel(
          projectId: projectId,
          projectName: projectName,
          coverage: coverage,
          stability: stability,
          buildNumberMetrics: buildNumber,
          buildResultMetrics: buildResult,
          performanceSparkline: performance,
          buildStatus: buildStatus,
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
          buildNumberMetrics: buildNumber,
          buildResultMetrics: buildResult,
          performanceSparkline: performance,
          buildStatus: buildStatus,
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
          performanceSparkline: PerformanceSparklineViewModel(
            value: Duration(minutes: 30),
            performance: UnmodifiableListView([]),
          ),
          buildNumberMetrics: BuildNumberScorecardViewModel(numberOfBuilds: 1),
          buildResultMetrics: BuildResultMetricsViewModel(
            buildResults: UnmodifiableListView([]),
            numberOfBuildsToDisplay: 1,
          ),
          buildStatus: ProjectBuildStatusViewModel(
            value: BuildStatus.cancelled,
          ),
        );

        final copiedMetricsTileViewModel = metricsTileViewModel.copyWith(
          stability: stability,
          coverage: coverage,
          performanceSparkline: performance,
          buildNumberMetrics: buildNumber,
          buildResultMetrics: buildResult,
          buildStatus: buildStatus,
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
          copiedMetricsTileViewModel.buildNumberMetrics,
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
        expect(
          copiedMetricsTileViewModel.buildStatus,
          equals(buildStatus),
        );
      },
    );
  });
}
