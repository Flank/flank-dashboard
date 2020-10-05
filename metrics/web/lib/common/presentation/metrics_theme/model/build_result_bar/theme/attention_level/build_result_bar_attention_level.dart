import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';

/// A class that holds the different style configurations for
/// the build result bar widgets.
class BuildResultBarAttentionLevel {
  /// A [MetricsColoredBarStyle] for a build result bar widget
  /// that provides colors for successful builds.
  final MetricsColoredBarStyle successful;

  /// A [MetricsColoredBarStyle] for a build result bar widget
  /// that provides colors for cancelled builds.
  final MetricsColoredBarStyle cancelled;

  /// A [MetricsColoredBarStyle] for a build result bar widget
  /// that provides colors for failed builds.
  final MetricsColoredBarStyle failed;

  /// Creates a new instance of the [BuildResultBarAttentionLevel].
  ///
  /// If the [successful], [cancelled] or [failed] is `null`,
  /// an empty instance of the [MetricsColoredBarStyle] is used.
  const BuildResultBarAttentionLevel({
    MetricsColoredBarStyle successful,
    MetricsColoredBarStyle cancelled,
    MetricsColoredBarStyle failed,
  })  : successful = successful ?? const MetricsColoredBarStyle(),
        cancelled = cancelled ?? const MetricsColoredBarStyle(),
        failed = failed ?? const MetricsColoredBarStyle();
}
