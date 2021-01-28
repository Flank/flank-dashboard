import 'package:ci_integration/integration/error/config_validation_error.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ConfigValidationError", () {
    const message = 'message';

    const defaultError = 'An error occurred during config validation: ';

    test(
      "creates an instance with the given message",
      () {
        const exception = ConfigValidationError(message: message);

        expect(exception.message, equals(message));
      },
    );

    test(
      ".toString() returns the exception's message if the message is not null",
      () {
        const expectedError = '$defaultError$message';
        const exception = ConfigValidationError(message: message);

        expect(exception.toString(), equals(expectedError));
      },
    );

    test(
      ".toString() returns an empty string if the exception's message is null",
      () {
        const exception = ConfigValidationError(message: null);

        expect(exception.toString(), equals(defaultError));
      },
    );
  });
}
