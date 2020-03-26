import 'dart:async';

import 'package:metrics/features/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/features/dashboard/domain/entities/core/percent.dart';
import 'package:metrics/features/dashboard/domain/entities/core/project.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/features/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/features/dashboard/domain/usecases/receive_project_updates.dart';
import 'package:metrics/features/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

void main() {
  const projectId = 'projectId';
  const projectIdParam = ProjectIdParam(projectId);

  final receiveProjectMetricsUpdates = ReceiveProjectMetricsUpdatesTestbed();
  final receiveProjectUpdates = ReceiveProjectUpdatesTestbed();

  DashboardProjectMetrics expectedProjectMetrics;
  ProjectMetricsStore projectMetricsStore;
  Stream<List<ProjectMetricsData>> projectMetricsStream;

  setUpAll(() async {
    projectMetricsStore = ProjectMetricsStore(
      receiveProjectUpdates,
      receiveProjectMetricsUpdates,
    );
    projectMetricsStream = projectMetricsStore.projectsMetrics;

    expectedProjectMetrics =
        await receiveProjectMetricsUpdates(projectIdParam).first;

    await projectMetricsStore.subscribeToProjects();
  });

  tearDownAll(() {
    projectMetricsStore.dispose();
  });

  test("Throws an assert if one of the use cases is null", () {
    expect(
      () => ProjectMetricsStore(null, null),
      MatcherUtil.throwsAssertionError,
    );
    expect(
      () => ProjectMetricsStore(null, receiveProjectMetricsUpdates),
      MatcherUtil.throwsAssertionError,
    );
    expect(
      () => ProjectMetricsStore(receiveProjectUpdates, null),
      MatcherUtil.throwsAssertionError,
    );
  });

  test(
    "Creates ProjectMetrics with empty points from empty BuildMetrics",
    () async {
      final receiveEmptyMetrics = ReceiveProjectMetricsUpdatesTestbed(
        metrics: const DashboardProjectMetrics(),
      );

      final projectMetricsStore = ProjectMetricsStore(
        receiveProjectUpdates,
        receiveEmptyMetrics,
      );

      await projectMetricsStore.subscribeToProjects();

      final metrics = await projectMetricsStore.projectsMetrics.first;
      final projectMetrics = metrics.first;

      expect(projectMetrics.buildResultMetrics, isEmpty);
      expect(projectMetrics.performanceMetrics, isEmpty);
    },
  );

  test(
    "Creates ProjectMetrics with null metrics if the BuildMetrics is null",
    () async {
      final receiveProjectMetricsUpdates =
          ReceiveProjectMetricsUpdatesTestbed.withNullMetrics();

      final projectMetricsStore = ProjectMetricsStore(
        receiveProjectUpdates,
        receiveProjectMetricsUpdates,
      );

      await projectMetricsStore.subscribeToProjects();

      final metrics = await projectMetricsStore.projectsMetrics.first;
      final projectMetrics = metrics.first;

      expect(projectMetrics.buildResultMetrics, isNull);
      expect(projectMetrics.performanceMetrics, isNull);
    },
  );

  test("Properly loads the coverage data", () async {
    final expectedProjectCoverage = expectedProjectMetrics.coverage;

    final projectMetrics = await projectMetricsStream.first;
    final projectCoverage = projectMetrics.first.coverage;

    expect(projectCoverage, expectedProjectCoverage);
  });

  test("Loads the build number metrics", () async {
    final expectedBuildNumberMetrics =
        expectedProjectMetrics.buildNumberMetrics;

    final actualProjectMetrics = await projectMetricsStream.first;
    final firstProjectMetrics = actualProjectMetrics.first;

    expect(
      firstProjectMetrics.buildNumberMetric,
      expectedBuildNumberMetrics.numberOfBuilds,
    );
  });

  test('Loads the performance metrics', () async {
    final expectedPerformanceMetrics =
        expectedProjectMetrics.performanceMetrics;

    final projectMetrics = await projectMetricsStream.first;
    final firstProjectMetrics = projectMetrics.first;
    final performanceMetrics = firstProjectMetrics.performanceMetrics;

    expect(
      performanceMetrics.length,
      expectedPerformanceMetrics.buildsPerformance.length,
    );

    expect(
      firstProjectMetrics.averageBuildDurationInMinutes,
      expectedPerformanceMetrics.averageBuildDuration.inMinutes,
    );

    final firstBuildPerformance =
        expectedPerformanceMetrics.buildsPerformance.first;
    final performancePoint = performanceMetrics.first;

    expect(
      performancePoint.x,
      firstBuildPerformance.date.millisecondsSinceEpoch,
    );
    expect(
      performancePoint.y,
      firstBuildPerformance.duration.inMilliseconds,
    );
  });

  test('Loads the build result metrics', () async {
    final expectedBuildResults =
        expectedProjectMetrics.buildResultMetrics.buildResults;

    final projectMetrics = await projectMetricsStream.first;
    final firstProjectMetrics = projectMetrics.first;
    final buildResultMetrics = firstProjectMetrics.buildResultMetrics;

    expect(
      buildResultMetrics.length,
      expectedBuildResults.length,
    );

    final expectedBuildResult = expectedBuildResults.first;
    final firstBuildResultMetric = buildResultMetrics.first;

    expect(
      firstBuildResultMetric.value,
      expectedBuildResult.duration.inMilliseconds,
    );
    expect(
      firstBuildResultMetric.buildStatus,
      expectedBuildResult.buildStatus,
    );
    expect(
      firstBuildResultMetric.url,
      expectedBuildResult.url,
    );
  });

  test(
    'Deletes the ProjectMetrics if the project was deleted on server',
    () async {
      final projects = ReceiveProjectUpdatesTestbed.testProjects.toList();

      final receiveProjectUpdates = ReceiveProjectUpdatesTestbed(
        projects: projects,
      );

      final metricsStore = ProjectMetricsStore(
        receiveProjectUpdates,
        receiveProjectMetricsUpdates,
      );

      await metricsStore.subscribeToProjects();

      List<Project> expectedProjects = await receiveProjectUpdates().first;
      List<ProjectMetricsData> actualProjects =
          await metricsStore.projectsMetrics.first;

      expect(actualProjects.length, expectedProjects.length);

      projects.removeLast();

      expectedProjects = await receiveProjectUpdates().first;
      actualProjects = await metricsStore.projectsMetrics.first;

      expect(actualProjects.length, expectedProjects.length);
    },
  );

  test(
    'Creates empty ProjectMetrics list when the projects are null',
    () async {
      final receiveProjects = ReceiveProjectUpdatesTestbed(projects: null);

      final metricsStore = ProjectMetricsStore(
        receiveProjects,
        receiveProjectMetricsUpdates,
      );

      await metricsStore.subscribeToProjects();
      final projectMetrics = await metricsStore.projectsMetrics.first;

      expect(projectMetrics, isEmpty);
    },
  );

  test(
    "Unsubscribes from all streams when dispose called",
    () async {
      final projectUpdates = ReceiveProjectUpdatesTestbed();
      final metricsUpdates = ReceiveProjectMetricsUpdatesTestbed();

      final metricsStore = ProjectMetricsStore(
        projectUpdates,
        metricsUpdates,
      );

      await metricsStore.subscribeToProjects();
      await metricsStore.projectsMetrics
          .firstWhere((element) => element != null);

      expect(projectUpdates.hasListener, isTrue);
      expect(metricsUpdates.hasListener, isTrue);

      metricsStore.dispose();

      expect(projectUpdates.hasListener, isFalse);
      expect(metricsUpdates.hasListener, isFalse);
    },
  );
}

