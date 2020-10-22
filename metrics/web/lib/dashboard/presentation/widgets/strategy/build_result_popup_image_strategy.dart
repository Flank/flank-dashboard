import 'package:metrics/common/presentation/value_image/strategy/value_based_image_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [ValueBasedImageStrategy] of applying
/// the image based on the [BuildStatus] value.
class BuildResultPopupImageStrategy
    implements ValueBasedImageStrategy<BuildStatus> {
  /// Creates a new instance of the [BuildResultPopupImageStrategy].
  const BuildResultPopupImageStrategy();

  @override
  String getIconImage(BuildStatus value) {
    switch (value) {
      case BuildStatus.successful:
        return "icons/successful.svg";
      case BuildStatus.failed:
        return "icons/failed.svg";
      case BuildStatus.unknown:
        return "icons/unknown.svg";
    }

    return null;
  }
}
