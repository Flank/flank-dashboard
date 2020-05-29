import 'package:metrics/common/domain/usecases/usecase.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/delete_project_group_param.dart';

/// The use case that provides the ability to delete a project group.
class DeleteProjectGroupUseCase
    implements UseCase<Future<void>, DeleteProjectGroupParam> {
  final ProjectGroupRepository _repository;

  /// Creates the [DeleteProjectGroupUseCase] use case with the given [ProjectGroupRepository].
  ///
  /// [ProjectGroupRepository] must not be null.
  const DeleteProjectGroupUseCase(this._repository)
      : assert(_repository != null);

  @override
  Future<void> call(DeleteProjectGroupParam params) {
    return _repository.deleteProjectGroup(params.projectGroupId);
  }
}
