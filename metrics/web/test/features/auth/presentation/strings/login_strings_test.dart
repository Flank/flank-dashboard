import 'package:metrics/features/auth/presentation/strings/auth_strings.dart';
import 'package:test/test.dart';

void main() {
  group('LoginStrings', () {
    test(".getLoadingErrorMessage() returns an error message with the given description", () {
      const error = 'error';
      const message = 'An error occured during loading: $error';

      expect(AuthStrings.getLoadingErrorMessage(error), equals(message));
    });
  });
}
