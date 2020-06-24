import 'dart:async';

import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/presentation/models/project_metrics_data.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectMetricsNotifier", () {
    const projectId = 'projectId';
    const projectIdParam = ProjectIdParam(projectId);
    final List<ProjectModel> projects = [
      ProjectModel(id: 'id', name: 'name'),
      ProjectModel(id: 'id2', name: 'name2'),
    ];
    const String errorMessage = null;

    final receiveProjectMetricsUpdates = _ReceiveProjectMetricsUpdatesStub();

    DashboardProjectMetrics expectedProjectMetrics;
    ProjectMetricsNotifier projectMetricsNotifier;

    setUp(() async {
      projectMetricsNotifier = ProjectMetricsNotifier(
        receiveProjectMetricsUpdates,
      );

      expectedProjectMetrics =
          await receiveProjectMetricsUpdates(projectIdParam).first;

      final _completer = Completer();

      void initializationListener() {
        if (projectMetricsNotifier.projectsMetrics.every(
                (projectMetric) => projectMetric.buildNumberMetric != null) &&
            !_completer.isCompleted) {
          _completer.complete();
        }
      }

      projectMetricsNotifier.addListener(initializationListener);
      projectMetricsNotifier.updateProjects(
        projects,
        errorMessage,
      );
      await _completer.future;
      projectMetricsNotifier.removeListener(initializationListener);
    });

    tearDown(() async {
      await projectMetricsNotifier.dispose();
    });

    test(
      "throws an AssertionError if receive project metric updates use case is null",
      () {
        expect(
          () => ProjectMetricsNotifier(null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "creates ProjectMetricsData with empty points from empty DashboardProjectMetrics",
      () async {
        final receiveEmptyMetrics = _ReceiveProjectMetricsUpdatesStub(
          metrics: const DashboardProjectMetrics(),
        );
        final projects = [ProjectModel(id: 'id', name: 'name')];

        const emptyBuildResultMetric = BuildResultMetricViewModel();

        final projectMetricsNotifier = ProjectMetricsNotifier(
          receiveEmptyMetrics,
        );

        bool hasNullMetrics;
        final metricsListener = expectAsyncUntil0(() async {
          final projectMetrics = projectMetricsNotifier.projectsMetrics;
          if (projectMetrics == null || projectMetrics.isEmpty) return;

          final projectMetric = projectMetrics.first;
          final buildResultMetrics = projectMetric.buildResultMetrics;
          final performanceMetrics = projectMetric.performanceSparkline;
          final stabilityMetric = projectMetric.stability;

          hasNullMetrics = buildResultMetrics == emptyBuildResultMetric &&
              performanceMetrics != null &&
              performanceMetrics.performance.isEmpty &&
              stabilityMetric != null;

          if (hasNullMetrics) projectMetricsNotifier.dispose();
        }, () => hasNullMetrics);

        projectMetricsNotifier.addListener(metricsListener);

        projectMetricsNotifier.updateProjects(projects, errorMessage);
      },
    );

    test(
      "creates ProjectMetricsData with null metrics if the DashboardProjectMetrics is null",
      () async {
        final receiveProjectMetricsUpdates =
            _ReceiveProjectMetricsUpdatesStub.withNullMetrics();

        final projectMetricsNotifier = ProjectMetricsNotifier(
          receiveProjectMetricsUpdates,
        );

        bool hasNullMetrics;
        final metricsListener = expectAsyncUntil0(() async {
          final projectMetrics = projectMetricsNotifier.projectsMetrics;
          if (projectMetrics == null || projectMetrics.isEmpty) return;

          final buildResultMetrics = projectMetrics.first.buildResultMetrics;
          final performanceMetrics = projectMetrics.first.performanceSparkline;

          hasNullMetrics =
              buildResultMetrics == null && performanceMetrics == null;

          if (hasNullMetrics) await projectMetricsNotifier.dispose();
        }, () => hasNullMetrics);

        projectMetricsNotifier.addListener(metricsListener);

        projectMetricsNotifier.updateProjects(projects, errorMessage);
      },
    );

    test("loads the coverage data", () async {
      final expectedProjectCoverage = expectedProjectMetrics.coverage;

      final projectMetrics = projectMetricsNotifier.projectsMetrics.first;
      final projectCoverage = projectMetrics.coverage;

      expect(projectCoverage.value, equals(expectedProjectCoverage.value));
    });

    test("loads the stability data", () async {
      final expectedProjectStability = expectedProjectMetrics.stability;

      final projectMetrics = projectMetricsNotifier.projectsMetrics.first;
      final projectStability = projectMetrics.stability;

      expect(projectStability.value, equals(expectedProjectStability.value));
    });

    test("loads the build number metrics", () async {
      final expectedBuildNumberMetrics =
          expectedProjectMetrics.buildNumberMetrics;

      final firstProjectMetrics = projectMetricsNotifier.projectsMetrics.first;

      expect(
        firstProjectMetrics.buildNumberMetric,
        expectedBuildNumberMetrics.numberOfBuilds,
      );
    });

    test("loads the performance metrics", () async {
      final expectedPerformanceMetrics =
          expectedProjectMetrics.performanceMetrics;

      final firstProjectMetrics = projectMetricsNotifier.projectsMetrics.first;
      final performanceMetrics = firstProjectMetrics.performanceSparkline;
      final performancePoints = performanceMetrics.performance;

      expect(
        performancePoints.length,
        expectedPerformanceMetrics.buildsPerformance.length,
      );

      expect(
        performanceMetrics.value,
        expectedPerformanceMetrics.averageBuildDuration.inMinutes,
      );

      final firstBuildPerformance =
          expectedPerformanceMetrics.buildsPerformance.first;
      final performancePoint = performancePoints.first;

      expect(
        performancePoint.x,
        firstBuildPerformance.date.millisecondsSinceEpoch,
      );
      expect(
        performancePoint.y,
        firstBuildPerformance.duration.inMilliseconds,
      );
    });

    test("loads the build result metrics", () async {
      final expectedBuildResults =
          expectedProjectMetrics.buildResultMetrics.buildResults;

      final firstProjectMetrics = projectMetricsNotifier.projectsMetrics.first;
      final buildResultMetrics = firstProjectMetrics.buildResultMetrics;

      expect(
        buildResultMetrics.buildResults.length,
        expectedBuildResults.length,
      );

      final expectedBuildResult = expectedBuildResults.first;
      final firstBuildResultMetric = buildResultMetrics.buildResults.first;

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
      "deletes the ProjectMetricsData if the project was deleted on server",
      () async {
        final metricsNotifier = ProjectMetricsNotifier(
          receiveProjectMetricsUpdates,
        );

        metricsNotifier.updateProjects(projects, errorMessage);

        final List<ProjectModel> expectedProjects = [...projects];
        List<ProjectMetricsData> actualProjects =
            metricsNotifier.projectsMetrics;

        expect(actualProjects.length, expectedProjects.length);

        expectedProjects.removeLast();

        metricsNotifier.updateProjects(expectedProjects, errorMessage);

        actualProjects = metricsNotifier.projectsMetrics;

        expect(actualProjects.length, expectedProjects.length);

        await metricsNotifier.dispose();
      },
    );

    test(
      ".projectMetrics is an empty list when the projects parameter is an empty list",
      () async {
        final metricsNotifier = ProjectMetricsNotifier(
          receiveProjectMetricsUpdates,
        );

        bool hasEmptyProjectMetrics;
        final metricsListener = expectAsyncUntil0(() async {
          final projectMetrics = metricsNotifier.projectsMetrics;
          hasEmptyProjectMetrics =
              projectMetrics != null && projectMetrics.isEmpty;

          if (hasEmptyProjectMetrics) await metricsNotifier.dispose();
        }, () => hasEmptyProjectMetrics);

        metricsNotifier.addListener(metricsListener);

        metricsNotifier.updateProjects([], errorMessage);
      },
    );

    test(
        ".filterByProjectName() filters list of the project metrics according to the given value",
        () async {
      final expectedProjectMetrics = [
        projectMetricsNotifier.projectsMetrics.last
      ];

      final projectNameFilter = expectedProjectMetrics.first.projectName;
      final listener = expectAsync0(() {
        final filteredProjectMetrics = projectMetricsNotifier.projectsMetrics;

        expect(
          filteredProjectMetrics,
          equals(expectedProjectMetrics),
        );
      });
      projectMetricsNotifier.addListener(listener);
      projectMetricsNotifier.filterByProjectName(projectNameFilter);
    });

    test(
        ".filterByProjectName() doesn't apply filters to the list of the project metrics if the given value is null",
        () async {
      final expectedProjectMetrics = projectMetricsNotifier.projectsMetrics;

      final listener = expectAsync0(() {
        final filteredProjectMetrics = projectMetricsNotifier.projectsMetrics;

        expect(
          filteredProjectMetrics,
          equals(expectedProjectMetrics),
        );
      });
      projectMetricsNotifier.addListener(listener);
      projectMetricsNotifier.filterByProjectName(null);
    });

    test(
      ".dispose() unsubscribes from all streams and removes project metrics",
      () async {
        final metricsUpdates = _ReceiveProjectMetricsUpdatesStub();
        final metricsNotifier = ProjectMetricsNotifier(metricsUpdates);

        metricsNotifier.updateProjects(projects, errorMessage);

        await expectLater(metricsUpdates.hasListener, isTrue);

        await metricsNotifier.dispose();

        expect(metricsUpdates.hasListener, isFalse);
        expect(metricsNotifier.projectsMetrics, isNull);
      },
    );

    test(
      ".unsubscribeFromBuildMetrics() cancels all created subscriptions and removes project metrics",
      () async {
        final metricsUpdates = _ReceiveProjectMetricsUpdatesStub();
        final metricsNotifier = ProjectMetricsNotifier(metricsUpdates);

        metricsNotifier.updateProjects(projects, errorMessage);

        await metricsNotifier.unsubscribeFromBuildMetrics();

        expect(metricsUpdates.hasListener, isFalse);
        expect(metricsNotifier.projectsMetrics, isNull);

        await metricsNotifier.dispose();
      },
    );
  });
}

/// A stub implementation of the [ReceiveProjectMetricsUpdates].
class _ReceiveProjectMetricsUpdatesStub
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
    coverage: Percent(0.2),
    stability: Percent(0.5),
  );

  /// A [BehaviorSubject] that holds the [DashboardProjectMetrics] and provides a stream of them.
  ///
  /// The [BehaviorSubject.stream] is returned from [call] method.
  final BehaviorSubject<DashboardProjectMetrics> _metricsUpdatesSubject =
      BehaviorSubject();

  /// Creates the [_ReceiveProjectMetricsUpdatesStub] with the given [metrics].
  ///
  /// If no [metrics] passed or the `null` passed, the default project metrics used.
  _ReceiveProjectMetricsUpdatesStub({DashboardProjectMetrics metrics}) {
    _metricsUpdatesSubject.add(metrics ?? _projectMetrics);
  }

  /// Creates the [_ReceiveProjectMetricsUpdatesStub] that returns the stream
  /// that emits `null` from [call] method.
  _ReceiveProjectMetricsUpdatesStub.withNullMetrics() {
    _metricsUpdatesSubject.add(null);
  }

  @override
  Stream<DashboardProjectMetrics> call([ProjectIdParam params]) {
    return _metricsUpdatesSubject.stream;
  }

  ///  Detects if the stream, returned from [call] method has any listeners.
  bool get hasListener => _metricsUpdatesSubject.hasListener;
}
