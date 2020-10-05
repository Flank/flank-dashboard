import 'package:metrics/common/presentation/graph_indicator/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/attention_level_theme_data.dart';

/// The class that stores the theme data for application circle graph indicators.
class GraphIndicatorThemeData
    extends AttentionLevelThemeData<GraphIndicatorAttentionLevel> {
  /// Creates a new instance of the [GraphIndicatorThemeData].
  ///
  /// An empty [GraphIndicatorAttentionLevel] instance is used
  /// if the [attentionLevel] is null.
  const GraphIndicatorThemeData({GraphIndicatorAttentionLevel attentionLevel})
      : super(
          attentionLevel ?? const GraphIndicatorAttentionLevel(),
        );
}
