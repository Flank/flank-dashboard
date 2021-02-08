// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a param for editing a project group.
class UpdateProjectGroupParam extends Equatable {
  /// An identifier of the project group.
  final String projectGroupId;

  /// A name of the project group.
  final String projectGroupName;

  /// A list of project identifiers, related to the project group.
  final List<String> projectIds;

  @override
  List<Object> get props => [projectGroupId, projectGroupName, projectIds];

  /// Creates the [UpdateProjectGroupParam] with the given [projectGroupId],
  /// [projectGroupName] and [projectIds].
  ///
  /// Throws an [ArgumentError] if either the [projectGroupId],
  /// [projectGroupName] or [projectIds] is `null`.
  UpdateProjectGroupParam(
    this.projectGroupId,
    this.projectGroupName,
    this.projectIds,
  ) {
    ArgumentError.checkNotNull(projectGroupId, 'projectGroupId');
    ArgumentError.checkNotNull(projectGroupName, 'projectGroupName');
    ArgumentError.checkNotNull(projectIds, 'projectIds');
  }
}
