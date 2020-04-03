import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';
import 'test_utils/user_repository_stub.dart';

void main() {
  group("SignOutUseCase", () {
    test("can't be created with null repository", () {
      expect(
        () => SignOutUseCase(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test('signs out user on call', () async {
      final repository = UserRepositoryStub(seedUser: User(id: 'id'));
      final signOutUseCase = SignOutUseCase(repository);
      final currentUser = await repository.currentUserStream().first;

      expect(currentUser, isNotNull);

      await signOutUseCase();
      final newUser = await repository.currentUserStream().first;

      expect(newUser, isNull);
    });
  });
}
