import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_result_bar/theme/style/build_result_bar_style.dart';

/// A class that holds the different style configurations for
/// the build result bar widgets.
@immutable
class BuildResultBarAttentionLevel {
  /// A [BuildResultBarStyle] for a build result bar widget
  /// that provide colors for the successful builds.
  final BuildResultBarStyle successful;

  /// A [BuildResultBarStyle] for a build result bar widget
  /// that provide colors for the cancelled builds.
  final BuildResultBarStyle cancelled;

  /// A [BuildResultBarStyle] for a build result bar widget
  /// that provide colors for the failed builds.
  final BuildResultBarStyle failed;

  /// Creates a new instance of the [BuildResultBarAttentionLevel].
  ///
  /// If the [successful], [cancelled] or [failed] is null,
  /// an empty [BuildResultBarStyle] used.
  const BuildResultBarAttentionLevel({
    BuildResultBarStyle successful,
    BuildResultBarStyle cancelled,
    BuildResultBarStyle failed,
  })  : successful = successful ?? const BuildResultBarStyle(),
        cancelled = cancelled ?? const BuildResultBarStyle(),
        failed = failed ?? const BuildResultBarStyle();
}
