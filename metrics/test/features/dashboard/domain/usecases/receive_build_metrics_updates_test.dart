import 'package:metrics/features/dashboard/domain/entities/core/build.dart';
import 'package:metrics/features/dashboard/domain/entities/core/build_status.dart';
import 'package:metrics/features/dashboard/domain/entities/core/percent.dart';
import 'package:metrics/features/dashboard/domain/entities/core/project.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/features/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/util/date.dart';
import 'package:test/test.dart';

void main() {
  group("ReceiveProjectMetricUpdates", () {
    const projectId = 'projectId';
    const repository = MetricsRepositoryStubImpl();
    final receiveProjectMetricsUpdates =
        ReceiveProjectMetricsUpdates(repository);

    List<Build> builds;
    Build lastBuild;
    DashboardProjectMetrics projectMetrics;

    setUpAll(() async {
      builds = MetricsRepositoryStubImpl.builds;

      projectMetrics =
          await receiveProjectMetricsUpdates(const ProjectIdParam(projectId))
              .first;

      lastBuild = builds.first;
    });

    test("loads all fields in the performance metrics", () {
      final performanceMetrics = projectMetrics.performanceMetrics;
      final firstPerformanceMetric = performanceMetrics.buildsPerformance.last;

      expect(
        performanceMetrics.buildsPerformance.length,
        builds.length,
      );

      expect(
        firstPerformanceMetric.date,
        lastBuild.startedAt,
      );
      expect(
        firstPerformanceMetric.duration,
        lastBuild.duration,
      );
    });

    test("loads build number metric", () {
      final timestamp = DateTime.now();
      final buildsLoadingStartDate = timestamp
          .subtract(ReceiveProjectMetricsUpdates.buildsLoadingPeriod)
          .date;
      final thisWeekBuilds = builds
          .where((build) => build.startedAt.isAfter(buildsLoadingStartDate));

      final totalNumberOfBuilds = thisWeekBuilds.length;
      final buildNumberMetrics = projectMetrics.buildNumberMetrics;

      expect(buildNumberMetrics.numberOfBuilds, totalNumberOfBuilds);
    });

    test('loads all fields in the build result metrics', () {
      final buildResultMetrics = projectMetrics.buildResultMetrics;

      final firstBuildResult = buildResultMetrics.buildResults.last;

      expect(firstBuildResult.buildStatus, lastBuild.buildStatus);
      expect(firstBuildResult.duration, lastBuild.duration);
      expect(firstBuildResult.date, lastBuild.startedAt);
      expect(firstBuildResult.url, lastBuild.url);
    });

    test("loads coverage from last successful build", () {
      final actualCoverage = projectMetrics.coverage;
      final expectedCoverage =
          MetricsRepositoryStubImpl.lastSuccessfulBuild.coverage;

      expect(actualCoverage, expectedCoverage);
    });

    test('calculates stability metric', () {
      final actualStability = projectMetrics.stability;

      final successfulBuilds =
          builds.where((build) => build.buildStatus == BuildStatus.successful);
      final expectedStabilityValue = successfulBuilds.length / builds.length;

      expect(actualStability.value, expectedStabilityValue);
    });
  });
}

class MetricsRepositoryStubImpl implements MetricsRepository {
  static const Project _project = Project(
    name: 'projectName',
    id: 'projectId',
  );

  static final Build lastSuccessfulBuild = Build(
    id: '2',
    startedAt: DateTime.now().subtract(const Duration(days: 1)),
    duration: const Duration(minutes: 6),
    coverage: const Percent(0.1),
    buildStatus: BuildStatus.cancelled,
  );

  static final List<Build> builds = [
    Build(
      id: '1',
      startedAt: DateTime.now(),
      duration: const Duration(minutes: 10),
      coverage: const Percent(0.1),
      buildStatus: BuildStatus.failed,
    ),
    lastSuccessfulBuild,
    Build(
      id: '3',
      startedAt: DateTime.now().subtract(const Duration(days: 2)),
      duration: const Duration(minutes: 3),
      coverage: const Percent(0.1),
      buildStatus: BuildStatus.successful,
    ),
    Build(
      id: '4',
      startedAt: DateTime.now().subtract(const Duration(days: 3)),
      duration: const Duration(minutes: 8),
      coverage: const Percent(0.1),
      buildStatus: BuildStatus.failed,
    ),
    Build(
      id: '5',
      startedAt: DateTime.now().subtract(const Duration(days: 4)),
      duration: const Duration(minutes: 12),
      coverage: const Percent(0.1),
      buildStatus: BuildStatus.failed,
    ),
  ];

  const MetricsRepositoryStubImpl();

  @override
  Stream<List<Build>> latestProjectBuildsStream(String projectId, int limit) {
    List<Build> latestBuilds = builds;

    if (latestBuilds.length > limit) {
      latestBuilds = latestBuilds.sublist(0, limit);
    }

    return Stream.value(latestBuilds);
  }

  @override
  Stream<List<Build>> projectBuildsFromDateStream(
      String projectId, DateTime from) {
    return Stream.value(
        builds.where((build) => build.startedAt.isAfter(from)).toList());
  }

  @override
  Stream<List<Project>> projectsStream() {
    return Stream.value([_project]);
  }

  @override
  Stream<List<Build>> lastSuccessfulBuildStream(String projectId) {
    return Stream.value([lastSuccessfulBuild]);
  }
}