class ReceiveProjectUpdatesTestbed implements ReceiveProjectUpdates {
  static const testProjects = [
    Project(
      id: 'id',
      name: 'name',
    ),
    Project(
      id: 'id2',
      name: 'name2',
    ),
  ];

  final List<Project> _projects;
  final BehaviorSubject<List<Project>> _projectsSubject = BehaviorSubject();

  ReceiveProjectUpdatesTestbed({List<Project> projects = testProjects})
      : _projects = projects;

  @override
  Stream<List<Project>> call([_]) {
    _projectsSubject.add(_projects);
    return _projectsSubject.stream;
  }

  bool get hasListener => _projectsSubject.hasListener;
}

class ReceiveProjectMetricsUpdatesTestbed
    implements ReceiveProjectMetricsUpdates {
  static final _projectMetrics = DashboardProjectMetrics(
    projectId: 'id',
    performanceMetrics: PerformanceMetric(
      buildsPerformance: DateTimeSet.from([
        BuildPerformance(
          date: DateTime.now(),
          duration: const Duration(minutes: 14),
        )
      ]),
      averageBuildDuration: const Duration(minutes: 3),
    ),
    buildNumberMetrics: const BuildNumberMetric(
      numberOfBuilds: 1,
    ),
    buildResultMetrics: BuildResultMetric(
      buildResults: [
        BuildResult(
          date: DateTime.now(),
          duration: const Duration(minutes: 14),
          url: 'some url',
        ),
      ],
    ),
    coverage: const Percent(0.2),
    stability: const Percent(0.5),
  );

  final BehaviorSubject<DashboardProjectMetrics> _metricsUpdatesSubject =
      BehaviorSubject();

  ReceiveProjectMetricsUpdatesTestbed({DashboardProjectMetrics metrics}) {
    _metricsUpdatesSubject.add(metrics ?? _projectMetrics);
  }

  ReceiveProjectMetricsUpdatesTestbed.withNullMetrics() {
    _metricsUpdatesSubject.add(null);
  }

  @override
  Stream<DashboardProjectMetrics> call([ProjectIdParam params]) {
    return _metricsUpdatesSubject.stream;
  }

  bool get hasListener => _metricsUpdatesSubject.hasListener;
}
