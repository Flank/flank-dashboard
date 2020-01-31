import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
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

  setUp(() {
    projectMetricsStore = ProjectMetricsStore(
      getCoverage,
      getBuildMetrics,
    );
  });

  group("Metrics store creation", () {
    test("Throws an assert if one of the use cases is null", () {
      final assertionMatcher = throwsA(const TypeMatcher<AssertionError>());

      expect(() => ProjectMetricsStore(null, null), assertionMatcher);
      expect(
        () => ProjectMetricsStore(const GetCoverageTestbed(), null),
        assertionMatcher,
      );
      expect(
        () => ProjectMetricsStore(null, const GetBuildMetricsTestbed()),
        assertionMatcher,
      );
    });
  });

  group("Coverage data loading", () {
    test("Properly loads the coverage data", () async {
      final actualCoverage = await getCoverage(projectIdParam);

      await projectMetricsStore.getCoverage(projectId);

      expect(actualCoverage, equals(projectMetricsStore.coverage));
    });
  });

  group("Builds data loading", () {
    List<Build> actualBuildMetrics;
    Build actualFirstBuild;
    DateTime actualFirstBuildStart;

    setUpAll(() async {
      actualBuildMetrics = await getBuildMetrics(projectIdParam);
      actualFirstBuild = actualBuildMetrics.first;
      actualFirstBuildStart = actualFirstBuild.startedAt;
    });

    DateTime _trimToDay(DateTime actualFirstBuildStart) {
      return DateTime(
        actualFirstBuildStart.year,
        actualFirstBuildStart.month,
        actualFirstBuildStart.day,
      );
    }

    test("Properly loads the performance points", () async {
      await projectMetricsStore.getBuildMetrics(projectId);

      final firstPerformancePoint =
          projectMetricsStore.projectPerformanceMetric.first;

      expect(
        actualBuildMetrics.length,
        projectMetricsStore.projectPerformanceMetric.length,
      );
      expect(
        actualFirstBuildStart.millisecondsSinceEpoch,
        firstPerformancePoint.x,
      );
      expect(
        actualFirstBuild.duration.inMilliseconds,
        firstPerformancePoint.y,
      );
    });

    test("Properly loads the build points", () async {
      final actualFirstBuildDay = _trimToDay(actualFirstBuildStart);

      final actualFirstBuildCount = actualBuildMetrics
          .where((build) => _trimToDay(build.startedAt) == actualFirstBuildDay)
          .length;

      final actualAverageBuildTime = (actualBuildMetrics
                  .map((build) => build.duration)
                  .reduce((value, element) => value + element)
                  .inMinutes /
              actualBuildMetrics.length)
          .round();

      await projectMetricsStore.getBuildMetrics(projectId);

      final firstBuildPoint = projectMetricsStore.projectBuildMetric.first;
      final firstBuildDay = firstBuildPoint.x;
      final firstBuildDayCount = firstBuildPoint.y;

      expect(actualFirstBuildDay.millisecondsSinceEpoch, firstBuildDay);
      expect(firstBuildDayCount, actualFirstBuildCount);

      expect(actualBuildMetrics.length, projectMetricsStore.totalBuildNumber);
      expect(actualAverageBuildTime, projectMetricsStore.averageBuildTime);
    });
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
  static final Build _build = Build(
    startedAt: DateTime.now(),
    duration: const Duration(minutes: 10),
  );

  const GetBuildMetricsTestbed();

  @override
  Future<List<Build>> call(ProjectIdParam param) {
    return Future.value([_build]);
  }
}
