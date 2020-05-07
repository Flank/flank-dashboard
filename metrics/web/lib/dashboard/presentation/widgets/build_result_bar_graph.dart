import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/model/build_result_bar_data.dart';
import 'package:metrics/dashboard/presentation/widgets/bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/colored_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/placeholder_bar.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:url_launcher/url_launcher.dart';

/// [BarGraph] that represents the build result metric.
///
/// Applies the color theme from the [MetricsThemeData.buildResultTheme].
class BuildResultBarGraph extends StatefulWidget {
  final List<BuildResultBarData> data;
  final int numberOfBars;

  /// Creates the [BuildResultBarGraph] based on the given [data].
  ///
  /// The [data] must not be null.
  /// [numberOfBars] is the number if the bars on graph.
  /// If the [data] length will be greater than [numberOfBars],
  /// the last [numberOfBars] of the [data] is displayed.
  /// If there are not enough [data] to display [numberOfBars] bars,
  /// the [PlaceholderBar]s are added to match the requested [numberOfBars].
  const BuildResultBarGraph({
    Key key,
    @required this.data,
    this.numberOfBars,
  })  : assert(data != null),
        super(key: key);

  @override
  _BuildResultBarGraphState createState() => _BuildResultBarGraphState();
}

class _BuildResultBarGraphState extends State<BuildResultBarGraph> {
  static const _barWidth = 4.0;
  static const _listEquality = ListEquality();
  List<BuildResultBarData> _barsData;
  int _missingBarsCount = 0;

  @override
  void initState() {
    _calculateBarData();
    super.initState();
  }

  @override
  void didUpdateWidget(BuildResultBarGraph oldWidget) {
    if (oldWidget.numberOfBars != widget.numberOfBars ||
        !_listEquality.equals(oldWidget.data, widget.data)) {
      _calculateBarData();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final widgetThemeData = MetricsTheme.of(context).buildResultTheme;

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
                  child: PlaceholderBar(
                    width: _barWidth,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: _barsData.length,
            child: BarGraph(
              data: _barsData,
              graphPadding: EdgeInsets.zero,
              onBarTap: _onBarTap,
              barBuilder: (BuildResultBarData data) {
                if (data.buildStatus == null) {
                  return const PlaceholderBar(
                    width: _barWidth,
                  );
                }

                return Align(
                  alignment: Alignment.center,
                  child: ColoredBar(
                    width: _barWidth,
                    color: _getBuildResultColor(
                      data.buildStatus,
                      widgetThemeData,
                    ),
                    borderRadius: BorderRadius.circular(1.0),
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
    final numberOfBars = widget.numberOfBars;
    _barsData = widget.data;

    if (numberOfBars == null) return;

    if (_barsData.length > numberOfBars) {
      _barsData = _barsData.sublist(_barsData.length - numberOfBars);
    } else {
      _missingBarsCount = numberOfBars - _barsData.length;
    }
  }

  /// Selects the color based on [buildStatus].
  Color _getBuildResultColor(
    BuildStatus buildStatus,
    BuildResultsThemeData themeData,
  ) {
    switch (buildStatus) {
      case BuildStatus.successful:
        return themeData.successfulColor;
      case BuildStatus.cancelled:
        return themeData.canceledColor;
      case BuildStatus.failed:
        return themeData.failedColor;
      default:
        return null;
    }
  }

  /// Opens the [BuildResultBarData] url.
  void _onBarTap(BuildResultBarData data) {
    launch(data.url);
  }
}
