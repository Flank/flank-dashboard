import 'package:metrics/project_groups/domain/usecases/delete_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/delete_project_group_param.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/project_group_repository_mock.dart';

void main() {
  group("DeleteProjectGroupUseCase", () {
    test("throws an ArgumentError when the given repository is null", () {
      expect(
        () => DeleteProjectGroupUseCase(null),
        throwsArgumentError,
      );
    });

    test(
      ".call() delegates deleting to the ProjectGroupRepository.deleteProjectGroup() method",
      () async {
        final repository = ProjectGroupRepositoryMock();
        final deleteProjectGroupUseCase = DeleteProjectGroupUseCase(repository);
        final projectGroupParam = DeleteProjectGroupParam(projectGroupId: 'id');

        await deleteProjectGroupUseCase(projectGroupParam);

        verify(repository.deleteProjectGroup(
          projectGroupParam.projectGroupId,
        )).called(equals(1));
      },
    );
  });
}
