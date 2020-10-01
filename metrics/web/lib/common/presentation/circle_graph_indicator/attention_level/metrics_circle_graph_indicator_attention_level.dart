import 'package:metrics/common/presentation/circle_graph_indicator/style/metrics_circle_graph_indicator_style.dart';

/// A class that stores [MetricsCircleGraphIndicatorStyle]s for different
/// visual feedback levels for circle graph indicators within application.
class MetricsCircleGraphIndicatorAttentionLevel {
  /// A [MetricsCircleGraphIndicatorStyle] for circle graph indicators
  /// that provide colors for the successful builds.
  final MetricsCircleGraphIndicatorStyle successful;

  /// A [MetricsCircleGraphIndicatorStyle] for circle graph indicators
  /// that provide colors for the failed builds.
  final MetricsCircleGraphIndicatorStyle failed;

  /// A [MetricsCircleGraphIndicatorStyle] for circle graph indicators
  /// that provide colors for the cancelled builds.
  final MetricsCircleGraphIndicatorStyle cancelled;

  /// Creates a new instance of [MetricsButtonAttentionLevel].
  ///
  /// All the parameters default to [MetricsCircleGraphIndicatorStyle]
  /// default instance.
  const MetricsCircleGraphIndicatorAttentionLevel({
    this.successful = const MetricsCircleGraphIndicatorStyle(),
    this.failed = const MetricsCircleGraphIndicatorStyle(),
    this.cancelled = const MetricsCircleGraphIndicatorStyle(),
  });
}
