import 'package:metrics/project_groups/domain/usecases/parameters/update_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/update_project_group_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';
import '../../../test_utils/project_group_repository_mock.dart';

void main() {
  group("UpdateProjectGroupUseCase", () {
    test("throws an AssertionError when the given repository is null", () {
      expect(
        () => UpdateProjectGroupUseCase(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "delegates call to the ProjectGroupRepository.updateProjectGroup",
      () async {
        final repository = ProjectGroupRepositoryMock();
        final updateProjectGroupUseCase = UpdateProjectGroupUseCase(repository);
        const projectGroupParam = UpdateProjectGroupParam('id', 'name', []);

        await updateProjectGroupUseCase(projectGroupParam);

        verify(repository.updateProjectGroup(
          projectGroupParam.projectGroupId,
          projectGroupParam.projectGroupName,
          projectGroupParam.projectIds,
        )).called(equals(1));
      },
    );
  });
}
