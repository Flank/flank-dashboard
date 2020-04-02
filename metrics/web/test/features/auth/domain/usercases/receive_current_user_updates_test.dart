import 'package:metrics/features/auth/domain/usecases/receive_current_user_updates.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

void main() {
  group("ReceiveCurrentUserUpdates", () {
    test("can't be created with null repository", () {
      expect(
        () => ReceiveCurrentUserUpdates(null),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
