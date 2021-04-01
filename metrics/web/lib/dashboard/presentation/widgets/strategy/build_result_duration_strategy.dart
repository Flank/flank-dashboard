// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:clock/clock.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';

/// A class that represents a strategy for defining the build's duration
/// depending on the given [BuildResultViewModel].
class BuildResultDurationStrategy {
  /// A maximum build's [Duration] of this strategy.
  final Duration maxBuildDuration;

  /// Creates a new instance of the [BuildResultDurationStrategy] with the
  /// given [maxBuildDuration].
  const BuildResultDurationStrategy({
    this.maxBuildDuration,
  });

  /// Calculates the build [Duration] of the given [buildResultViewModel] 
  /// based on the [buildResultViewModel] subtype and the
  /// [maxBuildDuration] value.
  /// 
  /// If the [maxBuildDuration] is not `null`, then the [maxBuildDuration] is
  /// the maximum possible [Duration] this method returns.
  /// 
  /// Otherwise, the [Duration] this method returns is not constrained.
  Duration getDuration(BuildResultViewModel buildResultViewModel) {
    final buildDuration = _calculateBuildDuration(buildResultViewModel);

    return _getMaxBuildDuration(buildDuration);
  }

  /// Returns the [Duration] of the given [buildResultViewModel].
  ///
  /// A [Duration] for a [FinishedBuildResultViewModel] is the
  /// [FinishedBuildResultViewModel.duration].
  ///
  /// A [Duration] for an [InProgressBuildResultViewModel] is calculated as
  /// the difference between the current timestamp and the
  /// [InProgressBuildResultViewModel.date].
  Duration _calculateBuildDuration(BuildResultViewModel buildResultViewModel) {
    if (buildResultViewModel is FinishedBuildResultViewModel) {
      return buildResultViewModel.duration;
    }

    final currentDateTime = clock.now();

    return currentDateTime.difference(buildResultViewModel.date);
  }

  /// Returns the maximum possible [Duration] using the given [buildDuration]
  /// and [maxBuildDuration].
  ///
  /// Returns the given [buildDuration] if the [maxBuildDuration] is `null`, or
  /// the given [buildDuration] is less than or equal to the [maxBuildDuration].
  ///
  /// Otherwise, returns the [maxBuildDuration].
  Duration _getMaxBuildDuration(Duration buildDuration) {
    if (maxBuildDuration == null || buildDuration <= maxBuildDuration) {
      return buildDuration;
    }

    return maxBuildDuration;
  }
}
