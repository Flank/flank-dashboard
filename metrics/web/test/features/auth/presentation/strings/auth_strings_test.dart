import 'package:metrics/features/auth/presentation/strings/auth_strings.dart';
import 'package:test/test.dart';

void main() {
  group('AuthStrings', () {
    test(
        ".getPasswordMinLengthErrorMessage() returns a message that contains the given password length",
        () {
      const passwordLength = 8;

      expect(
        AuthStrings.getPasswordMinLengthErrorMessage(passwordLength),
        contains(passwordLength.toString()),
      );
    });
  });
}
