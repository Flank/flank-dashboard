import 'package:metrics/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_updates.dart';
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

    test(".call() delegates call to MetricsRepository.projectsStream", () {
      final repository = MetricsRepositoryMock();
      final receiveProjectUpdates = ReceiveProjectUpdates(repository);

      receiveProjectUpdates();

      verify(repository.projectsStream()).called(equals(1));
    });
  });
}

class MetricsRepositoryMock extends Mock implements MetricsRepository {}
