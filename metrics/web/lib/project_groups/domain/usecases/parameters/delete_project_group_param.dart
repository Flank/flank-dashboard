import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a param for deleting a project group.
class DeleteProjectGroupParam extends Equatable {
  /// A project group's identifier.
  final String projectGroupId;

  /// Creates the [DeleteProjectGroupParam] with the given [projectGroupId].
  ///
  /// Throws an ArgumentError if the [projectGroupId] is `null`.
  DeleteProjectGroupParam({
    @required this.projectGroupId,
  }) {
    ArgumentError.checkNotNull(projectGroupId, 'projectGroupId');
  }

  @override
  List<Object> get props => [projectGroupId];
}
