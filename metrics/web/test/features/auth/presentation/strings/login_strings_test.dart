import 'package:metrics/features/auth/presentation/strings/login_strings.dart';
import 'package:test/test.dart';

void main() {
  group('LoginStrings', () {
    test(".getLoadingErrorMessage() returns an error message with the given description", () {
      const error = 'error';
      const message = 'An error occured during loading: $error';

      expect(LoginStrings.getLoadingErrorMessage(error), equals(message));
    });
  });
}
