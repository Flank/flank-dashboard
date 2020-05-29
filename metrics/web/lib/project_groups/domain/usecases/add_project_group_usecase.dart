import 'package:metrics/common/domain/usecases/usecase.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';

/// The use case that provides the ability to add a project group.
class AddProjectGroupUseCase
    implements UseCase<Future<void>, AddProjectGroupParam> {
  final ProjectGroupRepository _repository;

  /// Creates the [AddProjectGroupUseCase] use case with the given [ProjectGroupRepository].
  ///
  /// [ProjectGroupRepository] must not be null.
  const AddProjectGroupUseCase(this._repository) : assert(_repository != null);

  @override
  Future<void> call(AddProjectGroupParam params) {
    return _repository.addProjectGroup(
      params.projectGroupName,
      params.projectIds,
    );
  }
}
