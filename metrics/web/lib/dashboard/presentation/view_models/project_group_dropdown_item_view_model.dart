// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A view model that represents the project group to display within a dropdown list.
class ProjectGroupDropdownItemViewModel extends Equatable {
  /// A unique identifier of the project group.
  final String id;

  /// A name of the project group.
  final String name;

  @override
  List<Object> get props => [id, name];

  /// Creates the [ProjectGroupDropdownItemViewModel].
  ///
  /// The [name] must not be null.
  const ProjectGroupDropdownItemViewModel({
    this.id,
    @required this.name,
  }) : assert(name != null);
}
