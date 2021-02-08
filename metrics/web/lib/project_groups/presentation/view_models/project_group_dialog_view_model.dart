// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents the data of the project group to display
/// within dialogs for adding and editing a project group.
class ProjectGroupDialogViewModel extends Equatable {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// A list of projects' identifiers, related to the group.
  final UnmodifiableListView<String> selectedProjectIds;

  @override
  List<Object> get props => [id, name, selectedProjectIds];

  /// Creates the [ProjectGroupDialogViewModel].
  ///
  /// The [selectedProjectIds] must not be null.
  const ProjectGroupDialogViewModel({
    this.id,
    this.name,
    @required this.selectedProjectIds,
  }) : assert(selectedProjectIds != null);
}
