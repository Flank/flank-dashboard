import 'package:metrics/project_groups/domain/usecases/add_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';
import '../../../test_utils/project_group_repository_mock.dart';

void main() {
  group("AddProjectGroupUseCase", () {
    test("throws an AssertionError when the given repository is null", () {
      expect(
        () => AddProjectGroupUseCase(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "delegates call to the ProjectGroupRepository.addProjectGroup",
      () async {
        final repository = ProjectGroupRepositoryMock();
        final addProjectGroupUseCase = AddProjectGroupUseCase(repository);
        const projectGroupParam = AddProjectGroupParam('name', []);

        await addProjectGroupUseCase(projectGroupParam);

        verify(repository.addProjectGroup(
          projectGroupParam.projectGroupName,
          projectGroupParam.projectIds,
        )).called(equals(1));
      },
    );
  });
}
