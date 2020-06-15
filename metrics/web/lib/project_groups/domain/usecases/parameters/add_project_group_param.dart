import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a param for adding a project group.
class AddProjectGroupParam extends Equatable {
  final String projectGroupName;
  final List<String> projectIds;

  /// Creates the [AddProjectGroupParam] with the given [projectGroupName]
  /// and [projectIds].
  const AddProjectGroupParam({
    @required this.projectGroupName,
    @required this.projectIds,
  })  : assert(projectGroupName != null),
        assert(projectIds != null);

  @override
  List<Object> get props => [projectGroupName, projectIds];
}
