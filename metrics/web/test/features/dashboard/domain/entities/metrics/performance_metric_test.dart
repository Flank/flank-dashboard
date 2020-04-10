// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/features/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:test/test.dart';

void main() {
  const averageBuildDuration = Duration(seconds: 2);
  final buildsPerformance = DateTimeSet.from(
    [
      BuildPerformance(
        date: DateTime.utc(2020, 4, 10),
        duration: const Duration(seconds: 2),
      )
    ],
  );

  test('Creates PerformanceMetric instance with the given options', () {
    final performanceMetric = PerformanceMetric(
      averageBuildDuration: averageBuildDuration,
      buildsPerformance: buildsPerformance,
    );

    expect(performanceMetric.averageBuildDuration, averageBuildDuration);
    expect(performanceMetric.buildsPerformance, buildsPerformance);
  });

  test('Two identical instances of PerformanceMetric are equals', () {
    final firstPerformanceMetric = PerformanceMetric(
      averageBuildDuration: averageBuildDuration,
      buildsPerformance: buildsPerformance,
    );
    final secondPerformanceMetric = PerformanceMetric(
      averageBuildDuration: averageBuildDuration,
      buildsPerformance: buildsPerformance,
    );

    expect(firstPerformanceMetric, equals(secondPerformanceMetric));
  });
}
