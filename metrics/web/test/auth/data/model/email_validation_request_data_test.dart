import 'package:metrics/auth/data/model/email_validation_request_data.dart';
import 'package:test/test.dart';

void main() {
  group("EmailValidationRequestData", () {
    test("throws an ArgumentError when created with null email", () {
      expect(
        () => EmailValidationRequestData(email: null),
        throwsArgumentError,
      );
    });

    test(".toJson() converts an instance to the json encodable map", () {
      const email = 'email';
      const json = {'email': email};

      final result = EmailValidationRequestData(email: email);

      expect(result.toJson(), equals(json));
    });
  });
}
