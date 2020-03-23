import 'package:meta/meta.dart';
import 'package:metrics/features/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/builds_on_date.dart';

/// Represents the build number metric entity.
@immutable
class BuildNumberMetric {
  final DateTimeSet<BuildsOnDate> buildsOnDateSet;
  final int totalNumberOfBuilds;

  /// Creates the [BuildNumberMetric].
  ///
  /// [buildsOnDateSet] is the list of number of builds on specific date.
  /// [totalNumberOfBuilds] is the number of builds that was used to calculate this metric.
  const BuildNumberMetric({
    this.buildsOnDateSet,
    this.totalNumberOfBuilds = 0,
  });
}
