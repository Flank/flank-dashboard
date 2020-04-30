import 'package:metrics/features/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/features/auth/presentation/model/auth_error_message.dart';
import 'package:metrics/features/auth/presentation/strings/login_strings.dart';
import 'package:test/test.dart';

void main() {
  group("AuthErrorMessage", () {
    test(
      "maps the unknown error code to unknown error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.unknown);

        expect(errorMessage.message, LoginStrings.unknownErrorMessage);
      },
    );

    test(
      "maps the 'wrong password' error code to the 'wrong password' error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.wrongPassword);

        expect(errorMessage.message, LoginStrings.wrongPasswordErrorMessage);
      },
    );

    test(
      "maps the 'invalid email' error code to the 'invalid email' error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.invalidEmail);

        expect(errorMessage.message, LoginStrings.emailIsInvalid);
      },
    );

    test(
      "maps the 'too many requests' error code to 'too many requests' error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.tooManyRequests);

        expect(errorMessage.message, LoginStrings.tooManyRequestsErrorMessage);
      },
    );

    test(
      "maps the 'user disabled' error code to 'user disabled' error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.userDisabled);

        expect(errorMessage.message, LoginStrings.userDisabledErrorMessage);
      },
    );

    test(
      "maps the 'user not found' error code to 'user not found' error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.userNotFound);

        expect(errorMessage.message, LoginStrings.userNotFoundErrorMessage);
      },
    );
  });
}
