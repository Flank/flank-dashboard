import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

/// Represents a param for deleting a project group.
@immutable
class DeleteProjectGroupParam extends Equatable {
  final String projectGroupId;

  /// Creates the [DeleteProjectGroupParam] with the given [projectGroupId].
  const DeleteProjectGroupParam({
    @required this.projectGroupId,
  }) : assert(projectGroupId != null);

  @override
  List<Object> get props => [projectGroupId];
}
