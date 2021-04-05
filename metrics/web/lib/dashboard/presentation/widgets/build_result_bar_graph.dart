// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_duration_strategy.dart';

/// A [BarGraph] that displays the build result metric.
///
/// Applies the color theme from the [MetricsThemeData.buildResultTheme].
class BuildResultBarGraph extends StatelessWidget {
  /// A [BuildResultMetricViewModel] with data to display.
  final BuildResultMetricViewModel buildResultMetric;

  /// A [BuildResultDurationStrategy] this graph uses to define build [Duration]s.
  final BuildResultDurationStrategy durationStrategy;

  /// Creates the [BuildResultBarGraph] from the given [buildResults] and
  /// [durationStrategy].
  ///
  /// The [buildResults] must not be null.
  ///
  /// Throws an [AssertionError] if the given [buildResults] is `null`.
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

    final barStrategy = BuildResultBarPaddingStrategy(
      buildResults: buildResults,
    );

    return BarGraph(
      data: _createBarGraphData(),
      barBuilder: (index, height) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: BuildResultBar(
            strategy: barStrategy,
            buildResult: buildResults[index],
          ),
        );
      },
    );
  }

  /// Processes a [buildResultMetric.buildResults] to a [List] with the
  /// bar data to display on this bar graph.
  List<int> _createBarGraphData() {
    return buildResultMetric.buildResults
        .map(durationStrategy.getDuration)
        .map(_processBuildDuration)
        .toList();
  }

  /// Processes the given [duration] to this [duration]'s number of milliseconds
  /// using the [buildResultMetric.maxBuildDuration] as the maximum possible
  /// duration.
  ///
  /// If the [buildResultMetric.maxBuildDuration] is `null`, returns the
  /// [duration.inMilliseconds].
  ///
  /// Otherwise, returns the minimum of the [duration.inMilliseconds] and the
  /// [buildResultMetric.maxBuildDuration.inMilliseconds].
  int _processBuildDuration(Duration duration) {
    final maxBuildDurationInMilliseconds =
        buildResultMetric.maxBuildDuration?.inMilliseconds;

    if (maxBuildDurationInMilliseconds == null) return duration.inMilliseconds;

    return min(duration.inMilliseconds, maxBuildDurationInMilliseconds);
  }
}
