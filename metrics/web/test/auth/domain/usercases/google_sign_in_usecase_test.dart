import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';
import '../../../test_utils/user_repository_mock.dart';

void main() {
  group("GoogleSignInUseCase", () {
    final repository = UserRepositoryMock();

    tearDown(() {
      reset(repository);
    });

    test("can't be created with null repository", () {
      expect(
        () => GoogleSignInUseCase(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "delegates call to the UserRepository.signInWithGoogle",
      () async {
        final signInUseCase = GoogleSignInUseCase(repository);

        await signInUseCase();

        verify(repository.signInWithGoogle()).called(equals(1));
      },
    );

    test(
      "throws if UserRepository throws during sign in process",
      () {
        final signInUseCase = GoogleSignInUseCase(repository);

        when(repository.signInWithGoogle())
            .thenThrow(const AuthenticationException());

        expect(
          () => signInUseCase(),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );
  });
}
