import 'package:metrics/common/presentation/metrics_theme/model/attention_level_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_result_bar/theme/attention_level/build_result_bar_attention_level.dart';

/// A class that stores the theme data for the application build result bars.
class BuildResultBarThemeData
    extends AttentionLevelThemeData<BuildResultBarAttentionLevel> {
  /// Creates a new instance of the [BuildResultBarThemeData].
  ///
  /// If the [attentionLevel] is null, an empty
  /// [BuildResultBarAttentionLevel] instance is used.
  const BuildResultBarThemeData({
    BuildResultBarAttentionLevel attentionLevel,
  }) : super(attentionLevel ?? const BuildResultBarAttentionLevel());
}
