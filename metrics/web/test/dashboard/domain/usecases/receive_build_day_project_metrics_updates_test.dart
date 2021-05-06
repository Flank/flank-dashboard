// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/entities/build_day.dart';
import 'package:metrics/common/domain/repositories/build_day_repository.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_day_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_build_day_project_metrics_updates.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ReceiveBuildDayProjectMetricsUpdates", () {
    const projectId = 'id';
    const projectIdParam = ProjectIdParam(projectId);

    final buildDayRepository = _BuildDayRepositoryMock();
    final useCase = ReceiveBuildDayProjectMetricsUpdates(buildDayRepository);

    PostExpectation<Stream<List<BuildDay>>> whenStreamBuildDays() {
      return when(buildDayRepository.projectBuildDaysInDateRangeStream(
        projectId,
        from: anyNamed('from'),
      ));
    }

    BuildDay createBuildDay({
      int successful = 0,
      int failed = 0,
      int unknown = 0,
      int inProgress = 0,
      Duration totalDuration = Duration.zero,
      DateTime day,
    }) {
      return BuildDay(
        projectId: projectId,
        successful: successful,
        failed: failed,
        unknown: unknown,
        inProgress: inProgress,
        totalDuration: totalDuration,
        day: day ?? DateTime.now(),
      );
    }

    Matcher buildDayMetricsMatcher({
      Matcher projectIdMatcher = anything,
      Matcher buildNumberMetricMatcher = anything,
      Matcher performanceMetricMatcher = anything,
    }) {
      final metricsMatcher = isA<BuildDayProjectMetrics>();

      return allOf([
        metricsMatcher.having(
          (metrics) => metrics.projectId,
          'projectId',
          projectIdMatcher,
        ),
        metricsMatcher.having(
          (metrics) => metrics.buildNumberMetric,
          'buildNumberMetric',
          buildNumberMetricMatcher,
        ),
        metricsMatcher.having(
          (metrics) => metrics.performanceMetric,
          'performanceMetric',
          performanceMetricMatcher,
        ),
      ]);
    }

    tearDown(() {
      reset(buildDayRepository);
    });

    test(
      "throws an ArgumentError if the given build day repository is null",
      () {
        expect(
          () => ReceiveBuildDayProjectMetricsUpdates(null),
          throwsArgumentError,
        );
      },
    );

    test(
      "successfully creates an instance with the given build day repository",
      () {
        expect(
          () => ReceiveBuildDayProjectMetricsUpdates(buildDayRepository),
          returnsNormally,
        );
      },
    );

    test(
      ".call() delegates to the .projectBuildDaysInDateRangeStream() with the given project id and a non-null from date",
      () {
        whenStreamBuildDays().thenAnswer((_) => Stream.value([]));

        useCase.call(projectIdParam);

        verify(buildDayRepository.projectBuildDaysInDateRangeStream(
          projectId,
          from: argThat(isNotNull, named: 'from'),
        )).called(once);
      },
    );

    test(
      ".call() returns a build day project metrics with the given project id",
      () async {
        final expectedProjectId = projectIdParam.projectId;

        whenStreamBuildDays().thenAnswer((_) => Stream.value([]));

        final metricsStream = useCase.call(projectIdParam);

        final metricsMatcher = buildDayMetricsMatcher(
          projectIdMatcher: equals(expectedProjectId),
        );

        expect(metricsStream, emits(metricsMatcher));
      },
    );

    test(
      ".call() returns a build day project metrics with the non-null build number metric",
      () async {
        whenStreamBuildDays().thenAnswer((_) => Stream.value([]));

        final metricsStream = useCase.call(projectIdParam);

        final metricsMatcher = buildDayMetricsMatcher(
          buildNumberMetricMatcher: isNotNull,
        );

        expect(metricsStream, emits(metricsMatcher));
      },
    );

    test(
      ".call() returns a build day project metrics with the build number metric with the total number of builds",
      () async {
        final firstBuildDay = createBuildDay(successful: 1, failed: 1);
        final secondBuildDay = createBuildDay(unknown: 2, inProgress: 2);
        final buildDays = [firstBuildDay, secondBuildDay];
        const expectedNumberOfBuilds = 1 + 1 + 2 + 2;

        whenStreamBuildDays().thenAnswer((_) => Stream.value(buildDays));

        final metricsStream = useCase.call(projectIdParam);

        final metricsMatcher = buildDayMetricsMatcher(
          buildNumberMetricMatcher: isA<BuildNumberMetric>().having(
            (metric) => metric.numberOfBuilds,
            'numberOfBuilds',
            equals(expectedNumberOfBuilds),
          ),
        );

        expect(metricsStream, emits(metricsMatcher));
      },
    );

    test(
      ".call() returns a build day project metrics with the non-null performance metric",
      () async {
        whenStreamBuildDays().thenAnswer((_) => Stream.value([]));

        final metricsStream = useCase.call(projectIdParam);

        final metricsMatcher = buildDayMetricsMatcher(
          performanceMetricMatcher: isNotNull,
        );

        expect(metricsStream, emits(metricsMatcher));
      },
    );

    test(
      ".call() returns a build day project metrics with the performance metric with the zero average build duration if the total number of builds is 0",
      () async {
        final buildDay = createBuildDay();
        final buildDays = [buildDay];
        const expectedAverageDuration = Duration.zero;

        whenStreamBuildDays().thenAnswer((_) => Stream.value(buildDays));

        final metricsStream = useCase.call(projectIdParam);

        final metricsMatcher = buildDayMetricsMatcher(
          performanceMetricMatcher: isA<PerformanceMetric>().having(
            (metric) => metric.averageBuildDuration,
            'averageBuildDuration',
            equals(expectedAverageDuration),
          ),
        );

        expect(metricsStream, emits(metricsMatcher));
      },
    );

    test(
      ".call() returns a build day project metrics with the performance metric with the correct average build duration",
      () async {
        const firstDayDuration = Duration(seconds: 2);
        const secondDayDuration = Duration(seconds: 3);
        final firstBuildDay = createBuildDay(
          totalDuration: firstDayDuration,
          successful: 2,
        );
        final secondBuildDay = createBuildDay(
          totalDuration: secondDayDuration,
          failed: 3,
        );
        final buildDays = [firstBuildDay, secondBuildDay];
        const expectedAverageDuration = Duration(seconds: 1);

        whenStreamBuildDays().thenAnswer((_) => Stream.value(buildDays));

        final metricsStream = useCase.call(projectIdParam);

        final metricsMatcher = buildDayMetricsMatcher(
          performanceMetricMatcher: isA<PerformanceMetric>().having(
            (metric) => metric.averageBuildDuration,
            'averageBuildDuration',
            equals(expectedAverageDuration),
          ),
        );

        expect(metricsStream, emits(metricsMatcher));
      },
    );

    test(
      ".call() returns a build day project metrics with the performance metric having build performance with a zero average duration if a number of successful builds is 0",
      () async {
        final firstBuildDay = createBuildDay(
          successful: 0,
          day: DateTime(2020),
        );
        final buildDays = [firstBuildDay];
        final expectedPerformances = buildDays.map((buildDay) {
          return BuildPerformance(
            date: buildDay.day,
            duration: Duration.zero,
          );
        });
        final expectedBuildsPerformance = DateTimeSet<BuildPerformance>.from(
          expectedPerformances,
        );

        whenStreamBuildDays().thenAnswer((_) => Stream.value(buildDays));

        final metricsStream = useCase.call(projectIdParam);

        final metricsMatcher = buildDayMetricsMatcher(
          performanceMetricMatcher: isA<PerformanceMetric>().having(
            (metric) => metric.buildsPerformance,
            'buildsPerformance',
            equals(expectedBuildsPerformance),
          ),
        );

        expect(metricsStream, emits(metricsMatcher));
      },
    );

    test(
      ".call() returns a build day project metrics with the performance metric with the correct builds performance",
      () async {
        final firstBuildDay = createBuildDay(
          totalDuration: const Duration(seconds: 4),
          successful: 2,
          day: DateTime(2020),
        );
        final secondBuildDay = createBuildDay(
          totalDuration: const Duration(seconds: 3),
          successful: 3,
          day: DateTime(2021),
        );
        final buildDays = [firstBuildDay, secondBuildDay];
        final expectedPerformances = buildDays.map((buildDay) {
          return BuildPerformance(
            date: buildDay.day,
            duration: buildDay.totalDuration ~/ buildDay.successful,
          );
        });
        final expectedBuildsPerformance = DateTimeSet<BuildPerformance>.from(
          expectedPerformances,
        );

        whenStreamBuildDays().thenAnswer((_) => Stream.value(buildDays));

        final metricsStream = useCase.call(projectIdParam);

        final metricsMatcher = buildDayMetricsMatcher(
          performanceMetricMatcher: isA<PerformanceMetric>().having(
            (metric) => metric.buildsPerformance,
            'buildsPerformance',
            equals(expectedBuildsPerformance),
          ),
        );

        expect(metricsStream, emits(metricsMatcher));
      },
    );
  });
}

class _BuildDayRepositoryMock extends Mock implements BuildDayRepository {}
