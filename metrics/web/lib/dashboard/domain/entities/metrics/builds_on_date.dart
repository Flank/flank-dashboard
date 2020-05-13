import 'package:meta/meta.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set_entry.dart';

/// Represents the [numberOfBuilds] on specified [date].
@immutable
class BuildsOnDate implements DateTimeSetEntry {
  @override
  final DateTime date;
  final int numberOfBuilds;

  /// Creates the [BuildsOnDate].
  ///
  /// The [date] should contain the date only, without timestamp.
  ///
  /// [date] is the date the builds was started at.
  /// [numberOfBuilds] is the total amount of builds on [date].
  BuildsOnDate({
    this.date,
    this.numberOfBuilds,
  }) : assert(date.hour == 0 &&
            date.minute == 0 &&
            date.second == 0 &&
            date.millisecond == 0 &&
            date.microsecond == 0);
}
