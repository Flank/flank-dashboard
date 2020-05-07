import 'dart:async';

import 'package:flutter/services.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_updates.dart';
import 'package:metrics/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectMetricsNotifier", () {
    const projectId = 'projectId';
    const projectIdParam = ProjectIdParam(projectId);

    final receiveProjectMetricsUpdates = _ReceiveProjectMetricsUpdatesStub();
    final receiveProjectUpdates = _ReceiveProjectUpdatesStub();

    DashboardProjectMetrics expectedProjectMetrics;
    ProjectMetricsNotifier projectMetricsNotifier;

    setUpAll(() async {
      projectMetricsNotifier = ProjectMetricsNotifier(
        receiveProjectUpdates,
        receiveProjectMetricsUpdates,
      );

      expectedProjectMetrics =
          await receiveProjectMetricsUpdates(projectIdParam).first;

      await projectMetricsNotifier.subscribeToProjects();
    });

    tearDownAll(() {
      projectMetricsNotifier.dispose();
    });

    test(
      "throws an AssertionError if receive project updates use case is null",
      () {
        expect(
          () => ProjectMetricsNotifier(null, receiveProjectMetricsUpdates),
          MatcherUtil.throwsAssertionError,
        );
        expect(
          () => ProjectMetricsNotifier(receiveProjectUpdates, null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if receive project metric updates use case is null",
      () {
        expect(
          () => ProjectMetricsNotifier(receiveProjectUpdates, null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "creates ProjectMetrics with empty points from empty BuildMetrics",
      () async {
        final receiveEmptyMetrics = _ReceiveProjectMetricsUpdatesStub(
          metrics: const DashboardProjectMetrics(),
        );

        final projectMetricsNotifier = ProjectMetricsNotifier(
          receiveProjectUpdates,
          receiveEmptyMetrics,
        );

        await projectMetricsNotifier.subscribeToProjects();

        bool hasEmptyMetrics = false;
        final metricsListener = expectAsyncUntil0(() async {
          final projectMetrics = projectMetricsNotifier.projectsMetrics;

          if (projectMetrics == null || projectMetrics.isEmpty) return;

          hasEmptyMetrics = true;
          for (final metrics in projectMetrics) {
            if (metrics.performanceMetrics == null ||
                metrics.buildResultMetrics == null) {
              hasEmptyMetrics = false;
            } else if (metrics.performanceMetrics.isNotEmpty ||
                metrics.buildResultMetrics.isNotEmpty) {
              hasEmptyMetrics = false;
            }
          }

          if (hasEmptyMetrics) projectMetricsNotifier.dispose();
        }, () => hasEmptyMetrics);

        projectMetricsNotifier.addListener(metricsListener);
      },
    );

    test(
      "creates ProjectMetrics with null metrics if the BuildMetrics is null",
      () async {
        final receiveProjectMetricsUpdates =
            _ReceiveProjectMetricsUpdatesStub.withNullMetrics();

        final projectMetricsNotifier = ProjectMetricsNotifier(
          receiveProjectUpdates,
          receiveProjectMetricsUpdates,
        );

        await projectMetricsNotifier.subscribeToProjects();

        bool hasNullMetrics;
        final metricsListener = expectAsyncUntil0(() async {
          final projectMetrics = projectMetricsNotifier.projectsMetrics;
          if (projectMetrics == null || projectMetrics.isEmpty) return;

          final buildResultMetrics = projectMetrics.first.buildResultMetrics;
          final performanceMetrics = projectMetrics.first.performanceMetrics;

          hasNullMetrics =
              buildResultMetrics == null && performanceMetrics == null;

          if (hasNullMetrics) projectMetricsNotifier.dispose();
        }, () => hasNullMetrics);

        projectMetricsNotifier.addListener(metricsListener);
      },
    );

    test("properly loads the coverage data", () async {
      final expectedProjectCoverage = expectedProjectMetrics.coverage;

      final projectMetrics = projectMetricsNotifier.projectsMetrics.first;
      final projectCoverage = projectMetrics.coverage;

      expect(projectCoverage, expectedProjectCoverage);
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

    test("loads the build result metrics", () async {
      final expectedBuildResults =
          expectedProjectMetrics.buildResultMetrics.buildResults;

      final firstProjectMetrics = projectMetricsNotifier.projectsMetrics.first;
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
      ".errorMessage provides an error description if projects stream emits a PlatfromException",
      () async {
        final receiveProjectUpdates = _ReceiveProjectUpdatesMock();
        final projectsController = BehaviorSubject<List<Project>>();
        const errorMessage = 'errorMessage';

        when(receiveProjectUpdates())
            .thenAnswer((_) => projectsController.stream);

        final metricsNotifier = ProjectMetricsNotifier(
          receiveProjectUpdates,
          receiveProjectMetricsUpdates,
        );

        await metricsNotifier.subscribeToProjects();

        projectsController.addError(PlatformException(
          message: errorMessage,
          code: 'test_code',
        ));

        bool hasErrorDescription;
        final metricsListener = expectAsyncUntil0(() async {
          hasErrorDescription = metricsNotifier.errorMessage == errorMessage;

          if (hasErrorDescription) metricsNotifier.dispose();
        }, () => hasErrorDescription);

        metricsNotifier.addListener(metricsListener);
      },
    );

    test(
      ".errorMessage provides an error description if the project metrics stream emits a PlatfromException",
      () async {
        final receiveProjectUpdates = _ReceiveProjectUpdatesMock();
        final receiveProjectMetricsUpdates =
            _ReceiveProjectMetricsUpdatesMock();
        final metricsController = BehaviorSubject<DashboardProjectMetrics>();
        const errorMessage = 'errorMessage';

        when(receiveProjectMetricsUpdates(any))
            .thenAnswer((_) => metricsController.stream);
        when(receiveProjectUpdates()).thenAnswer((realInvocation) =>
            Stream.value([const Project(id: 'id', name: 'name')]));

        final metricsNotifier = ProjectMetricsNotifier(
          receiveProjectUpdates,
          receiveProjectMetricsUpdates,
        );

        await metricsNotifier.subscribeToProjects();

        metricsController.addError(PlatformException(
          message: errorMessage,
          code: 'test_code',
        ));

        bool hasErrorDescription = false;
        final metricsListener = expectAsyncUntil0(() async {
          hasErrorDescription = metricsNotifier.errorMessage == errorMessage;

          if (hasErrorDescription) metricsNotifier.dispose();
        }, () => hasErrorDescription);

        metricsNotifier.addListener(metricsListener);
      },
    );

    test(
      "deletes the ProjectMetrics if the project was deleted on server",
      () async {
        final projects = _ReceiveProjectUpdatesStub.testProjects.toList();

        final receiveProjectUpdates = _ReceiveProjectUpdatesStub(
          projects: projects,
        );

        final metricsNotifier = ProjectMetricsNotifier(
          receiveProjectUpdates,
          receiveProjectMetricsUpdates,
        );

        await metricsNotifier.subscribeToProjects();

        List<Project> expectedProjects = await receiveProjectUpdates().first;
        List<ProjectMetricsData> actualProjects =
            metricsNotifier.projectsMetrics;

        expect(actualProjects.length, expectedProjects.length);

        projects.removeLast();

        expectedProjects = await receiveProjectUpdates().first;
        actualProjects = metricsNotifier.projectsMetrics;

        expect(actualProjects.length, expectedProjects.length);

        metricsNotifier.dispose();
      },
    );

    test(
      ".projectMetrics are null when the projects are null",
      () async {
        final receiveProjects = _ReceiveProjectUpdatesStub(projects: null);

        final metricsNotifier = ProjectMetricsNotifier(
          receiveProjects,
          receiveProjectMetricsUpdates,
        );

        await metricsNotifier.subscribeToProjects();

        final projectMetrics = metricsNotifier.projectsMetrics;

        expect(projectMetrics, isNull);

        metricsNotifier.dispose();
      },
    );

    test(
      ".subscribeToProjects() subscribes to projects updates",
      () async {
        final projectUpdates = _ReceiveProjectUpdatesStub();
        final metricsUpdates = _ReceiveProjectMetricsUpdatesStub();

        final metricsNotifier =
            ProjectMetricsNotifier(projectUpdates, metricsUpdates);
        await metricsNotifier.subscribeToProjects();

        expect(projectUpdates.hasListener, isTrue);

        metricsNotifier.dispose();
      },
    );

    test(
      ".dispose() unsubscribes from all streams and removes project metrics",
      () async {
        final projectUpdates = _ReceiveProjectUpdatesStub();
        final metricsUpdates = _ReceiveProjectMetricsUpdatesStub();

        final metricsNotifier = ProjectMetricsNotifier(
          projectUpdates,
          metricsUpdates,
        );

        await metricsNotifier.subscribeToProjects();

        expect(projectUpdates.hasListener, isTrue);

        metricsNotifier.dispose();

        expect(projectUpdates.hasListener, isFalse);
        expect(metricsUpdates.hasListener, isFalse);
        expect(metricsNotifier.projectsMetrics, isNull);
      },
    );

    test(
      ".unsubscribeFromProjects() cancels all created subscriptions and removes project metrics",
      () async {
        final projectUpdates = _ReceiveProjectUpdatesStub();
        final metricsUpdates = _ReceiveProjectMetricsUpdatesStub();

        final metricsNotifier = ProjectMetricsNotifier(
          projectUpdates,
          metricsUpdates,
        );

        await metricsNotifier.subscribeToProjects();

        expect(projectUpdates.hasListener, isTrue);

        await metricsNotifier.unsubscribeFromProjects();

        expect(projectUpdates.hasListener, isFalse);
        expect(metricsUpdates.hasListener, isFalse);
        expect(metricsNotifier.projectsMetrics, isNull);

        metricsNotifier.dispose();
      },
    );
  });
}

/// A stub implementation of the [ReceiveProjectUpdates].
class _ReceiveProjectUpdatesStub implements ReceiveProjectUpdates {
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

  /// The list of [Project] that will be emitted by this use case.
  final List<Project> _projects;

  /// A [BehaviorSubject] that will hold the projects and provide a stream of projects.
  ///
  /// The [BehaviorSubject.stream] is returned from [call] method.
  final BehaviorSubject<List<Project>> _projectsSubject = BehaviorSubject();

  /// Creates the [_ReceiveProjectUpdatesStub].
  ///
  /// [projects] is the list of projects will be emitted by returned stream.
  /// Defaults to [testProjects].
  _ReceiveProjectUpdatesStub({List<Project> projects = testProjects})
      : _projects = projects;

  @override
  Stream<List<Project>> call([_]) {
    _projectsSubject.add(_projects);
    return _projectsSubject.stream;
  }

  /// Detects if the stream, returned from [call] method has any listeners.
  bool get hasListener => _projectsSubject.hasListener;
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
    coverage: const Percent(0.2),
    stability: const Percent(0.5),
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

class _ReceiveProjectUpdatesMock extends Mock implements ReceiveProjectUpdates {
}

class _ReceiveProjectMetricsUpdatesMock extends Mock
    implements ReceiveProjectMetricsUpdates {}
