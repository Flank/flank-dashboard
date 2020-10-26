import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';

/// A [BarGraph] that displays the build result metric.
///
/// Applies the color theme from the [MetricsThemeData.buildResultTheme].
class BuildResultBarGraph extends StatefulWidget {
  /// A [BuildResultMetricViewModel] with data to display.
  final BuildResultMetricViewModel buildResultMetric;

  /// Creates the [BuildResultBarGraph] based on the given [buildResultMetric].
  ///
  /// The [buildResultMetric] must not be null.
  /// If the [BuildResultMetricViewModel.buildResults] length is greater
  /// than [BuildResultMetricViewModel.numberOfBuildsToDisplay],
  /// the last [BuildResultMetricViewModel.numberOfBuildsToDisplay] of the
  /// [BuildResultMetricViewModel.buildResults] is displayed.
  /// If there are not enough [BuildResultMetricViewModel.buildResults]
  /// to display [BuildResultMetricViewModel.numberOfBuildsToDisplay] bars,
  /// the [PlaceholderBar]s are added to match the requested
  /// [BuildResultMetricViewModel.numberOfBuildsToDisplay].
  const BuildResultBarGraph({
    Key key,
    @required this.buildResultMetric,
  })  : assert(buildResultMetric != null),
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
    if (oldWidget.buildResultMetric.numberOfBuildsToDisplay !=
            widget.buildResultMetric.numberOfBuildsToDisplay ||
        oldWidget.buildResultMetric != widget.buildResultMetric) {
      _calculateBarData();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final graphPadding = _missingBarsCount != 0 && _barsData.isNotEmpty
        ? const EdgeInsets.only(left: 4.0)
        : EdgeInsets.zero;

    final barStrategy = BuildResultBarPaddingStrategy(
      buildResults: _barsData,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _missingBarsCount,
              (index) => const BuildResultBar(),
            ),
          ),
        ),
        BarGraph(
          graphPadding: graphPadding,
          data: _barsData.map((data) {
            return data.duration.inMilliseconds;
          }).toList(),
          barBuilder: (index, height) {
            final data = _barsData[index];

            return Container(
              constraints: BoxConstraints(
                minHeight: height,
              ),
              child: BuildResultBar(
                strategy: barStrategy,
                buildResult: data,
              ),
            );
          },
        ),
      ],
    );
  }

  /// Calculates [_missingBarsCount] and trims the data to match
  /// the given [BuildResultMetricViewModel.numberOfBuildsToDisplay].
  void _calculateBarData() {
    final numberOfBars = widget.buildResultMetric.numberOfBuildsToDisplay;
    _barsData = widget.buildResultMetric.buildResults;

    if (numberOfBars == null) return;

    if (_barsData.length > numberOfBars) {
      _barsData = _barsData.sublist(_barsData.length - numberOfBars);
    } else {
      _missingBarsCount = numberOfBars - _barsData.length;
    }
  }
}
