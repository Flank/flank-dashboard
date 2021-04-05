// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/presentation/state/timer_notifier.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_component.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_duration_strategy.dart';
import 'package:provider/provider.dart';

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

    return Consumer<TimerNotifier>(builder: (_, timerNotifier, __) {
      return BarGraph(
        data: _createBarGraphData(),
        barBuilder: (index, height) {
          return Container(
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
    });
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
