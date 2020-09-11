// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metrics.dart';
import 'package:test/test.dart';

void main() {
  group("PerformanceMetrics", () {
    const averageBuildDuration = Duration(seconds: 2);
    final buildsPerformance = DateTimeSet.from(
      [
        BuildPerformance(
          date: DateTime.utc(2020, 4, 10),
          duration: const Duration(seconds: 2),
        )
      ],
    );

    test(
      "creates an instance with the given data",
      () {
        final performanceMetrics = PerformanceMetrics(
          averageBuildDuration: averageBuildDuration,
          buildsPerformance: buildsPerformance,
        );

        expect(
          performanceMetrics.averageBuildDuration,
          equals(averageBuildDuration),
        );
        expect(performanceMetrics.buildsPerformance, equals(buildsPerformance));
      },
    );

    test("has an averageBuildDuration of 0 if no duration is provided", () {
      expect(PerformanceMetrics().averageBuildDuration, equals(Duration.zero));
    });

    test(
      "two instances with equal fields are identical",
      () {
        final firstPerformanceMetrics = PerformanceMetrics(
          averageBuildDuration: averageBuildDuration,
          buildsPerformance: buildsPerformance,
        );
        final secondPerformanceMetrics = PerformanceMetrics(
          averageBuildDuration: averageBuildDuration,
          buildsPerformance: buildsPerformance,
        );

        expect(firstPerformanceMetrics, equals(secondPerformanceMetrics));
      },
    );
  });
}
