// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_duration_strategy.dart';

/// A [BarGraph] that displays the build results.
///
/// Applies the color theme from the [MetricsThemeData.buildResultTheme].
class BuildResultBarGraph extends StatelessWidget {
  /// A [List] with [BuildResultViewModel]s to display on this graph's bars.
  final List<BuildResultViewModel> buildResults;

  /// A [BuildResultDurationStrategy] this graph uses to define build [Duration]s.
  final BuildResultDurationStrategy durationStrategy;

  /// Creates the [BuildResultBarGraph] from the given [buildResults] and
  /// [durationStrategy].
  ///
  /// Throws an [AssertionError] if the given [buildResults] or
  /// [durationStrategy] is `null`.
  const BuildResultBarGraph({
    Key key,
    @required this.buildResults,
    @required this.durationStrategy,
  })  : assert(buildResults != null),
        assert(durationStrategy != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
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

  /// Processes [buildResults] to a [List] with the bar data to display on
  /// this bar graph.
  List<int> _createBarGraphData() {
    return buildResults
        .map(durationStrategy.getDuration)
        .map((duration) => duration.inMilliseconds)
        .toList();
  }
}
