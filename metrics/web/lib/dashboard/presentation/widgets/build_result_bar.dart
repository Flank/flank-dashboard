import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:url_launcher/url_launcher.dart';

/// A single bar for a [BarGraph] widget that displays the
/// result of a [BuildResultViewModel] instance.
///
/// Displays the [PlaceholderBar] if either [buildResult] or
/// [BuildResultViewModel.buildStatus] is `null`.
class BuildResultBar extends StatelessWidget {
  /// A width of this bar.
  static const double _barWidth = 10.0;

  /// A border radius of this bar.
  static const _borderRadius = Radius.circular(1.0);

  /// A [BuildResultViewModel] to display.
  final BuildResultViewModel buildResult;

  /// Creates the [BuildResultBar] with the given [buildResult].
  const BuildResultBar({
    Key key,
    this.buildResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final metricsTheme = MetricsTheme.of(context);
    final widgetThemeData = metricsTheme.buildResultTheme;

    if (buildResult == null || buildResult.buildStatus == null) {
      final inactiveTheme = metricsTheme.inactiveWidgetTheme;
      return PlaceholderBar(
        width: _barWidth,
        height: 4.0,
        color: inactiveTheme.primaryColor,
      );
    }

    return HandCursor(
      child: GestureDetector(
        onTap: _onBarTap,
        child: ColoredBar(
          width: _barWidth,
          borderRadius: const BorderRadius.only(
            topLeft: _borderRadius,
            topRight: _borderRadius,
          ),
          color: _getBuildResultColor(
            buildResult.buildStatus,
            widgetThemeData,
          ),
        ),
      ),
    );
  }

  /// Selects the color from the [widgetTheme] based on [buildStatus].
  Color _getBuildResultColor(
    BuildStatus buildStatus,
    BuildResultsThemeData widgetTheme,
  ) {
    switch (buildStatus) {
      case BuildStatus.successful:
        return widgetTheme.successfulColor;
      case BuildStatus.cancelled:
        return widgetTheme.canceledColor;
      case BuildStatus.failed:
        return widgetTheme.failedColor;
      default:
        return null;
    }
  }

  /// Opens the [BuildResultViewModel.url].
  Future<void> _onBarTap() async {
    final url = buildResult.url;
    if (url == null) return;

    final canLaunchUrl = await canLaunch(url);

    if (canLaunchUrl) {
      await launch(url);
    }
  }
}
