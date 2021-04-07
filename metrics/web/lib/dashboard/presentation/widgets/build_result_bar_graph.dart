// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/common/presentation/widgets/timer_notifier_builder.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/in_progress_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_component.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_duration_strategy.dart';

/// A [BarGraph] that displays the build results.
class BuildResultBarGraph extends StatelessWidget {
  /// A [BuildResultMetric] with the data to display on this graph.
  final BuildResultMetricViewModel buildResultMetric;

  /// A [BuildResultDurationStrategy] this graph uses to define
  /// build [Duration]s.
  final BuildResultDurationStrategy durationStrategy;

  /// Creates a new instance of the [BuildResultBarGraph] with the given
  /// [buildResultMetric] and [durationStrategy].
  ///
  /// Throws an [AssertionError] if the given [buildResultMetric] or
  /// [durationStrategy] is `null`.
  const BuildResultBarGraph({
    Key key,
    @required this.buildResultMetric,
    @required this.durationStrategy,
  })  : assert(buildResultMetric != null),
        assert(durationStrategy != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final buildResults = buildResultMetric.buildResults;
    final paddingStrategy = BuildResultBarPaddingStrategy(
      buildResults: buildResults,
    );

    return TimerNotifierBuilder(
      shouldSubscribe: _hasInProgressBuilds,
      builder: (context) {
        return BarGraph(
          data: _createBarGraphData(),
          barBuilder: (index, height) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: height,
              ),
              child: BuildResultBarComponent(
                paddingStrategy: paddingStrategy,
                buildResult: buildResults[index],
              ),
            );
          },
        );
      },
    );
  }

  /// Returns `true` if any of the [BuildResultMetricViewModel.buildResults] is
  /// an [InProgressBuildResultViewModel].
  ///
  /// Otherwise, returns `false`.
  bool get _hasInProgressBuilds {
    return buildResultMetric.buildResults.any(
      (result) => result is InProgressBuildResultViewModel,
    );
  }

  /// Creates a [List] of the bar data from the [buildResultMetric].
  List<int> _createBarGraphData() {
    final maxBuildDuration = buildResultMetric.maxBuildDuration;

    return buildResultMetric.buildResults.map((duration) {
      final buildDuration = durationStrategy.getDuration(
        duration,
        maxBuildDuration: maxBuildDuration,
      );

      return buildDuration.inMilliseconds;
    }).toList();
  }
}
