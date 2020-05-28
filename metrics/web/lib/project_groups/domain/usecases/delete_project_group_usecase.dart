import 'package:metrics/common/domain/usecases/usecase.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/project_group_delete_param.dart';

/// The use case that provides the ability to delete a project group.
class DeleteProjectGroupUseCase
    implements UseCase<Future<void>, ProjectGroupDeleteParam> {
  final ProjectGroupRepository _repository;

  /// Creates the [DeleteProjectGroupUseCase] use case with the given [ProjectGroupRepository].
  ///
  /// [ProjectGroupRepository] must not be null.
  const DeleteProjectGroupUseCase(this._repository)
      : assert(_repository != null);

  @override
  Future<void> call(ProjectGroupDeleteParam params) {
    return _repository.deleteProjectGroup(params.projectGroupId);
  }
}
