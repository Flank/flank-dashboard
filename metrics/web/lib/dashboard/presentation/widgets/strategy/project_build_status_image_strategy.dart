// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/value_image/strategy/value_based_image_asset_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [ValueBasedImageAssetStrategy] of applying
/// the image asset based on the [BuildStatus] value.
class ProjectBuildStatusImageStrategy
    implements ValueBasedImageAssetStrategy<BuildStatus> {
  /// Creates a new instance of the [ProjectBuildStatusImageStrategy].
  const ProjectBuildStatusImageStrategy();

  @override
  String getImageAsset(BuildStatus value) {
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
