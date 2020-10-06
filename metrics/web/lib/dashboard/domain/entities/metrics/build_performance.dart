import 'package:meta/meta.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set_entry.dart';

/// Represents the [duration] of the build, started at [date].
@immutable
class BuildPerformance implements DateTimeSetEntry {
  @override
  final DateTime date;

  /// A [Duration] of the build.
  final Duration duration;

  /// Creates a new instance of [BuildPerformance].
  const BuildPerformance({
    this.date,
    this.duration,
  });
}
