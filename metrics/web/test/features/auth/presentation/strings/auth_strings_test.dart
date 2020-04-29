import 'package:metrics/features/auth/presentation/strings/auth_strings.dart';
import 'package:test/test.dart';

void main() {
  group('AuthStrings', () {
    test(
        ".getPasswordMinLengthErrorMessage() returns a message contains the given password length",
        () {
      const passwordLength = 8;
      const message =
          "Password should be at least $passwordLength characters long";

      expect(
        AuthStrings.getPasswordMinLengthErrorMessage(passwordLength),
        equals(message),
      );
    });
  });
}
