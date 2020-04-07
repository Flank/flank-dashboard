import 'package:metrics/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';
import 'test_utils/error_user_repository_stub.dart';
import 'test_utils/user_repository_stub.dart';

void main() {
  group("SignOutUseCase", () {
    test("can't be created with null repository", () {
      expect(
        () => SignOutUseCase(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("delegates call to the UserRepository.signOut", () async {
      final repository = UserRepositoryStub();
      final signOutUseCase = SignOutUseCase(repository);

      expect(repository.isSignOutCalled, isFalse);

      await signOutUseCase();

      expect(repository.isSignOutCalled, isTrue);
    });

    test(
      "throws if UserRepository throws during sign out",
      () {
        final repository = ErrorUserRepositoryStub();
        final signOutUseCase = SignOutUseCase(repository);

        expect(
          () => signOutUseCase(),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );
  });
}
