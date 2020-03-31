import 'package:meta/meta.dart';
import 'package:metrics/features/dashboard/domain/entities/collections/date_time_set_entry.dart';

/// Represents the [duration] of the build, started at [date].
@immutable
class BuildPerformance implements DateTimeSetEntry {
  @override
  final DateTime date;
  final Duration duration;

  const BuildPerformance({
    this.date,
    this.duration,
  });
}
