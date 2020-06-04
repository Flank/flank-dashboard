import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/graphs/bar_graph.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/common/presentation/graphs/placeholder_bar.dart';

/// [BarGraph] that represents the build result metric.
///
/// Applies the color theme from the [MetricsThemeData.buildResultTheme].
class BuildResultBarGraph extends StatefulWidget {
  final BuildResultMetricViewModel data;

  /// Creates the [BuildResultBarGraph] based on the given [data].
  ///
  /// The [data] must not be null.
  /// If the [data.buildResults] length will be greater than [data.numberOfBuildsToDisplay],
  /// the last [data.numberOfBuildsToDisplay] of the [data.buildResults] is displayed.
  /// If there are not enough [data.buildResults] to display [data.numberOfBuildsToDisplay] bars,
  /// the [PlaceholderBar]s are added to match the requested [data.numberOfBuildsToDisplay].
  const BuildResultBarGraph({
    Key key,
    @required this.data,
  })  : assert(data != null),
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
    if (oldWidget.data.numberOfBuildsToDisplay !=
            widget.data.numberOfBuildsToDisplay ||
        oldWidget.data != widget.data) {
      _calculateBarData();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: _missingBarsCount,
            child: Row(
              children: List.generate(
                _missingBarsCount,
                (index) => const Expanded(
                  child: BuildResultBar(),
                ),
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

                return Align(
                  alignment: Alignment.center,
                  child: BuildResultBar(
                    buildResult: data,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Calculates [_missingBarsCount] and trims the data to match the numberOfBars.
  void _calculateBarData() {
    final numberOfBars = widget.data.numberOfBuildsToDisplay;
    _barsData = widget.data.buildResults;

    if (numberOfBars == null) return;

    if (_barsData.length > numberOfBars) {
      _barsData = _barsData.sublist(_barsData.length - numberOfBars);
    } else {
      _missingBarsCount = numberOfBars - _barsData.length;
    }
  }
}
