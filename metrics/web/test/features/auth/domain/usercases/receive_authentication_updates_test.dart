import 'package:metrics/features/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/features/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';
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

      when(repository.authenticationStream()).thenAnswer(
        (_) => const Stream.empty(),
      );

      receiveUserUpdates();

      verify(repository.authenticationStream()).called(equals(1));
    });

    test(
      "throws an error if repository throws",
      () {
        final repository = UserRepositoryMock();
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
