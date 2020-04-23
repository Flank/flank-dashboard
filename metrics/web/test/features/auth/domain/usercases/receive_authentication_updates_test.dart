import 'package:metrics/features/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/features/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';
import 'test_utils/user_repository_mock.dart';

void main() {
  group("ReceiveAuthenticationUpdates", () {
    final repository = UserRepositoryMock();

    tearDown(() {
      reset(repository);
    });

    test("can't be created with null repository", () {
      expect(
        () => ReceiveAuthenticationUpdates(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("delegates call to the UserRepository.authenticationStream", () async {
      final receiveUserUpdates = ReceiveAuthenticationUpdates(repository);

      receiveUserUpdates();

      verify(repository.authenticationStream()).called(equals(1));
    });

    test(
      "throws an exception if repository throws",
      () {
        final receiveUserUpdates = ReceiveAuthenticationUpdates(repository);

        when(repository.authenticationStream())
            .thenThrow(const AuthenticationException());

        expect(
          () => receiveUserUpdates(),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );
  });
}
