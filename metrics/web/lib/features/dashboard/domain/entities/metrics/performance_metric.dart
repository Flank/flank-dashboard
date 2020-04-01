import 'package:equatable/equatable.dart';
import 'package:metrics/features/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_performance.dart';

/// Represents the build performance metric.
class PerformanceMetric extends Equatable {
  final DateTimeSet<BuildPerformance> buildsPerformance;
  final Duration averageBuildDuration;

  @override
  List<Object> get props => [buildsPerformance, averageBuildDuration];

  /// Creates the [PerformanceMetric].
  ///
  /// [buildsPerformance] is the performance series of builds.
  /// [averageBuildDuration] is the average build duration of all builds in [buildsPerformance].
  const PerformanceMetric({
    this.buildsPerformance,
    this.averageBuildDuration = const Duration(),
  });
}
