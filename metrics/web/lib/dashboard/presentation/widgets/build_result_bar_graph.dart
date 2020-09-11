import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metrics_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';

/// A [BarGraph] that displays the build result metrics.
///
/// Applies the color theme from the [MetricsThemeData.buildResultTheme].
class BuildResultBarGraph extends StatefulWidget {
  /// A [BuildResultMetricsViewModel] with data to display.
  final BuildResultMetricsViewModel buildResultMetrics;

  /// Creates the [BuildResultBarGraph] based on the given [buildResultMetrics].
  ///
  /// The [buildResultMetrics] must not be null.
  /// If the [BuildResultMetricsViewModel.buildResults] length is greater
  /// than [BuildResultMetricsViewModel.numberOfBuildsToDisplay],
  /// the last [BuildResultMetricsViewModel.numberOfBuildsToDisplay] of the
  /// [BuildResultMetricsViewModel.buildResults] is displayed.
  /// If there are not enough [BuildResultMetricsViewModel.buildResults]
  /// to display [BuildResultMetricsViewModel.numberOfBuildsToDisplay] bars,
  /// the [PlaceholderBar]s are added to match the requested
  /// [BuildResultMetricsViewModel.numberOfBuildsToDisplay].
  const BuildResultBarGraph({
    Key key,
    @required this.buildResultMetrics,
  })  : assert(buildResultMetrics != null),
        super(key: key);

  @override
  _BuildResultBarGraphState createState() => _BuildResultBarGraphState();
}

class _BuildResultBarGraphState extends State<BuildResultBarGraph> {
  List<BuildResultViewModel> _barsData;
  int _missingBarsCount = 0;

  @override
  void initState() {
    _calculateBarData();
    super.initState();
  }

  @override
  void didUpdateWidget(BuildResultBarGraph oldWidget) {
    if (oldWidget.buildResultMetrics.numberOfBuildsToDisplay !=
            widget.buildResultMetrics.numberOfBuildsToDisplay ||
        oldWidget.buildResultMetrics != widget.buildResultMetrics) {
      _calculateBarData();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: _missingBarsCount,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _missingBarsCount,
              (index) => const BuildResultBar(),
            ),
          ),
        ),
        Expanded(
          flex: _barsData.length,
          child: BarGraph(
            data: _barsData.map((data) => data.value).toList(),
            graphPadding: EdgeInsets.zero,
            barBuilder: (int index) {
              final data = _barsData[index];

              return BuildResultBar(
                buildResult: data,
              );
            },
          ),
        ),
      ],
    );
  }

  /// Calculates [_missingBarsCount] and trims the data to match
  /// the given [BuildResultMetricsViewModel.numberOfBuildsToDisplay].
  void _calculateBarData() {
    final numberOfBars = widget.buildResultMetrics.numberOfBuildsToDisplay;
    _barsData = widget.buildResultMetrics.buildResults;

    if (numberOfBars == null) return;

    if (_barsData.length > numberOfBars) {
      _barsData = _barsData.sublist(_barsData.length - numberOfBars);
    } else {
      _missingBarsCount = numberOfBars - _barsData.length;
    }
  }
}
