import 'package:metrics/common/presentation/metrics_theme/model/attention_level_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/attention_level/circle_percentage_attention_level.dart';

/// The class that stores theme data for a circle percentage.
class CirclePercentageThemeData
    extends AttentionLevelThemeData<CirclePercentageAttentionLevel> {
  /// Creates a new instance of the [CirclePercentageThemeData].
  ///
  /// If the [attentionLevel] is null, an empty [CirclePercentageAttentionLevel]
  /// instance is used.
  const CirclePercentageThemeData({CirclePercentageAttentionLevel attentionLevel})
      : super(attentionLevel ?? const CirclePercentageAttentionLevel());
}
