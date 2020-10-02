import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_result_bar/theme/style/build_result_bar_style.dart';

/// A class that holds the different style configurations for
/// the build result bar widgets.
@immutable
class BuildResultBarAttentionLevel {
  /// A [BuildResultBarStyle] for a build result bar widget
  /// displaying the positive visual feedback.
  final BuildResultBarStyle successful;
  final BuildResultBarStyle cancelled;
  final BuildResultBarStyle failed;

  const BuildResultBarAttentionLevel({
    BuildResultBarStyle successful,
    BuildResultBarStyle cancelled,
    BuildResultBarStyle failed,
  })  : successful = successful ?? const BuildResultBarStyle(),
        cancelled = cancelled ?? const BuildResultBarStyle(),
        failed = failed ?? const BuildResultBarStyle();
}
