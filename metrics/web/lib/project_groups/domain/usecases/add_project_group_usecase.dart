import 'package:metrics/common/domain/usecases/usecase.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/project_group_add_param.dart';

/// The use case that provides the ability to add a project group.
class AddProjectGroupUseCase
    implements UseCase<Future<void>, ProjectGroupAddParam> {
  final ProjectGroupRepository _repository;

  const AddProjectGroupUseCase(this._repository) : assert(_repository != null);

  @override
  Future<void> call(ProjectGroupAddParam params) {
    return _repository.addProjectGroup(
      params.projectGroupName,
      params.projectIds,
    );
  }
}
