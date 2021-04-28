// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/asset/strategy/value_based_asset_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [ValueBasedAssetStrategy] of applying
/// the assets based on the [BuildStatus] value.
class BuildResultPopupAssetStrategy
    implements ValueBasedAssetStrategy<BuildStatus> {
  /// Creates a new instance of the [BuildResultPopupAssetStrategy].
  const BuildResultPopupAssetStrategy();

  @override
  String getAsset(BuildStatus value) {
    switch (value) {
      case BuildStatus.successful:
        return "icons/successful.svg";
      case BuildStatus.failed:
        return "icons/failed.svg";
      case BuildStatus.unknown:
        return "icons/unknown.svg";
      case BuildStatus.inProgress:
        return "web/animation/in_progress_popup_build_status.riv";
    }

    return null;
  }
}
