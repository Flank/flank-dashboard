// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:clock/clock.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';

/// A class that represents a strategy for defining the build's duration
/// depending on the given [BuildResultViewModel].
class BuildResultDurationStrategy {
  /// Creates a new instance of the [BuildResultDurationStrategy].
  const BuildResultDurationStrategy();

  /// Calculates the build [Duration] of the given [buildResultViewModel]
  /// based on the [buildResultViewModel] subtype and the given
  /// [maxBuildDuration]'s value.
  ///
  /// If the given [buildResultViewModel] is [FinishedBuildResultViewModel],
  /// returns the [FinishedBuildResultViewModel.duration].
  ///
  /// Otherwise, calculates the difference between the current time and the
  /// [BuildResultViewModel.date] and returns the min value between calculated
  /// and [maxBuildDuration].
  Duration getDuration(
    BuildResultViewModel buildResultViewModel, {
    Duration maxBuildDuration,
  }) {
    if (buildResultViewModel is FinishedBuildResultViewModel) {
      return buildResultViewModel.duration;
    }

    final currentDateTime = clock.now();
    final buildDuration = currentDateTime.difference(buildResultViewModel.date);

    if (maxBuildDuration == null || buildDuration < maxBuildDuration) {
      return buildDuration;
    }

    return maxBuildDuration;
  }
}
