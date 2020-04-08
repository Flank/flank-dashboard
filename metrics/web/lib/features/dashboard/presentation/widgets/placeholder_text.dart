import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';

/// A widget that displays centered text.
class PlaceholderText extends StatelessWidget {
  final String text;
  final TextStyle style;

  /// Creates the [PlaceholderText] with the given [text].
  ///
  /// [text] is the text to be displayed.
  /// If null - the [DashboardStrings.noDataPlaceholder] will be displayed.
  /// [style] is the [TextStyle] of the [text].
  /// If null - the text style from the [MetricsThemeData.inactiveWidgetTheme] will be used.
  const PlaceholderText({
    Key key,
    this.text,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inactiveTheme = MetricsTheme.of(context).inactiveWidgetTheme;

    return Center(
      child: Text(
        text ?? DashboardStrings.noDataPlaceholder,
        style: style ?? inactiveTheme.textStyle,
      ),
    );
  }
}
