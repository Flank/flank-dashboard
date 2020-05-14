import 'package:metrics/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/auth/domain/value_objects/email_value_object.dart';
import 'package:metrics/auth/domain/value_objects/password_value_object.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

void main() {
  group("UserCredentialsParam", () {
    test("can't be created with null email", () {
      expect(
        () => UserCredentialsParam(
            email: null, password: PasswordValueObject("password")),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("can't be created with null password", () {
      expect(
        () => UserCredentialsParam(
            email: EmailValueObject('email@mail.mail'), password: null),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
