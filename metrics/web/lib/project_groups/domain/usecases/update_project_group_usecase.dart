import 'package:metrics/common/domain/usecases/usecase.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/update_project_group_param.dart';

/// The use case that provides the ability to update a project group.
class UpdateProjectGroupUseCase
    implements UseCase<Future<void>, UpdateProjectGroupParam> {
  final ProjectGroupRepository _repository;

  /// Creates the [UpdateProjectGroupUseCase] use case with the given [ProjectGroupRepository].
  ///
  /// [ProjectGroupRepository] must not be null.
  const UpdateProjectGroupUseCase(this._repository)
      : assert(_repository != null);

  @override
  Future<void> call(UpdateProjectGroupParam params) {
    return _repository.updateProjectGroup(
      params.projectGroupId,
      params.projectGroupName,
      params.projectIds,
    );
  }
}
