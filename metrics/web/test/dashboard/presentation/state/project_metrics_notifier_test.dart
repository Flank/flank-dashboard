// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_day_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/project_build_status_metric.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_build_day_project_metrics_updates.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/in_progress_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_metrics_tile_view_model.dart';
import 'package:metrics/project_groups/presentation/models/project_group_model.dart';
import 'package:metrics/util/date.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group("ProjectMetricsNotifier", () {
    const projectId = 'projectId';
    const projectIdParam = ProjectIdParam(projectId);
    const List<ProjectModel> projects = [
      ProjectModel(id: 'id', name: 'name'),
      ProjectModel(id: 'id2', name: 'name2'),
    ];
    const String errorMessage = null;
    const maxNumberOfBuilds =
        ReceiveProjectMetricsUpdates.buildsToLoadForChartMetrics;

    final receiveProjectMetricsUpdates = _ReceiveProjectMetricsUpdatesStub();
    final receiveProjectMetricsMock = _ReceiveProjectMetricsUpdatesMock();
    final receiveEmptyProjectMetrics = _ReceiveProjectMetricsUpdatesStub(
      metrics: const DashboardProjectMetrics(),
    );
    final receiveNullProjectMetrics =
        _ReceiveProjectMetricsUpdatesStub.withNullMetrics();

    final receiveBuildDayUpdates = _ReceiveBuildDayProjectMetricsUpdatesMock();
    final receiveBuildDayUpdatesStub = _ReceiveBuildDayUpdatesStub();
    final receiveEmptyBuildDayUpdates = _ReceiveBuildDayUpdatesStub(
      metrics: const BuildDayProjectMetrics(),
    );
    final receiveNullBuildDayUpdates =
        _ReceiveBuildDayUpdatesStub.withNullMetrics();

    DashboardProjectMetrics expectedProjectMetrics;
    BuildDayProjectMetrics expectedBuildDayProjectMetrics;
    ProjectMetricsNotifier projectMetricsNotifier;

    BuildResult createBuildResult(
      BuildStatus status, {
      Duration duration = const Duration(minutes: 14),
      DateTime date,
    }) {
      return BuildResult(
        date: date ?? DateTime.now(),
        duration: duration,
        buildStatus: status,
        url: 'some url',
      );
    }

    Future<void> setUpNotifier({
      ProjectMetricsNotifier notifier,
      List<ProjectModel> projects,
      String errorMessage,
    }) async {
      final completer = Completer();

      void initializationListener() {
        if (!notifier.isMetricsLoading && !completer.isCompleted) {
          completer.complete();
        }
      }

      notifier.addListener(initializationListener);

      await notifier.setProjects(
        projects,
        errorMessage,
      );

      await completer.future;

      notifier.removeListener(initializationListener);
    }

    setUp(() async {
      projectMetricsNotifier = ProjectMetricsNotifier(
        receiveProjectMetricsUpdates,
        receiveBuildDayUpdatesStub,
      );

      expectedProjectMetrics = await receiveProjectMetricsUpdates(
        projectIdParam,
      ).first;
      expectedBuildDayProjectMetrics = await receiveBuildDayUpdatesStub(
        projectIdParam,
      ).first;

      await setUpNotifier(
        notifier: projectMetricsNotifier,
        projects: projects,
      );
    });

    tearDown(() async {
      reset(receiveProjectMetricsMock);
      reset(receiveBuildDayUpdates);
      await projectMetricsNotifier.dispose();
    });

    test(
      "throws an AssertionError if receive project metric updates use case is null",
      () {
        expect(
          () => ProjectMetricsNotifier(null, receiveBuildDayUpdates),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if receive build day project metric updates use case is null",
      () {
        expect(
          () => ProjectMetricsNotifier(receiveProjectMetricsUpdates, null),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates project metrics tile view models with empty points from empty BuildDayProjectMetrics",
      () async {
        const projects = [ProjectModel(id: 'id', name: 'name')];

        final emptyBuildResultMetric = BuildResultMetricViewModel(
          buildResults: UnmodifiableListView([]),
        );

        final projectMetricsNotifier = ProjectMetricsNotifier(
          receiveEmptyProjectMetrics,
          receiveEmptyBuildDayUpdates,
        );

        bool hasNullMetrics;
        final metricsListener = expectAsyncUntil0(() async {
          final projectMetrics =
              projectMetricsNotifier.projectsMetricsTileViewModels;

          if (projectMetrics == null || projectMetrics.isEmpty) return;

          final projectMetric = projectMetrics.first;
          final buildResultMetrics = projectMetric.buildResultMetrics;
          final performanceMetrics = projectMetric.performanceSparkline;
          final stabilityMetric = projectMetric.stability;

          hasNullMetrics = buildResultMetrics == emptyBuildResultMetric &&
              performanceMetrics != null &&
              performanceMetrics.performance.isEmpty &&
              stabilityMetric != null;
        }, () => hasNullMetrics);

        projectMetricsNotifier.addListener(metricsListener);

        await projectMetricsNotifier.setProjects(projects, errorMessage);

        addTearDown(projectMetricsNotifier.dispose);
      },
    );

    test(
      "creates project metrics tile view models with null metrics if the emitted DashboardProjectMetrics is null",
      () async {
        final projectMetricsNotifier = ProjectMetricsNotifier(
          receiveNullProjectMetrics,
          receiveEmptyBuildDayUpdates,
        );

        bool hasNullMetrics;
        final metricsListener = expectAsyncUntil0(() async {
          final projectMetrics =
              projectMetricsNotifier.projectsMetricsTileViewModels;
          if (projectMetrics == null || projectMetrics.isEmpty) return;

          final buildStatusMetric = projectMetrics.first.buildStatus;
          final coverageMetric = projectMetrics.first.coverage;
          final buildResultMetric = projectMetrics.first.buildResultMetrics;
          final stabilityMetric = projectMetrics.first.stability;

          hasNullMetrics = buildStatusMetric.value == null &&
              coverageMetric.value == null &&
              buildResultMetric == null &&
              stabilityMetric.value == null;
        }, () => hasNullMetrics);
        projectMetricsNotifier.addListener(metricsListener);

        await projectMetricsNotifier.setProjects(projects, errorMessage);

        addTearDown(projectMetricsNotifier.dispose);
      },
    );

    test(
      "creates project metrics tile view models with null performance and build number metrics if the emitted BuildDayProjectMetrics is null",
      () async {
        final projectMetricsNotifier = ProjectMetricsNotifier(
          receiveEmptyProjectMetrics,
          receiveNullBuildDayUpdates,
        );

        bool hasNullMetrics;
        final metricsListener = expectAsyncUntil0(() async {
          final projectMetrics =
              projectMetricsNotifier.projectsMetricsTileViewModels;

          if (projectMetrics == null || projectMetrics.isEmpty) return;

          final buildNumberMetric = projectMetrics.first.buildNumberMetric;
          final performanceMetric = projectMetrics.first.performanceSparkline;

          hasNullMetrics =
              buildNumberMetric == null && performanceMetric == null;
        }, () => hasNullMetrics);

        projectMetricsNotifier.addListener(metricsListener);

        await projectMetricsNotifier.setProjects(projects, errorMessage);

        addTearDown(projectMetricsNotifier.dispose);
      },
    );

    test(
      "loads the build status data from the dashboard metrics",
      () async {
        final expectedProjectBuildStatus =
            expectedProjectMetrics.projectBuildStatusMetric;

        final projectMetrics =
            projectMetricsNotifier.projectsMetricsTileViewModels.first;
        final projectBuildStatus = projectMetrics.buildStatus;

        expect(
          projectBuildStatus.value,
          equals(expectedProjectBuildStatus.status),
        );
      },
    );

    test(
      "loads the coverage data from the dashboard metrics",
      () async {
        final expectedProjectCoverage = expectedProjectMetrics.coverage;

        final projectMetrics =
            projectMetricsNotifier.projectsMetricsTileViewModels.first;
        final projectCoverage = projectMetrics.coverage;

        expect(projectCoverage.value, equals(expectedProjectCoverage.value));
      },
    );

    test(
      "loads the stability data from the dashboard metrics",
      () async {
        final expectedProjectStability = expectedProjectMetrics.stability;

        final projectMetrics =
            projectMetricsNotifier.projectsMetricsTileViewModels.first;
        final projectStability = projectMetrics.stability;

        expect(projectStability.value, equals(expectedProjectStability.value));
      },
    );

    test(
      "loads the build number metrics from the build day metrics",
      () async {
        final expectedNumberOfBuilds =
            expectedBuildDayProjectMetrics.buildNumberMetric.numberOfBuilds;

        final projectMetrics =
            projectMetricsNotifier.projectsMetricsTileViewModels.first;
        final buildNumberMetric = projectMetrics.buildNumberMetric;
        final actualNumberOfBuilds = buildNumberMetric.numberOfBuilds;

        expect(actualNumberOfBuilds, equals(expectedNumberOfBuilds));
      },
    );

    test(
      "loads the correct number number of performance points from the build day project metrics",
      () async {
        final period = ReceiveProjectMetricsUpdates.buildsLoadingPeriod.inDays;
        final expectedNumberOfPoints = period + 1;

        final firstProjectMetrics =
            projectMetricsNotifier.projectsMetricsTileViewModels.first;
        final performanceMetrics = firstProjectMetrics.performanceSparkline;
        final performancePoints = performanceMetrics.performance;

        expect(performancePoints, hasLength(expectedNumberOfPoints));
      },
    );

    test(
      "loads the performance metrics from the build day project metrics with the correct average duration",
      () async {
        final performance = expectedBuildDayProjectMetrics.performanceMetric;
        final expectedDuration = performance.averageBuildDuration;

        final firstProjectMetrics =
            projectMetricsNotifier.projectsMetricsTileViewModels.first;
        final performanceMetrics = firstProjectMetrics.performanceSparkline;

        expect(performanceMetrics.value, equals(expectedDuration));
      },
    );

    test(
      "loads the performance metrics from the build day project metrics",
      () async {
        final period = ReceiveProjectMetricsUpdates.buildsLoadingPeriod.inDays;
        final expectedPerformanceMetrics =
            expectedBuildDayProjectMetrics.performanceMetric;

        final expectedPoints = List.generate(
          period,
          (index) => Point(index, 0),
        );
        final buildPerformance =
            expectedPerformanceMetrics.buildsPerformance.first;
        expectedPoints.add(
          Point(period, buildPerformance.duration.inMilliseconds),
        );

        final firstProjectMetrics =
            projectMetricsNotifier.projectsMetricsTileViewModels.first;
        final performanceMetrics = firstProjectMetrics.performanceSparkline;
        final performancePoints = performanceMetrics.performance;

        expect(performancePoints, equals(expectedPoints));
      },
    );

    test(
      "create performance points with an Y axis equal to 0 if there are no builds performed during the day in the period",
      () async {
        final loadingPeriodInDays =
            ReceiveBuildDayProjectMetricsUpdates.metricsLoadingPeriod.inDays;
        final currentDate = DateTime.now().date;
        const absentPerformanceDay = 4;
        const expectedPoint = Point(absentPerformanceDay, 0);
        final buildsPerformance = List.generate(
          loadingPeriodInDays + 1,
          (index) => BuildPerformance(
            date: currentDate.subtract(
              Duration(days: loadingPeriodInDays - index),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
        buildsPerformance.removeAt(absentPerformanceDay);

        final buildDayMetrics = BuildDayProjectMetrics(
          projectId: 'id',
          performanceMetric: PerformanceMetric(
            buildsPerformance: DateTimeSet.from(buildsPerformance),
            averageBuildDuration: const Duration(minutes: 3),
          ),
          buildNumberMetric: const BuildNumberMetric(
            numberOfBuilds: 2,
          ),
        );

        final receiveBuildDayUpdates = _ReceiveBuildDayUpdatesStub(
          metrics: buildDayMetrics,
        );
        final projectMetricsNotifier = ProjectMetricsNotifier(
          receiveEmptyProjectMetrics,
          receiveBuildDayUpdates,
        );
        await setUpNotifier(
          notifier: projectMetricsNotifier,
          projects: projects,
        );

        final projectMetrics =
            projectMetricsNotifier.projectsMetricsTileViewModels.first;
        final performanceSparklineViewModel =
            projectMetrics.performanceSparkline;
        final performancePoints = performanceSparklineViewModel.performance;
        final actualPoint = performancePoints[absentPerformanceDay];

        expect(actualPoint, equals(expectedPoint));
      },
    );

    test(
      "maps the finished build results to finished build result view models",
      () async {
        final dashboardMetrics = DashboardProjectMetrics(
          projectId: 'id',
          buildResultMetrics: BuildResultMetric(
            buildResults: [
              createBuildResult(BuildStatus.successful),
              createBuildResult(BuildStatus.unknown),
              createBuildResult(BuildStatus.failed),
            ],
          ),
        );
        when(receiveProjectMetricsMock.call(any)).thenAnswer(
          (_) => Stream.value(dashboardMetrics),
        );

        final notifier = ProjectMetricsNotifier(
          receiveProjectMetricsMock,
          receiveBuildDayUpdatesStub,
        );

        await setUpNotifier(notifier: notifier, projects: projects);

        final projectMetrics = notifier.projectsMetricsTileViewModels.first;
        final buildResultMetrics = projectMetrics.buildResultMetrics;

        final viewModels = buildResultMetrics.buildResults;

        expect(viewModels, everyElement(isA<FinishedBuildResultViewModel>()));
      },
    );

    test(
      "maps the in-progress build results to in progress build result view models",
      () async {
        final dashboardMetrics = DashboardProjectMetrics(
          projectId: 'id',
          buildResultMetrics: BuildResultMetric(
            buildResults: [createBuildResult(BuildStatus.inProgress)],
          ),
        );
        when(receiveProjectMetricsMock.call(any)).thenAnswer(
          (_) => Stream.value(dashboardMetrics),
        );

        final notifier = ProjectMetricsNotifier(
          receiveProjectMetricsMock,
          receiveBuildDayUpdatesStub,
        );

        await setUpNotifier(notifier: notifier, projects: projects);

        final projectMetrics = notifier.projectsMetricsTileViewModels.first;
        final buildResultMetrics = projectMetrics.buildResultMetrics;

        final viewModels = buildResultMetrics.buildResults;

        expect(viewModels, isNotEmpty);
        expect(viewModels, everyElement(isA<InProgressBuildResultViewModel>()));
      },
    );

    test(
      "loads a build result metrics with no more than number of builds to load for chart metrics build result view models",
      () async {
        final dashboardMetrics = DashboardProjectMetrics(
          projectId: 'id',
          buildResultMetrics: BuildResultMetric(
            buildResults: List.generate(
              maxNumberOfBuilds * 2,
              (_) => createBuildResult(BuildStatus.inProgress),
            ),
          ),
        );

        when(receiveProjectMetricsMock.call(any)).thenAnswer(
          (_) => Stream.value(dashboardMetrics),
        );

        final notifier = ProjectMetricsNotifier(
          receiveProjectMetricsMock,
          receiveBuildDayUpdatesStub,
        );

        await setUpNotifier(notifier: notifier, projects: projects);

        final projectMetrics = notifier.projectsMetricsTileViewModels.first;
        final buildResultMetrics = projectMetrics.buildResultMetrics;

        final viewModels = buildResultMetrics.buildResults;

        expect(viewModels, hasLength(lessThanOrEqualTo(maxNumberOfBuilds)));
      },
    );

    test(
      "loads a build result metric with the maximum build duration from the latest number of builds to load for chart metrics build results",
      () async {
        const expectedMaximumDuration = Duration(days: 3);

        final buildResults = [
          createBuildResult(
            BuildStatus.successful,
            duration: const Duration(days: 2),
          ),
          createBuildResult(
            BuildStatus.successful,
            duration: expectedMaximumDuration,
          ),
        ];

        final dashboardMetrics = DashboardProjectMetrics(
          projectId: 'id',
          buildResultMetrics: BuildResultMetric(
            buildResults: buildResults,
          ),
        );
        when(receiveProjectMetricsMock.call(any)).thenAnswer(
          (_) => Stream.value(dashboardMetrics),
        );

        final notifier = ProjectMetricsNotifier(
          receiveProjectMetricsMock,
          receiveBuildDayUpdatesStub,
        );
        await setUpNotifier(notifier: notifier, projects: projects);

        final projectMetrics = notifier.projectsMetricsTileViewModels.first;
        final buildResultMetrics = projectMetrics.buildResultMetrics;

        final maximumDuration = buildResultMetrics.maxBuildDuration;

        expect(maximumDuration, equals(expectedMaximumDuration));
      },
    );

    test(
      "loads a build result metric with null date range if the build results are empty",
      () async {
        const dashboardMetrics = DashboardProjectMetrics(
          projectId: 'id',
          buildResultMetrics: BuildResultMetric(),
        );
        when(receiveProjectMetricsMock.call(any)).thenAnswer(
          (_) => Stream.value(dashboardMetrics),
        );

        final notifier = ProjectMetricsNotifier(
          receiveProjectMetricsMock,
          receiveBuildDayUpdatesStub,
        );
        await setUpNotifier(notifier: notifier, projects: projects);

        final projectMetrics = notifier.projectsMetricsTileViewModels.first;
        final buildResultMetrics = projectMetrics.buildResultMetrics;

        expect(buildResultMetrics.dateRangeViewModel, isNull);
      },
    );

    test(
      "loads a build result metric with the date range containing the start date from the latest number of builds to load for chart metrics build results",
      () async {
        final expectedStartDate = DateTime(2020);

        final buildResults = [
          createBuildResult(
            BuildStatus.successful,
            date: expectedStartDate,
          ),
          createBuildResult(BuildStatus.successful),
          createBuildResult(BuildStatus.successful),
        ];

        final dashboardMetrics = DashboardProjectMetrics(
          projectId: 'id',
          buildResultMetrics: BuildResultMetric(
            buildResults: buildResults,
          ),
        );
        when(receiveProjectMetricsMock.call(any)).thenAnswer(
          (_) => Stream.value(dashboardMetrics),
        );

        final notifier = ProjectMetricsNotifier(
          receiveProjectMetricsMock,
          receiveBuildDayUpdatesStub,
        );
        await setUpNotifier(notifier: notifier, projects: projects);

        final projectMetrics = notifier.projectsMetricsTileViewModels.first;
        final buildResultMetrics = projectMetrics.buildResultMetrics;

        final startDate = buildResultMetrics.dateRangeViewModel.start;

        expect(startDate, equals(expectedStartDate));
      },
    );

    test(
      "loads a build result metric with the date range containing the end date from the latest number of builds to load for chart metrics build results",
      () async {
        final expectedEndDate = DateTime(2021);

        final buildResults = [
          createBuildResult(BuildStatus.successful),
          createBuildResult(BuildStatus.successful),
          createBuildResult(
            BuildStatus.successful,
            date: expectedEndDate,
          ),
        ];

        final dashboardMetrics = DashboardProjectMetrics(
          projectId: 'id',
          buildResultMetrics: BuildResultMetric(
            buildResults: buildResults,
          ),
        );
        when(receiveProjectMetricsMock.call(any)).thenAnswer(
          (_) => Stream.value(dashboardMetrics),
        );

        final notifier = ProjectMetricsNotifier(
          receiveProjectMetricsMock,
          receiveBuildDayUpdatesStub,
        );
        await setUpNotifier(notifier: notifier, projects: projects);

        final projectMetrics = notifier.projectsMetricsTileViewModels.first;
        final buildResultMetrics = projectMetrics.buildResultMetrics;

        final endDate = buildResultMetrics.dateRangeViewModel.end;

        expect(endDate, equals(expectedEndDate));
      },
    );

    test("loads the build result metrics", () async {
      final expectedBuildResults =
          expectedProjectMetrics.buildResultMetrics.buildResults;

      final firstProjectMetrics =
          projectMetricsNotifier.projectsMetricsTileViewModels.first;
      final buildResultMetrics = firstProjectMetrics.buildResultMetrics;

      expect(
        buildResultMetrics.buildResults.length,
        expectedBuildResults.length,
      );

      final expectedBuildResult = expectedBuildResults.first;
      final firstBuildResultMetric =
          buildResultMetrics.buildResults.first as FinishedBuildResultViewModel;

      expect(
        firstBuildResultMetric.duration,
        expectedBuildResult.duration,
      );
      expect(
        firstBuildResultMetric.date,
        expectedBuildResult.date,
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
          receiveBuildDayUpdatesStub,
        );

        await metricsNotifier.setProjects(projects, errorMessage);

        final List<ProjectModel> expectedProjects = [...projects];
        List<ProjectMetricsTileViewModel> actualProjects =
            metricsNotifier.projectsMetricsTileViewModels;

        expect(actualProjects.length, expectedProjects.length);

        expectedProjects.removeLast();

        await metricsNotifier.setProjects(expectedProjects, errorMessage);

        actualProjects = metricsNotifier.projectsMetricsTileViewModels;

        expect(actualProjects.length, expectedProjects.length);

        await metricsNotifier.dispose();
      },
    );

    test(
      ".projectMetrics is an empty list when the projects parameter is an empty list",
      () async {
        final metricsNotifier = ProjectMetricsNotifier(
          receiveProjectMetricsUpdates,
          receiveBuildDayUpdatesStub,
        );

        bool hasEmptyProjectMetrics;
        final metricsListener = expectAsyncUntil0(() async {
          final projectMetrics = metricsNotifier.projectsMetricsTileViewModels;
          hasEmptyProjectMetrics =
              projectMetrics != null && projectMetrics.isEmpty;

          if (hasEmptyProjectMetrics) await metricsNotifier.dispose();
        }, () => hasEmptyProjectMetrics);

        metricsNotifier.addListener(metricsListener);

        await metricsNotifier.setProjects([], errorMessage);
      },
    );

    test(
      ".filterByProjectName() filters list of the project metrics according to the given value",
      () async {
        final metricsTileViewModel =
            projectMetricsNotifier.projectsMetricsTileViewModels.last;
        final expectedProjectMetrics = [metricsTileViewModel];
        final projectNameFilter = metricsTileViewModel.projectName;

        final listener = expectAsyncUntil0(
          () {},
          () {
            final filteredProjectMetrics =
                projectMetricsNotifier.projectsMetricsTileViewModels;
            return listEquals(filteredProjectMetrics, expectedProjectMetrics);
          },
        );

        projectMetricsNotifier.addListener(listener);
        projectMetricsNotifier.filterByProjectName(projectNameFilter);
      },
    );

    test(
      ".resetProjectNameFilter() resets the project name filter",
      () async {
        const projectNameFilter = 'filter name';

        final listener = expectAsyncUntil0(
          () {
            if (projectMetricsNotifier.projectNameFilter != null) {
              projectMetricsNotifier.resetProjectNameFilter();
            }
          },
          () => projectMetricsNotifier.projectNameFilter == null,
        );

        projectMetricsNotifier.addListener(listener);
        projectMetricsNotifier.filterByProjectName(projectNameFilter);
      },
    );

    test(
      ".filterByProjectName() doesn't apply filters to the list of the project metrics if the given value is null",
      () async {
        final expectedProjectMetrics =
            projectMetricsNotifier.projectsMetricsTileViewModels;

        final listener = expectAsyncUntil0(
          () {},
          () {
            final filteredProjectMetrics =
                projectMetricsNotifier.projectsMetricsTileViewModels;
            return listEquals(filteredProjectMetrics, expectedProjectMetrics);
          },
        );

        projectMetricsNotifier.addListener(listener);
        projectMetricsNotifier.filterByProjectName(null);
      },
    );

    test(
      ".filterByProjectName() updates the project name filter value",
      () async {
        const expectedProjectNameFilter = 'some project';

        final listener = expectAsyncUntil0(
          () {},
          () {
            return projectMetricsNotifier.projectNameFilter ==
                expectedProjectNameFilter;
          },
        );

        projectMetricsNotifier.addListener(listener);
        projectMetricsNotifier.filterByProjectName(expectedProjectNameFilter);
      },
    );

    test(
      ".dispose() unsubscribes from all streams and removes project metrics",
      () async {
        final metricsUpdates = _ReceiveProjectMetricsUpdatesStub();
        final buildDayUpdates = _ReceiveBuildDayUpdatesStub();

        final metricsNotifier = ProjectMetricsNotifier(
          metricsUpdates,
          buildDayUpdates,
        );

        await metricsNotifier.setProjects(projects, errorMessage);

        await expectLater(metricsUpdates.hasListener, isTrue);

        await metricsNotifier.dispose();

        expect(metricsUpdates.hasListener, isFalse);
        expect(buildDayUpdates.hasListener, isFalse);
        expect(metricsNotifier.projectsMetricsTileViewModels, isNull);
      },
    );

    test(
      ".setProjects() cancels all created subscriptions and removes project metrics if the given projects are null",
      () async {
        final metricsUpdates = _ReceiveProjectMetricsUpdatesStub();
        final buildDayUpdates = _ReceiveBuildDayUpdatesStub();
        final metricsNotifier = ProjectMetricsNotifier(
          metricsUpdates,
          buildDayUpdates,
        );

        await metricsNotifier.setProjects(projects, errorMessage);

        expect(metricsUpdates.hasListener, isTrue);

        await metricsNotifier.setProjects(null, null);

        expect(metricsUpdates.hasListener, isFalse);
        expect(buildDayUpdates.hasListener, isFalse);
        expect(metricsNotifier.projectsMetricsTileViewModels, isNull);

        await metricsNotifier.dispose();
      },
    );

    test(
      ".setProjects() cancels all created subscriptions and removes project metrics if the given projects are empty",
      () async {
        final metricsUpdates = _ReceiveProjectMetricsUpdatesStub();
        final buildDayUpdates = _ReceiveBuildDayUpdatesStub();

        final metricsNotifier = ProjectMetricsNotifier(
          metricsUpdates,
          buildDayUpdates,
        );

        await metricsNotifier.setProjects(projects, errorMessage);

        expect(metricsUpdates.hasListener, isTrue);
        expect(buildDayUpdates.hasListener, isTrue);

        await metricsNotifier.setProjects([], null);

        expect(metricsUpdates.hasListener, isFalse);
        expect(buildDayUpdates.hasListener, isFalse);
        expect(metricsNotifier.projectsMetricsTileViewModels, isEmpty);

        await metricsNotifier.dispose();
      },
    );

    test(
      ".setProjectGroups() refreshes a list of project group dropdown item view models",
      () {
        final projectGroups = [
          ProjectGroupModel(
            id: "id",
            name: "name",
            projectIds: UnmodifiableListView([]),
          ),
          ProjectGroupModel(
            id: "id2",
            name: "name1",
            projectIds: UnmodifiableListView([]),
          ),
        ];

        projectMetricsNotifier.setProjectGroups(projectGroups);

        final newProjectGroups = [
          ProjectGroupModel(
            id: "id",
            name: "name",
            projectIds: UnmodifiableListView(['id1']),
          ),
          ProjectGroupModel(
            id: "id2",
            name: "name2",
            projectIds: UnmodifiableListView(['id2']),
          ),
        ];

        final newProjectGroupItemViewModels = newProjectGroups.map(
          (projectGroup) => ProjectGroupDropdownItemViewModel(
            id: projectGroup.id,
            name: projectGroup.name,
          ),
        );

        projectMetricsNotifier.setProjectGroups(newProjectGroups);

        expect(
          projectMetricsNotifier.projectGroupDropdownItems,
          containsAll(newProjectGroupItemViewModels),
        );
      },
    );

    test(
      ".setProjectGroups() updates selected project group",
      () {
        const projectGroupId = "groupId";

        final List<ProjectGroupModel> projectGroups = [
          ProjectGroupModel(
            id: projectGroupId,
            name: "name",
            projectIds: UnmodifiableListView([]),
          ),
        ];

        projectMetricsNotifier.setProjectGroups(projectGroups);
        projectMetricsNotifier.selectProjectGroup(projectGroupId);

        final updatedProjectGroup = ProjectGroupModel(
          id: projectGroupId,
          name: "name1",
          projectIds: UnmodifiableListView([]),
        );
        final newProjectGroups = [updatedProjectGroup];

        projectMetricsNotifier.setProjectGroups(newProjectGroups);

        expect(
          projectMetricsNotifier.selectedProjectGroup.id,
          equals(projectGroupId),
        );
        expect(
          projectMetricsNotifier.selectedProjectGroup.name,
          equals(updatedProjectGroup.name),
        );
      },
    );

    test(
      ".setProjectGroups() selects the all projects project group if the selected one was deleted",
      () {
        const expectedSelectedProjectGroup = ProjectGroupDropdownItemViewModel(
          name: "All projects",
        );
        const projectGroupId = "groupId";

        final firstProjectGroup = ProjectGroupModel(
          id: projectGroupId,
          name: "name",
          projectIds: UnmodifiableListView([]),
        );
        final secondProjectGroup = ProjectGroupModel(
          id: "groupId2",
          name: "name1",
          projectIds: UnmodifiableListView([]),
        );

        final List<ProjectGroupModel> projectGroups = [
          firstProjectGroup,
          secondProjectGroup,
        ];

        projectMetricsNotifier.setProjectGroups(projectGroups);
        projectMetricsNotifier.selectProjectGroup(projectGroupId);

        expect(
          projectMetricsNotifier.selectedProjectGroup.id,
          equals(projectGroupId),
        );

        final newProjectGroups = [secondProjectGroup];

        projectMetricsNotifier.setProjectGroups(newProjectGroups);

        expect(
          projectMetricsNotifier.selectedProjectGroup,
          equals(expectedSelectedProjectGroup),
        );
      },
    );

    test(
      ".selectProjectGroup() filters a list of project metrics according to the given project group id",
      () {
        const projectId = "projectId";
        const projectGroupId = "groupId";
        const selectedProjectIds = [projectId];

        const projects = [
          ProjectModel(id: projectId, name: 'name'),
          ProjectModel(id: 'projectId2', name: 'name'),
        ];

        final List<ProjectGroupModel> projectGroups = [
          ProjectGroupModel(
            id: projectGroupId,
            name: "name",
            projectIds: UnmodifiableListView(selectedProjectIds),
          ),
          ProjectGroupModel(
            id: "groupId2",
            name: "name1",
            projectIds: UnmodifiableListView([]),
          ),
        ];

        projectMetricsNotifier.setProjects(projects, null);
        projectMetricsNotifier.setProjectGroups(projectGroups);
        projectMetricsNotifier.selectProjectGroup(projectGroupId);

        final projectMetricsTileIds = projectMetricsNotifier
            .projectsMetricsTileViewModels
            .map((tile) => tile.projectId)
            .toList();

        expect(
          projectMetricsTileIds,
          equals(selectedProjectIds),
        );
      },
    );

    test(
      ".selectProjectGroup() selects the project group with the given id",
      () {
        const projectGroupId = "id";

        final List<ProjectGroupModel> projectGroups = [
          ProjectGroupModel(
            id: projectGroupId,
            name: "name",
            projectIds: UnmodifiableListView([]),
          ),
          ProjectGroupModel(
            id: "id2",
            name: "name1",
            projectIds: UnmodifiableListView([]),
          ),
        ];

        projectMetricsNotifier.setProjectGroups(projectGroups);
        projectMetricsNotifier.selectProjectGroup(projectGroupId);

        expect(
          projectMetricsNotifier.selectedProjectGroup.id,
          equals(projectGroupId),
        );
      },
    );

    test(
      ".selectProjectGroup() doesn't select the project group if there is no project group with the given id",
      () {
        final projectGroups = [
          ProjectGroupModel(
            id: "id",
            name: "name",
            projectIds: UnmodifiableListView([]),
          ),
          ProjectGroupModel(
            id: "id2",
            name: "name1",
            projectIds: UnmodifiableListView([]),
          ),
        ];

        projectMetricsNotifier.setProjectGroups(projectGroups);

        final initialSelectedProjectGroup =
            projectMetricsNotifier.selectedProjectGroup;

        projectMetricsNotifier.selectProjectGroup("no_such_id");

        expect(
          projectMetricsNotifier.selectedProjectGroup,
          equals(initialSelectedProjectGroup),
        );
      },
    );

    test(
      ".setProjectGroups() resets project group dropdown items and selected project group to null if project groups are null",
      () {
        final projectGroups = [
          ProjectGroupModel(
            id: "id",
            name: "name",
            projectIds: UnmodifiableListView([]),
          ),
          ProjectGroupModel(
            id: "id2",
            name: "name1",
            projectIds: UnmodifiableListView([]),
          ),
        ];

        projectMetricsNotifier.setProjectGroups(projectGroups);

        expect(projectMetricsNotifier.selectedProjectGroup, isNotNull);
        expect(projectMetricsNotifier.projectGroupDropdownItems, isNotNull);

        projectMetricsNotifier.setProjectGroups(null);

        expect(projectMetricsNotifier.selectedProjectGroup, isNull);
        expect(projectMetricsNotifier.projectGroupDropdownItems, isNull);
      },
    );
  });
}

/// A stub implementation of the [ReceiveBuildDayProjectMetricsUpdates]
/// to use in tests.
class _ReceiveBuildDayUpdatesStub
    implements ReceiveBuildDayProjectMetricsUpdates {
  /// A test [BuildDayProjectMetrics] used in tests.
  static final _buildDayProjectMetrics = BuildDayProjectMetrics(
    projectId: 'id',
    performanceMetric: PerformanceMetric(
      buildsPerformance: DateTimeSet.from([
        BuildPerformance(
          date: DateTime.now(),
          duration: const Duration(minutes: 14),
        ),
      ]),
      averageBuildDuration: const Duration(minutes: 3),
    ),
    buildNumberMetric: const BuildNumberMetric(
      numberOfBuilds: 2,
    ),
  );

  /// A [BehaviorSubject] that holds the [BuildDayProjectMetrics] and provides
  /// a stream of them.
  ///
  /// The [BehaviorSubject.stream] is returned from [call] method.
  final BehaviorSubject<BuildDayProjectMetrics> _buildDaysMetricsSubject =
      BehaviorSubject();

  ///  Detects if the stream, returned from [call] method has any listeners.
  bool get hasListener => _buildDaysMetricsSubject.hasListener;

  /// Creates a new instance of the [_ReceiveBuildDayUpdatesStub] with the
  /// given [metrics].
  ///
  /// If no [metrics] passed or the `null` passed, the [_buildDayProjectMetrics]
  /// is used.
  _ReceiveBuildDayUpdatesStub({BuildDayProjectMetrics metrics}) {
    _buildDaysMetricsSubject.add(metrics ?? _buildDayProjectMetrics);
  }

  /// Creates a new [_ReceiveProjectMetricsUpdatesStub] instance that returns
  /// that emits `null` from the [call] method.
  _ReceiveBuildDayUpdatesStub.withNullMetrics() {
    _buildDaysMetricsSubject.add(null);
  }

  @override
  Stream<BuildDayProjectMetrics> call(ProjectIdParam params) {
    return _buildDaysMetricsSubject.stream;
  }
}

/// A stub implementation of the [ReceiveProjectMetricsUpdates].
class _ReceiveProjectMetricsUpdatesStub
    implements ReceiveProjectMetricsUpdates {
  /// A test [DashboardProjectMetrics] used in tests.
  static final _projectMetrics = DashboardProjectMetrics(
    projectId: 'id',
    buildResultMetrics: BuildResultMetric(
      buildResults: [
        BuildResult(
          date: DateTime.now(),
          duration: const Duration(minutes: 14),
          url: 'some url',
        ),
        BuildResult(
          date: DateTime.now(),
          duration: const Duration(minutes: 14),
          buildStatus: BuildStatus.inProgress,
          url: 'some url',
        ),
      ],
    ),
    coverage: Percent(0.2),
    stability: Percent(0.5),
    projectBuildStatusMetric: const ProjectBuildStatusMetric(
      status: BuildStatus.successful,
    ),
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

class _ReceiveProjectMetricsUpdatesMock extends Mock
    implements ReceiveProjectMetricsUpdates {}

class _ReceiveBuildDayProjectMetricsUpdatesMock extends Mock
    implements ReceiveBuildDayProjectMetricsUpdates {}
