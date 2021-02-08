// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set_entry.dart';

/// Represents the [duration] of the build, started at [date].
@immutable
class BuildPerformance implements DateTimeSetEntry {
  @override
  final DateTime date;

  /// A [Duration] of the build.
  final Duration duration;

  /// Creates a new instance of the [BuildPerformance].
  const BuildPerformance({
    this.date,
    this.duration,
  });
}
