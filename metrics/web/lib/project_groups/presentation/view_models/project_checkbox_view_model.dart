// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents the project to display within a selection list.
class ProjectCheckboxViewModel extends Equatable {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// Determines if the project was checked.
  final bool isChecked;

  @override
  List<Object> get props => [id, name, isChecked];

  /// Creates the [ProjectCheckboxViewModel]
  ///
  /// The [id], the [name] and the [isChecked] must not be null.
  const ProjectCheckboxViewModel({
    @required this.id,
    @required this.name,
    @required this.isChecked,
  })  : assert(id != null),
        assert(name != null),
        assert(isChecked != null);
}
