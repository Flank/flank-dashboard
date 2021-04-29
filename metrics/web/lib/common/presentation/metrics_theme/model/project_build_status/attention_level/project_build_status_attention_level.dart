// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';

/// A class that holds the different style configurations for
/// the project build status widget.
@immutable
class ProjectBuildStatusAttentionLevel {
  /// A default [ProjectBuildStatusStyle] used if any of given statuses in null.
  static const _defaultProjectBuildStatusStyle = ProjectBuildStatusStyle();

  /// A [ProjectBuildStatusStyle] for project build status widget
  /// displaying the positive status.
  final ProjectBuildStatusStyle positive;

  /// A [ProjectBuildStatusStyle] for project build status widget
  /// displaying the negative status.
  final ProjectBuildStatusStyle negative;

  /// A [ProjectBuildStatusStyle] for unknown project build status widget.
  final ProjectBuildStatusStyle unknown;

  /// A [ProjectBuildStatusStyle] for inactive project build status widget.
  final ProjectBuildStatusStyle inactive;

  /// Creates a new instance of [ProjectBuildStatusAttentionLevel].
  ///
  /// If the given [positive], [negative], [unknown], or [inactive] is null,
  /// an empty [ProjectBuildStatusStyle] used.
  const ProjectBuildStatusAttentionLevel({
    ProjectBuildStatusStyle positive,
    ProjectBuildStatusStyle negative,
    ProjectBuildStatusStyle unknown,
    ProjectBuildStatusStyle inactive,
  })  : positive = positive ?? _defaultProjectBuildStatusStyle,
        negative = negative ?? _defaultProjectBuildStatusStyle,
        unknown = unknown ?? _defaultProjectBuildStatusStyle,
        inactive = inactive ?? _defaultProjectBuildStatusStyle;
}
