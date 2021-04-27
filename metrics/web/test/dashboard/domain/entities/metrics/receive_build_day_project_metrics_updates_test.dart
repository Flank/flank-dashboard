// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/entities/build_day.dart';
import 'package:metrics/common/domain/repositories/build_day_repository.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_build_day_project_metrics_updates.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_utils/matchers.dart';

void main() {
  group("ReceiveBuildDayProjectMetricsUpdates", () {
    const projectId = 'id';

    const projectIdParam = ProjectIdParam(projectId);

    final buildDayRepository = _BuildDayRepositoryMock();
    final useCase = ReceiveBuildDayProjectMetricsUpdates(buildDayRepository);

    PostExpectation<Stream<List<BuildDay>>> whenFetchBuildDaysStream() {
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

    int calculateTotalNumberOfBuilds(List<BuildDay> buildDays) {
      return buildDays.fold<int>(0, (value, buildDay) {
        return value +
            buildDay.successful +
            buildDay.failed +
            buildDay.unknown +
            buildDay.inProgress;
      });
    }

    Duration calculateTotalBuildsDuration(List<BuildDay> buildDays) {
      return buildDays.fold<Duration>(Duration.zero, (value, buildDay) {
        return value + buildDay.totalDuration;
      });
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
        whenFetchBuildDaysStream().thenAnswer((_) => Stream.value([]));

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
        whenFetchBuildDaysStream().thenAnswer((_) => Stream.value([]));

        final metricsStream = useCase.call(projectIdParam);
        final buildDayMetrics = await metricsStream.firstWhere(
          (metrics) => metrics != null,
        );

        expect(buildDayMetrics.projectId, equals(projectId));
      },
    );

    test(
      ".call() returns a build day project metrics with the non-null build number metric",
      () async {
        whenFetchBuildDaysStream().thenAnswer((_) => Stream.value([]));

        final metricsStream = useCase.call(projectIdParam);
        final buildDayMetrics = await metricsStream.firstWhere(
          (metrics) => metrics != null,
        );

        expect(buildDayMetrics.buildNumberMetric, isNotNull);
      },
    );

    test(
      ".call() returns a build day project metrics with the build number metric equal to the total number of builds performed during the returned build days",
      () async {
        final firstBuildDay = createBuildDay(successful: 1, failed: 1);
        final secondBuildDay = createBuildDay(unknown: 2, inProgress: 2);
        final buildDays = [firstBuildDay, secondBuildDay];
        final expectedNumberOfBuilds = calculateTotalNumberOfBuilds(buildDays);

        whenFetchBuildDaysStream().thenAnswer((_) => Stream.value(buildDays));

        final metricsStream = useCase.call(projectIdParam);
        final buildDayMetrics = await metricsStream.firstWhere(
          (metrics) => metrics != null,
        );
        final buildNumberMetric = buildDayMetrics.buildNumberMetric;
        final actualNumberOfBuilds = buildNumberMetric.numberOfBuilds;

        expect(actualNumberOfBuilds, equals(expectedNumberOfBuilds));
      },
    );

    test(
      ".call() returns a build day project metrics with the non-null performance metric",
      () async {
        whenFetchBuildDaysStream().thenAnswer((_) => Stream.value([]));

        final metricsStream = useCase.call(projectIdParam);
        final buildDayMetrics = await metricsStream.firstWhere(
          (metrics) => metrics != null,
        );

        expect(buildDayMetrics.performanceMetric, isNotNull);
      },
    );

    test(
      ".call() returns a build day project metrics with the performance metric having zero average build duration if the returned build days don't contain any builds",
      () async {
        final buildDay = createBuildDay();
        final buildDays = [buildDay];
        const expectedAverageDuration = Duration.zero;

        whenFetchBuildDaysStream().thenAnswer((_) => Stream.value(buildDays));

        final metricsStream = useCase.call(projectIdParam);
        final buildDayMetrics = await metricsStream.firstWhere(
          (metrics) => metrics != null,
        );
        final performanceMetric = buildDayMetrics.performanceMetric;
        final actualAverageDuration = performanceMetric.averageBuildDuration;

        expect(actualAverageDuration, equals(expectedAverageDuration));
      },
    );

    test(
      ".call() returns a build day project metrics with the performance metric having the average build duration equal to the total builds' duration divided by the total number of builds performed during the returned build days",
      () async {
        final firstBuildDay = createBuildDay(
          totalDuration: const Duration(seconds: 2),
          successful: 2,
        );
        final secondBuildDay = createBuildDay(
          totalDuration: const Duration(seconds: 3),
          failed: 3,
        );
        final buildDays = [firstBuildDay, secondBuildDay];
        final totalBuildsDuration = calculateTotalBuildsDuration(buildDays);
        final totalNumberOfBuilds = calculateTotalNumberOfBuilds(buildDays);
        final expectedAverageDuration =
            totalBuildsDuration ~/ totalNumberOfBuilds;

        whenFetchBuildDaysStream().thenAnswer((_) => Stream.value(buildDays));

        final metricsStream = useCase.call(projectIdParam);
        final buildDayMetrics = await metricsStream.firstWhere(
          (metrics) => metrics != null,
        );
        final performanceMetric = buildDayMetrics.performanceMetric;
        final actualAverageDuration = performanceMetric.averageBuildDuration;

        expect(actualAverageDuration, equals(expectedAverageDuration));
      },
    );

    test(
      ".call() returns a build day project metrics with the performance metric having the builds performance created from the returned build days",
      () async {
        final firstBuildDay = createBuildDay(
          totalDuration: const Duration(seconds: 2),
          day: DateTime(2020),
        );
        final secondBuildDay = createBuildDay(
          totalDuration: const Duration(seconds: 3),
          day: DateTime(2021),
        );
        final buildDays = [firstBuildDay, secondBuildDay];
        final expectedPerformances = buildDays.map((buildDay) {
          return BuildPerformance(
            date: buildDay.day,
            duration: buildDay.totalDuration,
          );
        });
        final expectedBuildsPerformance = DateTimeSet<BuildPerformance>.from(
          expectedPerformances,
        );

        whenFetchBuildDaysStream().thenAnswer((_) => Stream.value(buildDays));

        final metricsStream = useCase.call(projectIdParam);
        final buildDayMetrics = await metricsStream.firstWhere(
          (metrics) => metrics != null,
        );
        final performanceMetric = buildDayMetrics.performanceMetric;
        final actualBuildsPerformance = performanceMetric.buildsPerformance;

        expect(actualBuildsPerformance, equals(expectedBuildsPerformance));
      },
    );
  });
}

class _BuildDayRepositoryMock extends Mock implements BuildDayRepository {}
