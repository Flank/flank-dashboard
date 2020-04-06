import 'package:metrics/features/auth/domain/usecases/receive_current_user_updates.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';
import 'test_utils/error_user_repository_stub.dart';
import 'test_utils/user_repository_stub.dart';

void main() {
  group("ReceiveCurrentUserUpdates", () {
    test("can't be created with null repository", () {
      expect(
        () => ReceiveCurrentUserUpdates(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("provides a stream of current user on called", () async {
      final repository = UserRepositoryStub();
      final receiveUserUpdates = ReceiveCurrentUserUpdates(repository);

      expect(repository.isCurrentUserStreamCalled, isFalse);

      receiveUserUpdates();

      expect(repository.isCurrentUserStreamCalled, isTrue);
    });

    test(
      "throws an error if repository throws",
      () {
        final repository = ErrorUserRepositoryStub();
        final receiveUserUpdates = ReceiveCurrentUserUpdates(repository);

        expect(
          () => receiveUserUpdates(),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );
  });
}
