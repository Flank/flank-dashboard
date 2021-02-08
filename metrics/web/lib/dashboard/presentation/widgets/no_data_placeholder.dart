// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';

/// A widget that displays a [DashboardStrings.noDataPlaceholder] text in a center.
///
/// Applies the [TextStyle] from the [MetricsThemeData.inactiveWidgetTheme].
class NoDataPlaceholder extends StatelessWidget {
  /// Creates a new instance of the [NoDataPlaceholder].
  const NoDataPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inactiveTheme = MetricsTheme.of(context).inactiveWidgetTheme;

    return Center(
      child: Text(
        DashboardStrings.noDataPlaceholder,
        style: inactiveTheme.textStyle,
      ),
    );
  }
}
