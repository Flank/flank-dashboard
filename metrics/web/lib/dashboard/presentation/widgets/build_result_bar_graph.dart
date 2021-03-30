// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_component.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_duration_strategy.dart';

/// A [BarGraph] that displays the build result metric.
///
/// Applies the color theme from the [MetricsThemeData.buildResultTheme].
class BuildResultBarGraph extends StatelessWidget {
  /// A [BuildResultMetricViewModel] with data to display.
  final List<BuildResultViewModel> buildResults;

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
    @required this.buildResults,
    this.durationStrategy,
  })  : assert(buildResults != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final barStrategy = BuildResultBarPaddingStrategy(
      buildResults: buildResults,
    );

    final barGraphDuration =
        buildResults.map(durationStrategy.getDuration).toList();
    final barGraphData =
        barGraphDuration.map((duration) => duration.inMilliseconds).toList();

    return BarGraph(
      data: barGraphData,
      barBuilder: (index, height) {
        return Container(
          constraints: BoxConstraints(
            minHeight: height,
          ),
          child: BuildResultBar(
            strategy: barStrategy,
            buildResult: buildResults[index],
          ),
        );
      },
    );
  }
}
