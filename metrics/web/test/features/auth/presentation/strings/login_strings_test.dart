import 'package:metrics/features/auth/presentation/strings/auth_strings.dart';
import 'package:test/test.dart';

void main() {
  group('LoginStrings', () {
    test(".getLoadingErrorMessage() returns an error message with the given description", () {
      const error = 'testErrorMessage';

      expect(AuthStrings.getLoadingErrorMessage(error), contains(error));
    });
  });
}
