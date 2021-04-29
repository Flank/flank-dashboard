// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/common/presentation/asset/strategy/value_based_asset_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a [ValueBasedAssetStrategy] of applying
/// the asset based on the [BuildStatus] value and [isDarkMode].
class ProjectBuildStatusAssetStrategy
    implements ValueBasedAssetStrategy<BuildStatus> {
  /// A flag that indicates whether the current theme mode is dark.
  final bool isDarkMode;

  /// Creates a new instance of the [ProjectBuildStatusAssetStrategy] with the
  /// given parameters.
  ///
  /// Throws an [AssertionError] if the given [isDarkMode] is `null`.
  const ProjectBuildStatusAssetStrategy({
    @required this.isDarkMode,
  }) : assert(isDarkMode != null);

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
        return _getInProgressAsset();
    }

    return null;
  }

  /// Returns an asset to display for the [BuildStatus.inProgress] based on the
  /// [isDarkMode] value.
  String _getInProgressAsset() {
    final suffix = isDarkMode ? 'dark' : 'light';

    return 'web/animation/in_progress_project_build_status_$suffix.riv';
  }
}
