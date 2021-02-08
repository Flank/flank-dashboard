// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/common/presentation/metrics_theme/model/attention_level_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/attention_level/project_build_status_attention_level.dart';

/// An [AttentionLevelThemeData] for the project build status widget.
@immutable
class ProjectBuildStatusThemeData
    extends AttentionLevelThemeData<ProjectBuildStatusAttentionLevel> {
  /// Creates the [ProjectBuildStatusThemeData] with the given [attentionLevel].
  ///
  /// If the [attentionLevel] is null, the [ProjectBuildStatusAttentionLevel] used.
  const ProjectBuildStatusThemeData({
    ProjectBuildStatusAttentionLevel attentionLevel,
  }) : super(attentionLevel ?? const ProjectBuildStatusAttentionLevel());
}
