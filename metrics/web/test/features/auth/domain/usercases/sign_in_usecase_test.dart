import 'package:metrics/features/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';
import 'test_utils/user_repository_stub.dart';

void main() {
  group("SignInUseCase", () {
    test("can't be created with null repository", () {
      expect(
        () => SignInUseCase(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("signs in user on call", () async {
      final repository = UserRepositoryStub();
      final signInUseCase = SignInUseCase(repository);

      final currentUser = await repository.currentUserStream().first;

      expect(currentUser, isNull);

      const userEmail = 'email';
      final userCredentials = UserCredentialsParam(
        email: userEmail,
        password: 'pass',
      );
      await signInUseCase(userCredentials);

      final newUser = await repository.currentUserStream().first;

      expect(newUser, isNotNull);
      expect(newUser.email, userEmail);
    });
  });
}
