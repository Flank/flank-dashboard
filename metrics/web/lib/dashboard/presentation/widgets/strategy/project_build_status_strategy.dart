import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the strategy of applying the [MetricsThemeData]
/// based on the [BuildStatus] value.
class ProjectBuildStatusStrategy {
  /// Creates a new instance of the [ProjectBuildStatusStrategy].
  const ProjectBuildStatusStrategy();

  /// Returns the [ProjectBuildStatusStyle] based on the [BuildStatus] value.
  ProjectBuildStatusStyle getWidgetStyle(
    MetricsThemeData themeData,
    BuildStatus value,
  ) {
    final attentionLevelTheme =
        themeData.projectBuildStatusTheme.attentionLevel;

    switch (value) {
      case BuildStatus.successful:
        return attentionLevelTheme.successful;
      case BuildStatus.cancelled:
        return attentionLevelTheme.failed;
      case BuildStatus.failed:
        return attentionLevelTheme.failed;
      default:
        return attentionLevelTheme.unknown;
    }
  }

  /// Returns the icon image, based on the [BuildStatus] value.
  String getIconImage(BuildStatus value) {
    switch (value) {
      case BuildStatus.successful:
        return "icons/successful_status.svg";
      case BuildStatus.cancelled:
      case BuildStatus.failed:
        return "icons/failed_status.svg";
      default:
        return "icons/unknown_status.svg";
    }
  }
}
