import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/no_data_placeholder.dart';
import 'package:metrics/base/presentation/widgets/scorecard.dart';

/// Widget that displays the [Scorecard] with the build number metrics.
///
/// Applies the text styles from the [MetricsThemeData.metricsWidgetTheme].
/// If the [buildNumberMetrics] is either `null` or equal to 0, displays the [NoDataPlaceholder].
class BuildNumberScorecard extends StatelessWidget {
  /// The [BuildNumberMetricsViewModel] with data to display.
  final BuildNumberScorecardViewModel buildNumberMetrics;

  /// Creates the [BuildNumberScorecard] with the given [buildNumberMetrics].
  const BuildNumberScorecard({
    Key key,
    this.buildNumberMetrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetTheme = MetricsTheme.of(context).buildNumberScorecardTheme;

    if (buildNumberMetrics?.numberOfBuilds == null ||
        buildNumberMetrics?.numberOfBuilds == 0) {
      return const NoDataPlaceholder();
    }

    return Scorecard(
      value: '${buildNumberMetrics.numberOfBuilds}',
      valueStyle: widgetTheme.valueTextStyle,
      description: DashboardStrings.perWeek,
      descriptionStyle: widgetTheme.descriptionTextStyle,
    );
  }
}
