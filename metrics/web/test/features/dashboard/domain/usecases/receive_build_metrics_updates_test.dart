import 'package:metrics/features/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/features/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/util/date.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ReceiveProjectMetricUpdates", () {
    const projectId = 'projectId';
    final repository = _MetricsRepositoryStub();
    final receiveProjectMetricsUpdates =
        ReceiveProjectMetricsUpdates(repository);

    List<Build> builds;
    Build lastBuild;
    DashboardProjectMetrics projectMetrics;

    setUpAll(() async {
      builds = _MetricsRepositoryStub.testBuilds;

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
          .subtract(ReceiveProjectMetricsUpdates.buildNumberLoadingPeriod)
          .date;
      final thisWeekBuilds = builds
          .where((build) => build.startedAt.isAfter(buildsLoadingStartDate));

      final totalNumberOfBuilds = thisWeekBuilds.length;
      final buildNumberMetrics = projectMetrics.buildNumberMetrics;

      expect(buildNumberMetrics.numberOfBuilds, totalNumberOfBuilds);
    });

    test("loads all fields in the build result metrics", () {
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
          _MetricsRepositoryStub.lastSuccessfulBuild.coverage;

      expect(actualCoverage, expectedCoverage);
    });

    test("calculates stability metric", () {
      final actualStability = projectMetrics.stability;

      final successfulBuilds =
          builds.where((build) => build.buildStatus == BuildStatus.successful);
      final expectedStabilityValue = successfulBuilds.length / builds.length;

      expect(actualStability.value, expectedStabilityValue);
    });

    test(
      "creates empty project metrics if project has no builds",
      () async {
        final repository = _MetricsRepositoryStub(builds: []);
        final projectMetricsUpdates = ReceiveProjectMetricsUpdates(repository);
        final projectMetricsStream = projectMetricsUpdates(
          const ProjectIdParam(projectId),
        );
        final projectMetrics = await projectMetricsStream.first;

        const expectedProjectMetrics = DashboardProjectMetrics(
          projectId: projectId,
        );

        expect(projectMetrics, equals(expectedProjectMetrics));
      },
    );

    test(
      "creates project metrics with null coverage if there are no successful builds",
      () async {
        final builds = [
          Build(
            id: '1',
            startedAt: DateTime.now(),
            buildStatus: BuildStatus.failed,
            duration: const Duration(minutes: 10),
            coverage: const Percent(0.4),
          ),
          Build(
            id: '2',
            startedAt: DateTime.now(),
            buildStatus: BuildStatus.cancelled,
            duration: const Duration(minutes: 3),
            coverage: const Percent(0.2),
          ),
        ];

        final repository = _MetricsRepositoryStub(builds: builds);
        final projectMetricsUpdates = ReceiveProjectMetricsUpdates(repository);
        final projectMetricsStream = projectMetricsUpdates(
          const ProjectIdParam(projectId),
        );
        final projectMetrics = await projectMetricsStream.first;

        expect(projectMetrics.coverage, isNull);
      },
    );
  });
}

class _MetricsRepositoryStub implements MetricsRepository {
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

  static final List<Build> testBuilds = [
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

  List<Build> _builds;

  _MetricsRepositoryStub({List<Build> builds}) {
    _builds = builds ?? testBuilds;
  }

  @override
  Stream<List<Build>> latestProjectBuildsStream(String projectId, int limit) {
    List<Build> latestBuilds = _builds;

    if (latestBuilds.length > limit) {
      latestBuilds = latestBuilds.sublist(0, limit);
    }

    return Stream.value(latestBuilds);
  }

  @override
  Stream<List<Build>> projectBuildsFromDateStream(
      String projectId, DateTime from) {
    return Stream.value(
        _builds.where((build) => build.startedAt.isAfter(from)).toList());
  }

  @override
  Stream<List<Project>> projectsStream() {
    return Stream.value([_project]);
  }

  @override
  Stream<List<Build>> lastSuccessfulBuildStream(String projectId) {
    final lastSuccessfulBuild = _builds.firstWhere(
      (build) => build.buildStatus == BuildStatus.successful,
      orElse: () => null,
    );

    if (lastSuccessfulBuild == null) return Stream.value([]);

    return Stream.value([lastSuccessfulBuild]);
  }
}
