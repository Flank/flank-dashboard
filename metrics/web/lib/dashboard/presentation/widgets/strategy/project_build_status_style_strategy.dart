import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_status_style_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [BuildStatusStyleStrategy] of applying the [MetricsThemeData]
/// based on the [BuildStatus] value.
class ProjectBuildStatusStyleStrategy implements BuildStatusStyleStrategy {
  /// Creates a new instance of the [ProjectBuildStatusStyleStrategy].
  const ProjectBuildStatusStyleStrategy();

  @override
  ProjectBuildStatusStyle getWidgetAppearance(
    MetricsThemeData themeData,
    BuildStatus value,
  ) {
    final attentionLevelTheme =
        themeData.projectBuildStatusTheme.attentionLevel;

    switch (value) {
      case BuildStatus.successful:
        return attentionLevelTheme.positive;
      case BuildStatus.failed:
        return attentionLevelTheme.negative;
      case BuildStatus.unknown:
        return attentionLevelTheme.unknown;
    }

    return null;
  }

  @override
  String getIconImage(BuildStatus value) {
    switch (value) {
      case BuildStatus.successful:
        return "icons/successful_status.svg";
      case BuildStatus.failed:
        return "icons/failed_status.svg";
      case BuildStatus.unknown:
        return "icons/unknown_status.svg";
    }

    return null;
  }
}

