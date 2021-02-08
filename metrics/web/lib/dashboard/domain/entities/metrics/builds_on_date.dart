// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set_entry.dart';

/// Represents the [numberOfBuilds] on specified [date].
@immutable
class BuildsOnDate implements DateTimeSetEntry {
  @override
  final DateTime date;

  /// A total number of builds on [date].
  final int numberOfBuilds;

  /// Creates a new instance of the [BuildsOnDate].
  ///
  /// The [date] must contain the date only with no time parameters.
  BuildsOnDate({
    this.date,
    this.numberOfBuilds,
  }) : assert(date.hour == 0 &&
            date.minute == 0 &&
            date.second == 0 &&
            date.millisecond == 0 &&
            date.microsecond == 0);
}
