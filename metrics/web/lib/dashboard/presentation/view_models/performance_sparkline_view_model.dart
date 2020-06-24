import 'dart:math';

import 'package:equatable/equatable.dart';

/// A view model that represents the data of the performance metric to display.
class PerformanceSparklineViewModel extends Equatable {
  /// A list of points representing the performance of the project builds.
  final List<Point<int>> performance;

  /// A performance value.
  final int value;

  @override
  List<Object> get props => [performance, value];

  /// Creates the [PerformanceSparklineViewModel] with the given parameters.
  ///
  /// The [performance] and [value] must not be `null`.
  /// The [performance] default value is an empty list.
  /// The [value] default value is `0`.
  const PerformanceSparklineViewModel({
    this.performance = const [],
    this.value = 0,
  })  : assert(performance != null),
        assert(value != null);
}
