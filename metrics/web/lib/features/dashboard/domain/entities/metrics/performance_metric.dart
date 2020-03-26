import 'package:meta/meta.dart';
import 'package:metrics/features/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_performance.dart';

/// Represents the build performance metric.
@immutable
class PerformanceMetric {
  final DateTimeSet<BuildPerformance> buildsPerformance;
  final Duration averageBuildDuration;

  /// Creates the [PerformanceMetric].
  ///
  /// [buildsPerformance] is the performance series of builds.
  /// [averageBuildDuration] is the average build duration of all builds in [buildsPerformance].
  const PerformanceMetric({
    this.buildsPerformance,
    this.averageBuildDuration = const Duration(),
  });
}
