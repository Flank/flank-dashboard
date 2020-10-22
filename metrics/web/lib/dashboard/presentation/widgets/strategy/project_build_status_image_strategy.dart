import 'package:metrics/common/presentation/value_image/strategy/value_based_image_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [ProjectBuildStatusImageStrategy] of applying
/// the image based on the [BuildStatus] value.
class ProjectBuildStatusImageStrategy
    implements ValueBasedImageStrategy<BuildStatus> {
  /// Creates a new instance of the [ProjectBuildStatusImageStrategy].
  const ProjectBuildStatusImageStrategy();

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
