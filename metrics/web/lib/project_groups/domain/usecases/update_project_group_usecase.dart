import 'package:metrics/common/domain/usecases/usecase.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/project_group_update_param.dart';

/// The use case that provides the ability to update a project group.
class UpdateProjectGroupUseCase
    implements UseCase<Future<void>, ProjectGroupUpdateParam> {
  ProjectGroupRepository _repository;

  @override
  Future<void> call(ProjectGroupUpdateParam params) {
    return _repository.updateProjectGroup(
      params.projectGroupId,
      params.projectGroupName,
      params.projectIds,
    );
  }
}
