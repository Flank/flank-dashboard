// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a param for deleting a project group.
class DeleteProjectGroupParam extends Equatable {
  /// An identifier of the project group.
  final String projectGroupId;

  @override
  List<Object> get props => [projectGroupId];

  /// Creates the [DeleteProjectGroupParam] with the given [projectGroupId].
  ///
  /// Throws an [ArgumentError] if the [projectGroupId] is `null`.
  DeleteProjectGroupParam({
    @required this.projectGroupId,
  }) {
    ArgumentError.checkNotNull(projectGroupId, 'projectGroupId');
  }
}
