// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/value_image/strategy/value_based_image_asset_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [ValueBasedImageAssetStrategy] of applying
/// the image based on the [BuildStatus] value.
class BuildResultPopupImageStrategy
    implements ValueBasedImageAssetStrategy<BuildStatus> {
  /// Creates a new instance of the [BuildResultPopupImageStrategy].
  const BuildResultPopupImageStrategy();

  @override
  String getImageAsset(BuildStatus value) {
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
