// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:clock/clock.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/in_progress_build_result_view_model.dart';

/// A class that represents a strategy for defining the build's duration
/// depending on the given [BuildResultViewModel].
class BuildResultDurationStrategy {
  /// Creates a new instance of the [BuildResultDurationStrategy].
  const BuildResultDurationStrategy();

  /// Returns the [Duration] for the given [buildResultViewModel].
  ///
  /// Returns the [FinishedBuildResultViewModel.duration] if the given
  /// [buildResultViewModel] is a [FinishedBuildResultViewModel].
  ///
  /// Otherwise, returns the difference between the current timestamp and the
  /// [InProgressBuildResultViewModel.date].
  Duration getDuration(BuildResultViewModel buildResultViewModel) {
    if (buildResultViewModel is FinishedBuildResultViewModel) {
      return buildResultViewModel.duration;
    }

    final currentDateTime = clock.now();

    return currentDateTime.difference(buildResultViewModel.date);
  }
}
