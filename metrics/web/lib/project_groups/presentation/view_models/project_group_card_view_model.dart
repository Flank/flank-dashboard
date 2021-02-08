// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents the project group to display.
class ProjectGroupCardViewModel extends Equatable {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// The count of projects, related to the group.
  final int projectsCount;

  @override
  List<Object> get props => [id, name, projectsCount];

  /// Creates the [ProjectGroupCardViewModel]
  ///
  /// The [id], the [name] and the [projectsCount] must not be null.
  const ProjectGroupCardViewModel({
    @required this.id,
    @required this.name,
    @required this.projectsCount,
  })  : assert(id != null),
        assert(name != null),
        assert(projectsCount != null);
}
