import 'package:meta/meta.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';

/// A class that holds the different style configurations for
/// the project build status widget.
@immutable
class ProjectBuildStatusAttentionLevel {
  /// A default [ProjectBuildStatusStyle] used if any of given statuses in null.
  static const _defaultProjectBuildStatusStyle = ProjectBuildStatusStyle();

  /// A [ProjectBuildStatusStyle] for project build status widget
  /// displaying the successful status.
  final ProjectBuildStatusStyle successful;

  /// A [ProjectBuildStatusStyle] for project build status widget
  /// displaying the failed status.
  final ProjectBuildStatusStyle failed;

  /// A [ProjectBuildStatusStyle] for project build status widget
  /// displaying the unknown status.
  final ProjectBuildStatusStyle unknown;

  /// Creates a new instance of [ProjectBuildStatusAttentionLevel].
  ///
  /// If [successful], [failed] or [unknown] is null,
  /// an empty [ProjectBuildStatusStyle] used.
  const ProjectBuildStatusAttentionLevel({
    ProjectBuildStatusStyle successful,
    ProjectBuildStatusStyle failed,
    ProjectBuildStatusStyle unknown,
  })  : successful = successful ?? _defaultProjectBuildStatusStyle,
        failed = failed ?? _defaultProjectBuildStatusStyle,
        unknown = unknown ?? _defaultProjectBuildStatusStyle;
}
