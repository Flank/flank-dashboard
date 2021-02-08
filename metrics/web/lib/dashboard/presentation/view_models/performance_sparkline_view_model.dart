// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A view model that represents the data of the performance metric to display.
class PerformanceSparklineViewModel extends Equatable {
  /// A list of points representing the performance of the project builds.
  final UnmodifiableListView<Point<int>> performance;

  /// A performance value.
  final Duration value;

  @override
  List<Object> get props => [performance, value];

  /// Creates the [PerformanceSparklineViewModel] with the given parameters.
  ///
  /// The [value] default value is `0`.
  ///
  /// The [performance] and [value] must not be `null`.
  const PerformanceSparklineViewModel({
    @required this.performance,
    this.value = const Duration(),
  })  : assert(performance != null),
        assert(value != null);
}
