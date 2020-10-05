import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/attention_level_theme_data.dart';

/// A class that stores the theme data for the application graph indicators.
class GraphIndicatorThemeData
    extends AttentionLevelThemeData<GraphIndicatorAttentionLevel> {
  /// Creates a new instance of the [GraphIndicatorThemeData].
  ///
  /// If the [attentionLevel] is null, an empty
  /// [GraphIndicatorAttentionLevel] instance is used.
  const GraphIndicatorThemeData({
    GraphIndicatorAttentionLevel attentionLevel,
  }) : super(attentionLevel ?? const GraphIndicatorAttentionLevel());
}
