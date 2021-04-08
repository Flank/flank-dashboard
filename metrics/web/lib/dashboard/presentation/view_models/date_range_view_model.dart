// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/dashboard/presentation/widgets/date_range.dart';

/// A view model that holds the data to display on a [DateRange] widget.
class DateRangeViewModel extends Equatable {
  /// A [DateTime] that represents this date range's start.
  final DateTime start;

  /// A [DateTime] that represents this date range's end.
  final DateTime end;

  @override
  List<Object> get props => [start, end];

  /// Creates a new instance of the [DateRangeViewModel] with the given [start]
  /// and [end].
  ///
  /// Throws an [AssertionError] if the given [start] or [end] is `null`.
  const DateRangeViewModel({
    @required this.start,
    @required this.end,
  })  : assert(start != null),
        assert(end != null);
}
