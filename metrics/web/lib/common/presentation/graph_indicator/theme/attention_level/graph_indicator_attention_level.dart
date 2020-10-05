import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';

/// A class that stores [GraphIndicatorStyle]s for different
/// visual feedback levels for graph indicators within application.
class GraphIndicatorAttentionLevel {
  /// A [GraphIndicatorStyle] for graph indicators
  /// that provides colors for successful builds.
  final GraphIndicatorStyle successful;

  /// A [GraphIndicatorStyle] for graph indicators
  /// that provides colors for failed builds.
  final GraphIndicatorStyle failed;

  /// A [GraphIndicatorStyle] for graph indicators
  /// that provides colors for cancelled builds.
  final GraphIndicatorStyle cancelled;

  /// Creates a new instance of the [MetricsButtonAttentionLevel].
  ///
  /// If the given parameters are `null`, an empty instance of
  /// the [GraphIndicatorStyle] is used.
  const GraphIndicatorAttentionLevel({
    GraphIndicatorStyle successful,
    GraphIndicatorStyle failed,
    GraphIndicatorStyle cancelled,
  })  : successful = successful ?? const GraphIndicatorStyle(),
        failed = failed ?? const GraphIndicatorStyle(),
        cancelled = cancelled ?? const GraphIndicatorStyle();
}
