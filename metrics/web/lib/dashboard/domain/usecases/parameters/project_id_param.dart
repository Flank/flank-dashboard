import 'package:meta/meta.dart';

/// Represents the project id param.
@immutable
class ProjectIdParam {
  /// A unique identifier of this project.
  final String projectId;

  /// Creates a new instance of the [ProjectIdParam] with the given [projectId].
  const ProjectIdParam(this.projectId);
}
