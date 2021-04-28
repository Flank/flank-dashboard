// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/asset/strategy/value_based_asset_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a [ValueBasedAssetStrategy] of applying
/// the asset based on the [BuildStatus] value.
class ProjectBuildStatusAssetStrategy
    implements ValueBasedAssetStrategy<BuildStatus> {
  /// Creates a new instance of the [ProjectBuildStatusAssetStrategy].
  const ProjectBuildStatusAssetStrategy();

  @override
  String getAsset(BuildStatus value) {
    switch (value) {
      case BuildStatus.successful:
        return "icons/successful_status.svg";
      case BuildStatus.failed:
        return "icons/failed_status.svg";
      case BuildStatus.unknown:
        return "icons/unknown_status.svg";
      case BuildStatus.inProgress:
        return "icons/in_progress_status.svg";
    }

    return null;
  }
}
