import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/domain/entities/build_metrics.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:test/test.dart';

void main() {
  group("Build metrics data loading", () {
    const repository = MetricsRepositoryStubImpl();
    const projectIdParam = ProjectIdParam(projectId: 'projectId');

    final getBuildMetrics = GetBuildMetrics(repository);
    List<Build> projectBuilds;
    Build firstBuild;
    BuildMetrics buildMetrics;

    setUpAll(() async {
      projectBuilds =
          await repository.getProjectBuilds(projectIdParam.projectId);
      firstBuild = projectBuilds.first;
      buildMetrics = await getBuildMetrics(projectIdParam);
    });

    DateTime _trimToDay(DateTime dateTime) {
      return DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
      );
    }

    test('Calculates the average build time and total number of builds', () {
      final expectedAverageBuildTime = projectBuilds
              .map((build) => build.duration)
              .reduce((value, element) => value + element) ~/
          projectBuilds.length;
      final expectedTotalBuildNumber = projectBuilds.length;

      expect(buildMetrics.averageBuildTime, expectedAverageBuildTime);
      expect(buildMetrics.totalBuildNumber, expectedTotalBuildNumber);
    });

    test("Properly loads the performance metrics", () {
      final firstPerformanceMetric = buildMetrics.performanceMetrics.first;

      expect(
        projectBuilds.length,
        buildMetrics.performanceMetrics.length,
      );

      expect(
        firstBuild.startedAt,
        firstPerformanceMetric.date,
      );
      expect(
        firstBuild.duration,
        firstPerformanceMetric.duration,
      );
    });

    test("Properly loads the build number metrics", () {
      final buildStartDate = _trimToDay(firstBuild.startedAt);

      final numberOfBuilds = projectBuilds
          .where((element) => _trimToDay(element.startedAt) == buildStartDate)
          .length;

      final buildNumberMetrics = buildMetrics.buildNumberMetrics;
      final firstBuildMetric = buildNumberMetrics.first;

      expect(firstBuildMetric.date, buildStartDate);
      expect(firstBuildMetric.numberOfBuilds, numberOfBuilds);
    });

    test('Properly loads the build result metrics', () {
      final buildResultMetrics = buildMetrics.buildResultMetrics;

      final firstBuildResultMetric = buildResultMetrics.first;
      final firstBuild = projectBuilds.first;

      expect(firstBuildResultMetric.result, firstBuild.result);
      expect(firstBuildResultMetric.duration, firstBuild.duration);
      expect(firstBuildResultMetric.date, firstBuild.startedAt);
      expect(firstBuildResultMetric.url, firstBuild.url);
    });

    test(
      "Loads the configured number of build results",
      () {
        final buildResultMetrics = buildMetrics.buildResultMetrics;

        expect(
          buildResultMetrics,
          hasLength(lessThanOrEqualTo(GetBuildMetrics.maxNumberOfBuildResults)),
        );
      },
    );
  });
}

class MetricsRepositoryStubImpl implements MetricsRepository {
  static final Build _build = Build(
    startedAt: DateTime.now(),
    duration: const Duration(minutes: 10),
  );

  const MetricsRepositoryStubImpl();

  @override
  Future<Coverage> getCoverage(String projectId) {
    return Future.value(null);
  }

  @override
  Future<List<Build>> getProjectBuilds(String projectId) {
    return Future.value(List.generate(
      GetBuildMetrics.maxNumberOfBuildResults + 1,
      (index) => _build,
    ));
  }
}
