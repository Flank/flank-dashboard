import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics/common/domain/usecases/usecase.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';

/// Provides an the ability to receive [ProjectGroup]s updates.
class ReceiveProjectGroupUpdates
    implements UseCase<Stream<List<ProjectGroup>>, void> {
  final ProjectGroupRepository _repository;

  /// Creates the [ReceiveProjectGroupUpdates] use case with the given [ProjectGroupRepository].
  ///
  /// [ProjectGroupRepository] must not be null.
  const ReceiveProjectGroupUpdates(this._repository)
      : assert(_repository != null);

  @override
  Stream<List<ProjectGroup>> call([_]) {
    return _repository.projectGroupsStream();
  }
}
