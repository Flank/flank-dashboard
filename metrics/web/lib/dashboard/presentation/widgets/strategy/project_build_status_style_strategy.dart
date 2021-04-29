// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/strategy/value_based_appearance_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [ValueBasedAppearanceStrategy] of applying
/// the [MetricsThemeData] based on the [BuildStatus] value.
class ProjectBuildStatusStyleStrategy
    implements
        ValueBasedAppearanceStrategy<ProjectBuildStatusStyle, BuildStatus> {
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
      case BuildStatus.inProgress:
        return attentionLevelTheme.inactive;
    }

    return null;
  }
}
