import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a param for deleting a project group.
class DeleteProjectGroupParam extends Equatable {
  final String projectGroupId;

  /// Creates the [DeleteProjectGroupParam] with the given [projectGroupId].
  const DeleteProjectGroupParam({
    @required this.projectGroupId,
  }) : assert(projectGroupId != null);

  @override
  List<Object> get props => [projectGroupId];
}
