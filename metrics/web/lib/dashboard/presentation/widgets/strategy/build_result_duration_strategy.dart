// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:clock/clock.dart';

/// A class that represents a strategy for defining the build's duration
/// depending on the given [BuildResultViewModel] subtype.
class BuildResultDurationStrategy {
  /// Creates a new instance of the [BuildResultDurationStrategy].
  const BuildResultDurationStrategy();

  /// Provides the [Duration] for the given [buildResultViewModel].
  /// 
  /// Returns the [buildResultViewModel.duration] if the given
  /// [buildResultViewModel] is a [FinishedBuildResultViewModel].
  ///
  /// Otherwise, returns the difference between current timestamp and the
  /// [buildResultViewModel.date].
  Duration getDuration(BuildResultViewModel buildResultViewModel) {
    if (buildResultViewModel is FinishedBuildResultViewModel) {
      return buildResultViewModel.duration;
    }

    final dateTimeNow = clock.now();
    final duration = dateTimeNow.difference(buildResultViewModel.date);

    return duration;
  }
}
