// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/util/date.dart';

/// A widget that displays the date range of builds, missing bars,
/// and [BuildResultBarGraph].
class BuildResultsMetricGraph extends StatelessWidget {
  /// A [BuildResultMetricViewModel] with the build results data to display.
  final BuildResultMetricViewModel buildResultMetric;

  /// Creates a new instance of the [BuildResultsMetricGraph] with the given
  /// [buildResultMetric].
  ///
  /// The [buildResultMetric] is a required parameter.
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

    final numberOfBars = buildResultMetric.numberOfBuildsToDisplay;

    final barData = _calculateBarData(numberOfBars);
    final numberOfMissingBars = numberOfBars - barData.length;
    final dateRange = _buildResultDateRange(barData);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [],
    );
  }

  /// Returns a [String] containing the formatted date range between the first
  /// and the last build from the given [builds].
  ///
  /// Returns the formatted first build's date, if it equals to the last build's
  /// date.
  String _buildResultDateRange(List<BuildResultViewModel> builds) {
    final dateFormat = DateFormat('d MMM');

    final firstDate = builds.first.date;
    final lastDate = builds.last.date;

    final firstDateFormatted = dateFormat.format(firstDate);
    final lastDateFormatted = dateFormat.format(lastDate);

    if (firstDate.date == lastDate.date) {
      return firstDateFormatted;
    }

    return '$firstDateFormatted - $lastDateFormatted';
  }

  /// Returns a [List] of [BuildResultViewModel]s to display
  /// on a [BuildResultBarGraph].
  ///
  /// Trims the [buildResultMetric.buildResults] to match
  /// the given [numberOfBars].
  List<BuildResultViewModel> _calculateBarData(int numberOfBars) {
    final buildResults = buildResultMetric.buildResults;
    final buildResultsCount = buildResults.length;

    final firstBuildIndex = buildResultsCount < numberOfBars
        ? 0
        : (buildResultsCount - numberOfBars);

    return buildResults.sublist(firstBuildIndex);
  }
}
