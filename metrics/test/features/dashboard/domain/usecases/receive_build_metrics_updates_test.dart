import 'package:metrics/features/dashboard/domain/entities/core/build.dart';
import 'package:metrics/features/dashboard/domain/entities/core/project.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/features/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/util/date.dart';
import 'package:test/test.dart';

void main() {
  group("Build metrics data loading", () {
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

      lastBuild = builds.last;
    });

    test("Loads all fields in the performance metrics", () {
      final performanceMetrics = projectMetrics.performanceMetrics;
      final firstPerformanceMetric = performanceMetrics.buildsPerformance.first;

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

    test("Loads all fields in the build number metrics", () {
      final buildStartDate = lastBuild.startedAt.date;

      final numberOfBuildsPerFirstDate = builds
          .where((element) => element.startedAt.date == buildStartDate)
          .length;
      final totalNumberOfBuilds = builds.length;

      final buildNumberMetrics = projectMetrics.buildNumberMetrics;
      final buildsPerFirstDate = buildNumberMetrics.buildsOnDateSet.first;

      expect(buildsPerFirstDate.date, buildStartDate);
      expect(buildsPerFirstDate.numberOfBuilds, numberOfBuildsPerFirstDate);
      expect(buildNumberMetrics.totalNumberOfBuilds, totalNumberOfBuilds);
    });

    test('Loads all fields in the build result metrics', () {
      final buildResultMetrics = projectMetrics.buildResultMetrics;

      final firstBuildResult = buildResultMetrics.buildResults.first;

      expect(firstBuildResult.buildStatus, lastBuild.buildStatus);
      expect(firstBuildResult.duration, lastBuild.duration);
      expect(firstBuildResult.date, lastBuild.startedAt);
      expect(firstBuildResult.url, lastBuild.url);
    });
  });
}

class MetricsRepositoryStubImpl implements MetricsRepository {
  static const Project _project = Project(
    name: 'projectName',
    id: 'projectId',
  );
  static final List<Build> builds = [
    Build(
      id: '1',
      startedAt: DateTime.now(),
      duration: const Duration(minutes: 10),
    ),
    Build(
      id: '2',
      startedAt: DateTime.now().subtract(const Duration(days: 1)),
      duration: const Duration(minutes: 6),
    ),
    Build(
      id: '3',
      startedAt: DateTime.now().subtract(const Duration(days: 2)),
      duration: const Duration(minutes: 3),
    ),
    Build(
      id: '4',
      startedAt: DateTime.now().subtract(const Duration(days: 3)),
      duration: const Duration(minutes: 8),
    ),
    Build(
      id: '5',
      startedAt: DateTime.now().subtract(const Duration(days: 4)),
      duration: const Duration(minutes: 12),
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
}
