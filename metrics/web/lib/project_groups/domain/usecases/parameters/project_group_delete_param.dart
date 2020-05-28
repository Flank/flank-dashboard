import 'package:flutter/cupertino.dart';

/// Represents a param for deleting a project group.
@immutable
class ProjectGroupDeleteParam {
  final String projectGroupId;

  /// Creates the [ProjectGroupDeleteParam] with the given [projectGroupId].
  const ProjectGroupDeleteParam(this.projectGroupId);
}
