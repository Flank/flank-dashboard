import 'package:metrics/common/domain/usecases/usecase.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/project_group_id_param.dart';

/// The use case that provides the ability to delete a project group.
class DeleteProjectGroupUseCase
    implements UseCase<Future<void>, ProjectGroupIdParam> {
  ProjectGroupRepository _repository;

  @override
  Future<void> call(ProjectGroupIdParam params) {
    return _repository.deleteProjectGroup(params.projectGroupId);
  }
}
