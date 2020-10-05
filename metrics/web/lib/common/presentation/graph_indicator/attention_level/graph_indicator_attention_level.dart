import 'package:metrics/common/presentation/graph_indicator/style/graph_indicator_style.dart';

/// A class that stores [GraphIndicatorStyle]s for different
/// visual feedback levels for circle graph indicators within application.
class GraphIndicatorAttentionLevel {
  /// A [GraphIndicatorStyle] for circle graph indicators
  /// that provide colors for the successful builds.
  final GraphIndicatorStyle successful;

  /// A [GraphIndicatorStyle] for circle graph indicators
  /// that provide colors for the failed builds.
  final GraphIndicatorStyle failed;

  /// A [GraphIndicatorStyle] for circle graph indicators
  /// that provide colors for the cancelled builds.
  final GraphIndicatorStyle cancelled;

  /// Creates a new instance of [MetricsButtonAttentionLevel].
  ///
  /// All the parameters default to [GraphIndicatorStyle]
  /// default instance.
  const GraphIndicatorAttentionLevel({
    this.successful = const GraphIndicatorStyle(),
    this.failed = const GraphIndicatorStyle(),
    this.cancelled = const GraphIndicatorStyle(),
  });
}
