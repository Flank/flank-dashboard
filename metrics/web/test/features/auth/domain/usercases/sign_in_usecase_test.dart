import 'package:metrics/features/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';
import 'test_utils/error_user_repository_stub.dart';
import 'test_utils/user_repository_stub.dart';

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
        final repository = UserRepositoryStub();
        final signInUseCase = SignInUseCase(repository);

        expect(repository.isSignInCalled, isFalse);

        await signInUseCase(userCredentials);

        expect(repository.isSignInCalled, isTrue);
      },
    );

    test(
      "throws if UserRepository throws during sign in process",
      () {
        final repository = ErrorUserRepositoryStub();
        final signInUseCase = SignInUseCase(repository);

        expect(
          () => signInUseCase(userCredentials),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );
  });
}
