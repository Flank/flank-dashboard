import 'package:metrics/features/dashboard/domain/entities/build_metrics.dart';
import 'package:metrics/features/dashboard/domain/entities/build_number_metric.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/domain/entities/performance_metric.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_project_coverage.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:test/test.dart';

void main() {
  const projectId = 'projectId';
  const projectIdParam = ProjectIdParam(projectId: projectId);
  const GetCoverageTestbed getCoverage = GetCoverageTestbed();
  const GetBuildMetricsTestbed getBuildMetrics = GetBuildMetricsTestbed();

  ProjectMetricsStore projectMetricsStore;

  setUpAll(() async {
    projectMetricsStore = ProjectMetricsStore(
      getCoverage,
      getBuildMetrics,
    );

    await projectMetricsStore.getCoverage(projectId);
    await projectMetricsStore.getBuildMetrics(projectId);
  });

  test("Throws an assert if one of the use cases is null", () {
    final assertionMatcher = throwsA(const TypeMatcher<AssertionError>());

    expect(() => ProjectMetricsStore(null, null), assertionMatcher);
    expect(
      () => ProjectMetricsStore(getCoverage, null),
      assertionMatcher,
    );
    expect(
      () => ProjectMetricsStore(null, getBuildMetrics),
      assertionMatcher,
    );
  });

  test("Properly loads the coverage data", () async {
    final expectedCoverage = await getCoverage(projectIdParam);

    expect(projectMetricsStore.coverage, equals(expectedCoverage));
  });

  test("Loads the build number metrics", () async {
    final expectedBuildMetrics = await getBuildMetrics(projectIdParam);
    final expectedBuildNumberMetrics = expectedBuildMetrics.buildNumberMetrics;
    final expectedBuildNumberMetric = expectedBuildNumberMetrics.first;

    final actualBuildNumberMetrics =
        projectMetricsStore.projectBuildNumberMetrics;
    final actualBuildNumberMetric = actualBuildNumberMetrics.first;

    expect(
      projectMetricsStore.totalBuildNumber,
      expectedBuildMetrics.totalBuildNumber,
    );

    expect(actualBuildNumberMetrics.length, expectedBuildNumberMetrics.length);

    expect(
      actualBuildNumberMetric.x,
      expectedBuildNumberMetric.date.millisecondsSinceEpoch,
    );
    expect(
      actualBuildNumberMetric.y,
      expectedBuildNumberMetric.numberOfBuilds,
    );
  });

  test('Loads the performance metrics', () async {
    final expectedBuildMetrics = await getBuildMetrics(projectIdParam);
    final expectedPerformanceMetrics = expectedBuildMetrics.performanceMetrics;
    final expectedPerformanceMetric = expectedPerformanceMetrics.first;

    final performanceMetrics = projectMetricsStore.projectPerformanceMetrics;
    final performanceMetric = performanceMetrics.first;

    expect(performanceMetrics.length, expectedPerformanceMetrics.length);

    expect(
      projectMetricsStore.averageBuildTime,
      expectedBuildMetrics.averageBuildTime.inMinutes,
    );

    expect(
      performanceMetric.x,
      expectedPerformanceMetric.date.millisecondsSinceEpoch,
    );
    expect(
      performanceMetric.y,
      expectedPerformanceMetric.duration.inMilliseconds,
    );
  });
}

class GetCoverageTestbed implements GetProjectCoverage {
  static const double _coveragePercent = 0.3;

  const GetCoverageTestbed();

  @override
  Future<Coverage> call(ProjectIdParam params) {
    return Future.value(const Coverage(percent: _coveragePercent));
  }
}

class GetBuildMetricsTestbed implements GetBuildMetrics {
  static final BuildMetrics _buildMetrics = BuildMetrics(
    performanceMetrics: [
      PerformanceMetric(
        date: DateTime.now(),
        duration: const Duration(minutes: 14),
      )
    ],
    buildNumberMetrics: [
      BuildNumberMetric(date: DateTime.now(), numberOfBuilds: 1),
    ],
    averageBuildTime: const Duration(minutes: 3),
    totalBuildNumber: 1,
  );

  const GetBuildMetricsTestbed();

  @override
  Future<BuildMetrics> call(ProjectIdParam param) {
    return Future.value(_buildMetrics);
  }
}
