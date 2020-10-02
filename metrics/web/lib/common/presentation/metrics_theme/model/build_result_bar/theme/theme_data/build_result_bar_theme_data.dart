import 'package:metrics/common/presentation/metrics_theme/model/attention_level_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_result_bar/theme/attention_level/build_result_bar_attention_level.dart';

class BuildResultBarThemeData
    extends AttentionLevelThemeData<BuildResultBarAttentionLevel> {
  const BuildResultBarThemeData({
    BuildResultBarAttentionLevel attentionLevel,
  }) : super(attentionLevel ?? const BuildResultBarAttentionLevel());
}
