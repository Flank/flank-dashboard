import 'package:metrics/common/domain/repositories/project_repository.dart';
import 'package:metrics/common/domain/usecases/receive_project_updates.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ReceiveProjectUpdates", () {
    test("throws an AssertionError when the given repository is null", () {
      expect(
        () => ReceiveProjectUpdates(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(".call() delegates call to ProjectRepository.projectsStream", () {
      final repository = ProjectRepositoryMock();
      final receiveProjectUpdates = ReceiveProjectUpdates(repository);

      receiveProjectUpdates();

      verify(repository.projectsStream()).called(equals(1));
    });
  });
}

class ProjectRepositoryMock extends Mock implements ProjectRepository {}
