import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("PasswordValidationException", () {
    test("throws an ArgumentError if the given code is null", () {
      expect(() => PasswordValidationException(null), throwsArgumentError);
    });

    test("successfully creates with the given error code", () {
      const errorCode = PasswordValidationErrorCode.isNull;

      final validationException = PasswordValidationException(errorCode);

      expect(validationException.code, equals(errorCode));
    });
  });
}
