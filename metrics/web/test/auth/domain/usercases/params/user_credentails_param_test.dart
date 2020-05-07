import 'package:metrics/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

void main() {
  group("UserCredentialsParam", () {
    test("can't be created with null email", () {
      expect(
        () => UserCredentialsParam(email: null, password: 'pass'),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("can't be created with null password", () {
      expect(
        () => UserCredentialsParam(email: 'email', password: null),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
