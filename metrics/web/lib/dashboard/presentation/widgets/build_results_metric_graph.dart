// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_duration_strategy.dart';
import 'package:metrics/util/date.dart';

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
    final buildResultBarGraphTheme =
        MetricsTheme.of(context).buildResultBarGraphTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasDateRange)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              _createBuildsDateRange(),
              style: buildResultBarGraphTheme.textStyle,
            ),
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
                    _calculateNumberOfMissingBars(),
                    (index) => const BuildResultBar(),
                  ),
                ),
              ),
              if (_hasResults)
                Padding(
                  padding: _calculateGraphPadding(),
                  child: BuildResultBarGraph(
                    buildResults: buildResultMetric.buildResults,
                    durationStrategy: BuildResultDurationStrategy(
                      maxBuildDuration: buildResultMetric.maxBuildDuration,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns `true` if both [buildResultMetric.firstBuildDate] and
  /// [buildResultMetric.lastBuildDate] are not `null`.
  ///
  /// Otherwise, returns `false`.
  bool get _hasDateRange {
    return buildResultMetric.metricPeriodStart != null &&
        buildResultMetric.metricPeriodEnd != null;
  }

  /// Returns a [String] containing the formatted date range between the first
  /// and the last build from the [buildResultMetric].
  ///
  /// Returns the formatted first build's date, if it equals to the last build's
  /// date.
  String _createBuildsDateRange() {
    final dateFormat = DateFormat('d MMM');

    final firstDate = buildResultMetric.metricPeriodStart;
    final lastDate = buildResultMetric.metricPeriodEnd;

    final firstDateFormatted = dateFormat.format(firstDate);

    if (firstDate.date == lastDate.date) {
      return firstDateFormatted;
    }

    final lastDateFormatted = dateFormat.format(lastDate);

    return '$firstDateFormatted - $lastDateFormatted';
  }

  /// Returns `true` if [buildResultMetric.buildResults.isNotEmpty].
  ///
  /// Otherwise, returns `false`.
  bool get _hasResults {
    return buildResultMetric.buildResults.isNotEmpty;
  }

  /// Returns an [EdgeInsets] for the [BuildResultBarGraph] padding depending
  /// on the value of the [_calculateNumberOfMissingBars].
  EdgeInsets _calculateGraphPadding() {
    return _calculateNumberOfMissingBars() > 0
        ? const EdgeInsets.only(left: 2)
        : EdgeInsets.zero;
  }

  /// Returns a number of missing bars.
  int _calculateNumberOfMissingBars() {
    final numberOfBarsToDisplay = buildResultMetric.numberOfBuildsToDisplay;
    final numberOfBars = buildResultMetric.buildResults.length;

    return numberOfBarsToDisplay - numberOfBars;
  }
}
