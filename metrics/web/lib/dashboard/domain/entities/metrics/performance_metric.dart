import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';

/// Represents the build performance metric.
class PerformanceMetric extends Equatable {
  /// A set of builds performance.
  final DateTimeSet<BuildPerformance> buildsPerformance;

  /// An average build duration of all builds in the [buildsPerformance].
  final Duration averageBuildDuration;

  @override
  List<Object> get props => [buildsPerformance, averageBuildDuration];

  /// Creates a new instance of the [PerformanceMetric].
  ///
  /// The [averageBuildDuration] default value is [Duration.zero].
  const PerformanceMetric({
    this.buildsPerformance,
    this.averageBuildDuration = Duration.zero,
  });
}
