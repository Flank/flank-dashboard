import 'package:metrics/common/presentation/circle_graph_indicator/attention_level/metrics_circle_graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/attention_level_theme_data.dart';

/// The class that stores the theme data for application circle graph indicators.
class MetricsCircleGraphIndicatorThemeData
    extends AttentionLevelThemeData<MetricsCircleGraphIndicatorAttentionLevel> {
  /// Creates a new instance of the [MetricsCircleGraphIndicatorThemeData].
  ///
  /// An empty [MetricsCircleGraphIndicatorAttentionLevel] instance is used
  /// if the [attentionLevel] is null.
  const MetricsCircleGraphIndicatorThemeData({
    MetricsCircleGraphIndicatorAttentionLevel attentionLevel,
  }) : super(
          attentionLevel ?? const MetricsCircleGraphIndicatorAttentionLevel(),
        );
}
