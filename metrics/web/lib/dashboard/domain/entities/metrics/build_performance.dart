// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set_entry.dart';

/// A class that represents the performance of builds by day.
class BuildPerformance with EquatableMixin implements DateTimeSetEntry {
  @override
  final DateTime date;

  /// A [Duration] of builds by day.
  final Duration duration;

  @override
  List<Object> get props => [date, duration];

  /// Creates a new instance of the [BuildPerformance] with the given
  /// parameters.
  const BuildPerformance({
    this.date,
    this.duration,
  });
}
