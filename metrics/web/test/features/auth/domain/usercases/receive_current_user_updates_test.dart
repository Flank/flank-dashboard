import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/domain/usecases/receive_current_user_updates.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';
import 'test_utils/user_repository_stub.dart';

void main() {
  group("ReceiveCurrentUserUpdates", () {
    test("can't be created with null repository", () {
      expect(
        () => ReceiveCurrentUserUpdates(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("provides a stream that emmits user updates", () async {
      final seedUser = User(id: 'seed');

      final repository = UserRepositoryStub(seedUser: seedUser);
      final receiveUserUpdates = ReceiveCurrentUserUpdates(repository);

      final userUpdates = receiveUserUpdates();
      final user = await userUpdates.first;

      expect(userUpdates, isA<Stream<User>>());
      expect(user.id, seedUser.id);
      expect(user.email, seedUser.email);
    });
  });
}
