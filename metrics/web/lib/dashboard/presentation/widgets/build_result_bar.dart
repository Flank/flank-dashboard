// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/colored_bar/widgets/metrics_colored_bar.dart';
import 'package:metrics/common/presentation/widgets/in_progress_animated_bar.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_appearance_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:rive/rive.dart';

/// A single bar that displays a build result using
/// the given [BuildResultViewModel].
///
/// Displays the [MetricsColoredBar] if the given [BuildResultViewModel]
/// is a [FinishedBuildResultViewModel].
///
/// Otherwise, displays the [InProgressAnimatedBar].
class BuildResultBar extends StatelessWidget {
  /// A [BuildResultViewModel] with the data to display.
  final BuildResultViewModel buildResult;

  /// Creates the [BuildResultBar] with the given [buildResult].
  ///
  /// Throws an [AssertionError] if the given [buildResult] is `null`.
  const BuildResultBar({
    Key key,
    @required this.buildResult,
  })  : assert(buildResult != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barHeight = constraints.minHeight;

        return TappableArea(
          builder: (context, isHovered, _) {
            final isFinishedBuild = buildResult is FinishedBuildResultViewModel;

            if (isFinishedBuild) {
              return MetricsColoredBar<BuildStatus>(
                isHovered: isHovered,
                height: barHeight,
                strategy: const BuildResultBarAppearanceStrategy(),
                value: buildResult.buildStatus,
              );
            }

            return InProgressAnimatedBar(
              height: barHeight,
              isHovered: isHovered,
              controller: SimpleAnimation('Animation 1'),
            );
          },
        );
      },
    );
  }
}
