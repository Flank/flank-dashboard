import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/usecases/sign_out_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';
import 'test_utils/user_repository_mock.dart';

void main() {
  group("SignOutUseCase", () {
    final repository = UserRepositoryMock();

    tearDown(() {
      reset(repository);
    });

    test("can't be created with null repository", () {
      expect(
        () => SignOutUseCase(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("delegates call to the UserRepository.signOut", () async {
      final signOutUseCase = SignOutUseCase(repository);

      await signOutUseCase();

      verify(repository.signOut()).called(equals(1));
    });

    test(
      "throws if UserRepository throws during sign out",
      () {
        final signOutUseCase = SignOutUseCase(repository);

        when(repository.signOut()).thenThrow(const AuthenticationException());

        expect(
          () => signOutUseCase(),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );
  });
}
