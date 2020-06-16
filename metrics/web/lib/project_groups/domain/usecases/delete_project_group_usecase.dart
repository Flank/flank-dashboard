import 'package:metrics/common/domain/usecases/usecase.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/delete_project_group_param.dart';

/// A [UseCase] that provides an ability to delete a project group.
class DeleteProjectGroupUseCase
    implements UseCase<Future<void>, DeleteProjectGroupParam> {
  /// A repository, that gives an ability to delete a project group.
  final ProjectGroupRepository _repository;

  /// Creates the [DeleteProjectGroupUseCase] use case with the given [ProjectGroupRepository].
  ///
  /// Throws an ArgumentError if the [ProjectGroupRepository] is `null`.
  DeleteProjectGroupUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, '_repository');
  }

  @override
  Future<void> call(DeleteProjectGroupParam params) {
    return _repository.deleteProjectGroup(params.projectGroupId);
  }
}
