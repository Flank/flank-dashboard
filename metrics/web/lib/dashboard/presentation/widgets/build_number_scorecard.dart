// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/scorecard.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/no_data_placeholder.dart';

/// Widget that displays the [Scorecard] with the build number metric.
///
/// Applies the text styles from the [MetricsThemeData.buildNumberScorecardTheme].
/// If the [buildNumberMetric] is either `null` or equal to 0, displays the [NoDataPlaceholder].
class BuildNumberScorecard extends StatelessWidget {
  /// The [BuildNumberScorecardViewModel] with data to display.
  final BuildNumberScorecardViewModel buildNumberMetric;

  /// Creates the [BuildNumberScorecard] with the given [buildNumberMetric].
  const BuildNumberScorecard({
    Key key,
    this.buildNumberMetric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetTheme = MetricsTheme.of(context).buildNumberScorecardTheme;

    if (buildNumberMetric?.numberOfBuilds == null ||
        buildNumberMetric?.numberOfBuilds == 0) {
      return const NoDataPlaceholder();
    }

    return Scorecard(
      value: '${buildNumberMetric.numberOfBuilds}',
      valueStyle: widgetTheme.valueTextStyle,
      description: DashboardStrings.perWeek,
      descriptionStyle: widgetTheme.descriptionTextStyle,
    );
  }
}
