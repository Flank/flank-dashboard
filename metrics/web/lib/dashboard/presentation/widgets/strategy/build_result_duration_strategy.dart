// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';

/// A class that represents the strategy for defining the [Build] duration
/// depending on the [BuildResultViewModel] subtype of this build.
class BuildResultDurationStrategy {
  /// Creates a new instance of the [BuildResultDurationStrategy].
  const BuildResultDurationStrategy();

  /// Provides the [Duration] for the given [buildResultViewModel].
  /// 
  /// Returns a [buildResultViewModel.duration] if the given
  /// [buildResultViewModel] is a [FinishedBuildResultViewModel].
  ///
  /// Otherwise, returns the difference between current timestamp and the
  /// [buildResultViewModel.date].
  Duration getDuration(BuildResultViewModel buildResultViewModel) {
    if (buildResultViewModel.runtimeType == FinishedBuildResultViewModel) {
      final finishedBuildResultViewModel =
          buildResultViewModel as FinishedBuildResultViewModel;

      return finishedBuildResultViewModel.duration;
    }

    final dateTimeNow = DateTime.now();
    final duration = dateTimeNow.difference(buildResultViewModel.date);

    return duration;
  }
}
