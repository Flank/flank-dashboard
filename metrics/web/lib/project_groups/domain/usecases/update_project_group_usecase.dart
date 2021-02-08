// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/update_project_group_param.dart';

/// A [UseCase] that provides an ability to update a project group.
class UpdateProjectGroupUseCase
    implements UseCase<Future<void>, UpdateProjectGroupParam> {
  /// A repository that gives an ability to update a project group.
  final ProjectGroupRepository _repository;

  /// Creates the [UpdateProjectGroupUseCase] use case
  /// with the given [ProjectGroupRepository].
  ///
  /// Throws an [ArgumentError] if the [ProjectGroupRepository] is `null`.
  UpdateProjectGroupUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, '_repository');
  }

  @override
  Future<void> call(UpdateProjectGroupParam params) {
    return _repository.updateProjectGroup(
      params.projectGroupId,
      params.projectGroupName,
      params.projectIds,
    );
  }
}
