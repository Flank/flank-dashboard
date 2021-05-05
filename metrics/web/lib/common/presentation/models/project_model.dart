// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

/// A class that represents a project model used to
/// transfer project data between [ChangeNotifier]s.
class ProjectModel extends Equatable {
  /// The identifier of this project.
  final String id;

  /// The name of this project.
  final String name;

  @override
  List<Object> get props => [id, name];

  /// Creates an instance using the given [id] and [name].
  ///
  /// Throws an [AssertionError] if either the [id] or [name] is `null`.
  const ProjectModel({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);
}
