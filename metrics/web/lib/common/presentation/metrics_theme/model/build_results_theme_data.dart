import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';

/// Specifies the color theme of the [BuildResultBarGraph].
class BuildResultsThemeData {
  /// A [Color] of the successful build bar.
  final Color successfulColor;

  /// A background [Color] of the successful build bar.
  final Color successfulBackgroundColor;

  /// A [Color] of the failed build bar.
  final Color failedColor;

  /// A background [Color] of the failed build bar.
  final Color failedBackgroundColor;

  /// A [Color] of the canceled build bar.
  final Color canceledColor;

  /// A background [Color] of the canceled build bar.
  final Color canceledBackgroundColor;

  /// A [TextStyle] of the bar graph title.
  final TextStyle titleStyle;

  /// Creates the new instance of the [BuildResultsThemeData].
  const BuildResultsThemeData({
    this.successfulBackgroundColor,
    this.failedBackgroundColor,
    this.canceledBackgroundColor,
    this.successfulColor,
    this.failedColor,
    this.canceledColor,
    this.titleStyle,
  });
}
