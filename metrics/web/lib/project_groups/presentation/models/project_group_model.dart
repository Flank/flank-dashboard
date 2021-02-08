// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A class that represents a project group model used to
/// transfer project data between [ChangeNotifier]s.
class ProjectGroupModel extends Equatable {
  /// A unique identifier of the project group.
  final String id;

  /// A name of the project group.
  final String name;

  /// A list of projects' identifiers, related to the group.
  final UnmodifiableListView<String> projectIds;

  @override
  List<Object> get props => [id, name, projectIds];

  /// Creates the [ProjectGroupModel] with the given [name] and the [projectIds].
  ///
  /// The [name] and the [projectIds] must not be null.
  const ProjectGroupModel({
    this.id,
    @required this.name,
    @required this.projectIds,
  })  : assert(name != null),
        assert(projectIds != null);
}
