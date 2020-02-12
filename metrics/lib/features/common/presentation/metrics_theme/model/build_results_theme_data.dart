import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';

/// Specifies the color theme of the [BuildResultBarGraph].
class BuildResultsThemeData {
  final Color successfulColor;
  final Color failedColor;
  final Color canceledColor;

  /// Creates the new instance of the [BuildResultsThemeData].
  ///
  /// [successfulColor] is the color of the successful build bar.
  /// [failedColor] is the color of the failed build bar.
  /// [canceledColor] is the color of the canceled build bar.
  const BuildResultsThemeData({
    this.successfulColor,
    this.failedColor,
    this.canceledColor,
  });

  /// Creates the default light color theme of the [BuildResultBarGraph].
  ///
  /// Used as the default value in [MetricsThemeData].
  const BuildResultsThemeData.light()
      : canceledColor = Colors.grey,
        successfulColor = Colors.teal,
        failedColor = Colors.redAccent;

  /// Creates the default dark color theme of the [BuildResultBarGraph]
  const BuildResultsThemeData.dark()
      : canceledColor = Colors.orange,
        successfulColor = Colors.teal,
        failedColor = Colors.red;
}
