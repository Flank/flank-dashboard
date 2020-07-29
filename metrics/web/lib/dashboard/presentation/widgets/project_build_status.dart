import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that displays an image representation of the project build status.
class ProjectBuildStatus extends StatelessWidget {
  /// A [ProjectBuildStatusViewModel] that represents a status of the build
  /// to display.
  final ProjectBuildStatusViewModel buildStatus;

  /// Creates an instance of the [ProjectBuildStatus]
  /// with the given [buildStatus].
  const ProjectBuildStatus({
    Key key,
    this.buildStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        shape: BoxShape.circle,
      ),
      child: Image.network(_getIconImage()),
    );
  }

  /// Returns the background [Color] based on the [buildStatus] value.
  Color _getBackgroundColor() {
    switch (buildStatus.value) {
      case BuildStatus.successful:
        return ColorConfig.primaryTranslucentColor;
      case BuildStatus.cancelled:
      case BuildStatus.failed:
        return ColorConfig.accentTranslucentColor;
      default:
        return ColorConfig.inactiveColor;
    }
  }

  /// Returns the icon image path, based on the [buildStatus] value.
  String _getIconImage() {
    switch (buildStatus.value) {
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
