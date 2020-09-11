import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';

/// Represents the build performance metrics.
class PerformanceMetrics extends Equatable {
  final DateTimeSet<BuildPerformance> buildsPerformance;
  final Duration averageBuildDuration;

  @override
  List<Object> get props => [buildsPerformance, averageBuildDuration];

  /// Creates the [PerformanceMetrics].
  ///
  /// [buildsPerformance] is the performance series of builds.
  /// [averageBuildDuration] is the average build duration of all builds in [buildsPerformance].
  const PerformanceMetrics({
    this.buildsPerformance,
    this.averageBuildDuration = const Duration(),
  });
}
