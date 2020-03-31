import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

void main() {
  group('User', () {
    test('User cannot be created without uid', () {
      const email = 'test@test.com';

      expect(() => User(email: email), MatcherUtil.throwsAssertionError);
    });

    test('User cannot be created without email', () {
      const uid = 'RANDOMUID';

      expect(() => User(uid: uid), MatcherUtil.throwsAssertionError);
    });
  });
}
