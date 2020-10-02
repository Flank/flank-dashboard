import 'package:metrics/common/presentation/metrics_theme/model/build_result_bar/theme/style/build_result_bar_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/strategy/value_based_appearance_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the the strategy of applying the [MetricsThemeData]
/// to the [some widget] based on the [BuildStatus] value.
class BuildResultBarStyleStrategy
    implements ValueBasedAppearanceStrategy<BuildResultBarStyle, BuildStatus> {
  /// Creates a new instance of the [BuildResultBarStyleStrategy].
  const BuildResultBarStyleStrategy();

  @override
  BuildResultBarStyle getWidgetAppearance(
      MetricsThemeData themeData, BuildStatus status) {
    final buildResultTheme = themeData.buildResultBarTheme;
    final attentionLevel = buildResultTheme.attentionLevel;

    switch (status) {
      case BuildStatus.successful:
        return attentionLevel.successful;
      case BuildStatus.cancelled:
        return attentionLevel.cancelled;
      case BuildStatus.failed:
        return attentionLevel.failed;
      default:
        return null;
    }
  }
}
