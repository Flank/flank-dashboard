import 'package:metrics/analytics/domain/usecases/log_login_use_case.dart';
import 'package:metrics/common/domain/usecases/parameters/user_id_param.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/analytics_repository_mock.dart';

void main() {
  group("LogLoginUseCase", () {
    final repository = AnalyticsRepositoryMock();

    tearDown(() {
      reset(repository);
    });

    final userIdParam = UserIdParam(id: "id");

    test("throws an AssertionError if the given repository is null", () {
      expect(
        () => LogLoginUseCase(null),
        throwsArgumentError,
      );
    });

    test("delegates call to the given AnalyticsRepository", () async {
      final logLoginUseCase = LogLoginUseCase(repository);

      await logLoginUseCase(userIdParam);

      verify(repository.logLogin(
        userIdParam.id,
      )).called(equals(1));
    });
  });
}
