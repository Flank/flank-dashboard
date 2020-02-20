import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/presentation/model/build_result_bar_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/colored_bar.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';
import 'package:url_launcher/url_launcher.dart';

/// [BarGraph] that represents the build result metric.
class BuildResultBarGraph extends StatelessWidget {
  static const _barWidth = 8.0;

  final List<BuildResultBarData> data;
  final String title;
  final TextStyle titleStyle;

  /// Creates the [BuildResultBarGraph] based [data] with the [title].
  ///
  /// The [title] and [data] should not be null.
  /// [titleStyle] the [TextStyle] of the [title] text.
  const BuildResultBarGraph({
    Key key,
    @required this.title,
    @required this.data,
    this.titleStyle,
  })  : assert(title != null),
        assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetThemeData = MetricsTheme.of(context).buildResultTheme;
    final missingBarsCount =
        GetBuildMetrics.maxNumberOfBuildResults - data.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ExpandableText(
              title,
              style: titleStyle,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: missingBarsCount,
                  child: Row(
                    children: List.generate(
                      missingBarsCount,
                      (index) => const Expanded(
                        child: PlaceholderBar._(
                          width: _barWidth,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: data.length,
                  child: BarGraph(
                    data: data,
                    graphPadding: EdgeInsets.zero,
                    onBarTap: _onBarTap,
                    barBuilder: (BuildResultBarData data) {
                      return Align(
                        alignment: Alignment.center,
                        child: ColoredBar(
                          width: _barWidth,
                          color: _getBuildResultColor(
                              data.result, widgetThemeData),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Selects the color based on [result].
  Color _getBuildResultColor(
    BuildResult result,
    BuildResultsThemeData themeData,
  ) {
    switch (result) {
      case BuildResult.successful:
        return themeData.successfulColor;
      case BuildResult.canceled:
        return themeData.canceledColor;
      case BuildResult.failed:
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

/// Represents the placeholder bar.
///
/// Used to fill empty space in [BuildResultBarGraph].
class PlaceholderBar extends StatelessWidget {
  final double width;

  const PlaceholderBar._({
    Key key,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 6.0,
      child: ColoredBar(
        color: Colors.transparent,
        width: width,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
    );
  }
}
