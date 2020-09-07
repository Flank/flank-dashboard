import 'package:metrics/auth/data/model/email_validation_result_data.dart';
import 'package:test/test.dart';

void main() {
  group("EmailValidationResultData", () {
    test(".fromJson() returns null if the given json is null", () {
      final result = EmailValidationResultData.fromJson(null);

      expect(result, isNull);
    });

    test(".toJson() converts an instance to the json encodable map", () {
      const email = 'email';
      const isValid = true;
      const json = {'email': email, 'isValid': isValid};

      final result = EmailValidationResultData(
        email: email,
        isValid: isValid,
      );

      expect(result.toJson(), equals(json));
    });
  });
}
