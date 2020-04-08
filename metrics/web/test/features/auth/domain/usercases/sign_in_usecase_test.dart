import 'package:metrics/features/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';
import 'test_utils/error_user_repository_mock.dart';
import 'test_utils/user_repository_mock.dart';

void main() {
  group("SignInUseCase", () {
    final userCredentials = UserCredentialsParam(
      email: 'email',
      password: 'pass',
    );

    test("can't be created with null repository", () {
      expect(
        () => SignInUseCase(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "delegates call to the UserRepository.signInWithEmailAndPassword",
      () async {
        final repository = UserRepositoryMock();
        final signInUseCase = SignInUseCase(repository);

        await signInUseCase(userCredentials);

        verify(repository.signInWithEmailAndPassword(
          userCredentials.email,
          userCredentials.password,
        )).called(equals(1));
      },
    );

    test(
      "throws if UserRepository throws during sign in process",
      () {
        final repository = ErrorUserRepositoryMock();
        final signInUseCase = SignInUseCase(repository);

        expect(
          () => signInUseCase(userCredentials),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );
  });
}
