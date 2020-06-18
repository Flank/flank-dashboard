import 'package:metrics/common/domain/usecases/usecase.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';

/// A [UseCase] that provides an ability to add a new project group.
class AddProjectGroupUseCase
    implements UseCase<Future<void>, AddProjectGroupParam> {
  /// A repository that gives an ability to update a project group.
  final ProjectGroupRepository _repository;

  /// Creates the [AddProjectGroupUseCase] use case
  /// with the given [ProjectGroupRepository].
  ///
  /// Throws an [ArgumentError] if the [ProjectGroupRepository] is `null`.
  AddProjectGroupUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  Future<void> call(AddProjectGroupParam params) {
    return _repository.addProjectGroup(
      params.projectGroupName,
      params.projectIds,
    );
  }
}
