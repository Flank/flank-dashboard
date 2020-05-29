import 'package:metrics/project_groups/domain/usecases/receive_project_group_updates.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';
import '../../../test_utils/project_group_repository_mock.dart';

void main() {
  group("ReceiveProjectGroupUpdates", () {
    test("throws an AssertionError when the given repository is null", () {
      expect(
        () => ReceiveProjectGroupUpdates(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(".call() delegates call to ProjectGroupRepository.projectsStream", () {
      final repository = ProjectGroupRepositoryMock();
      final receiveProjectGroupUpdates = ReceiveProjectGroupUpdates(repository);

      receiveProjectGroupUpdates();

      verify(repository.projectGroupsStream()).called(equals(1));
    });
  });
}
