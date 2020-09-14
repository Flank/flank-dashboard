import 'package:metrics/auth/data/model/email_domain_validation_result_data.dart';
import 'package:test/test.dart';

void main() {
  group("EmailDomainValidationResultData", () {
    test(".fromJson() returns null if the given json is null", () {
      final result = EmailDomainValidationResultData.fromJson(null);

      expect(result, isNull);
    });

    test(".toJson() converts an instance to the json encodable map", () {
      const isValid = true;
      const json = {'isValid': isValid};

      final result = EmailDomainValidationResultData(isValid: isValid);

      expect(result.toJson(), equals(json));
    });
  });
}
