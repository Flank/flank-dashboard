import 'package:metrics/features/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';
import 'test_utils/error_user_repository_mock.dart';
import 'test_utils/user_repository_mock.dart';

void main() {
  group("ReceiveAuthenticationUpdates", () {
    test("can't be created with null repository", () {
      expect(
        () => ReceiveAuthenticationUpdates(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("delegates call to the UserRepository.authenticationStream", () async {
      final repository = UserRepositoryMock();
      final receiveUserUpdates = ReceiveAuthenticationUpdates(repository);

      receiveUserUpdates();

      verify(repository.authenticationStream()).called(equals(1));
    });

    test(
      "throws an error if repository throws",
      () {
        final repository = ErrorUserRepositoryMock();
        final receiveUserUpdates = ReceiveAuthenticationUpdates(repository);

        expect(
          () => receiveUserUpdates(),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );
  });
}
