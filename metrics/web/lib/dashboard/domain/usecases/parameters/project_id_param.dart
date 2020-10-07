import 'package:meta/meta.dart';

/// Represents the project id param.
@immutable
class ProjectIdParam {
  /// An identifier of the project.
  final String projectId;

  /// Creates a new instance of the [ProjectIdParam] with the given [projectId].
  const ProjectIdParam(this.projectId);
}
