// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_component.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/date_range.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_duration_strategy.dart';

/// A widget that displays the build result metric as a bar graph.
///
/// Displays the metric date ranges. If the number of
/// [BuildResultMetricViewModel.buildResults] is less than the
/// [BuildResultMetricViewModel.numberOfBuildsToDisplay], adds the missing
/// [BuildResultBar]s.
class BuildResultsMetricGraph extends StatelessWidget {
  /// A [BuildResultMetricViewModel] containing the build results data to
  /// display.
  final BuildResultMetricViewModel buildResultMetric;

  /// Creates a new instance of the [BuildResultsMetricGraph] with the given
  /// [buildResultMetric].
  ///
  /// Throws an [AssertionError] if the given [buildResultMetric] is `null`.
  const BuildResultsMetricGraph({
    Key key,
    @required this.buildResultMetric,
  })  : assert(buildResultMetric != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberOfMissingBars = _calculateNumberOfMissingBars();
    final dateRange = buildResultMetric.dateRangeViewModel;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dateRange != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: DateRange(dateRange: dateRange),
          ),
        SizedBox(
          height: 56.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    numberOfMissingBars,
                    (index) => const BuildResultBarComponent(),
                  ),
                ),
              ),
              if (_hasResults)
                Padding(
                  padding: _calculateGraphPadding(numberOfMissingBars),
                  child: BuildResultBarGraph(
                    buildResultMetric: buildResultMetric,
                    durationStrategy: const BuildResultDurationStrategy(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns `true` if the [BuildResultMetricViewModel.buildResults] is not
  /// empty.
  ///
  /// Otherwise, returns `false`.
  bool get _hasResults {
    return buildResultMetric.buildResults.isNotEmpty;
  }

  /// Returns an [EdgeInsets] for the [BuildResultBarGraph] padding depending
  /// on the given [numberOfMissingBars].
  EdgeInsets _calculateGraphPadding(int numberOfMissingBars) {
    if (numberOfMissingBars > 0) return const EdgeInsets.only(left: 2);

    return EdgeInsets.zero;
  }

  /// Calculates the number of missing bars based on the length of the
  /// [BuildResultMetricViewModel.buildResults] and the
  /// [BuildResultMetricViewModel.numberOfBuildsToDisplay].
  int _calculateNumberOfMissingBars() {
    final numberOfBarsToDisplay = buildResultMetric.numberOfBuildsToDisplay;
    final numberOfBars = buildResultMetric.buildResults.length;

    return numberOfBarsToDisplay - numberOfBars;
  }
}
