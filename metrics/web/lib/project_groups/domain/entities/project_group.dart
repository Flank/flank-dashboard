// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// An entity that represents a project group data.
class ProjectGroup extends Equatable {
  /// A unique identifier of the project group.
  final String id;

  /// A name of the project group.
  final String name;

  /// A list of projects' identifiers, related to the group.
  final List<String> projectIds;

  @override
  List<Object> get props => [id, name, projectIds];

  /// Creates the [ProjectGroup].
  ///
  /// Throws an [ArgumentError] if either the [name] or [projectIds] is `null`.
  ProjectGroup({
    @required this.name,
    @required this.projectIds,
    this.id,
  }) {
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(projectIds, 'projectIds');
  }
}
