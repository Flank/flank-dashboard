import 'package:ci_integration/integration/exception/config_validation_exception.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ConfigValidationException", () {
    const message = 'message';

    test(
      "creates an instance with the given message",
      () {
        const exception = ConfigValidationException(message: message);

        expect(exception.message, equals(message));
      },
    );

    test(
      ".toString() returns the exception's message if the message is not null",
      () {
        const exception = ConfigValidationException(message: message);

        expect(exception.toString(), equals(message));
      },
    );

    test(
      ".toString() returns an empty string if the exception's message is null",
      () {
        const exception = ConfigValidationException(message: null);

        expect(exception.toString(), isEmpty);
      },
    );
  });
}
