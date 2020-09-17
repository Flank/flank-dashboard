import 'package:metrics/auth/data/model/email_domain_validation_result_data.dart';
import 'package:test/test.dart';

void main() {
  group("EmailDomainValidationResultData", () {
    const isValid = true;
    const json = {'isValid': isValid};

    test("throws an ArgumentError if the given isValid is null", () {
      expect(
        () => EmailDomainValidationResultData(isValid: null),
        throwsArgumentError,
      );
    });

    test(".fromJson() returns null if the given json is null", () {
      final result = EmailDomainValidationResultData.fromJson(null);

      expect(result, isNull);
    });

    test(
      ".fromJson() creates an instance with the same isValid parameter as in the given json",
      () {
        final expectedResult = EmailDomainValidationResultData(
          isValid: isValid,
        );

        final actualResult = EmailDomainValidationResultData.fromJson(json);

        expect(actualResult.isValid, equals(expectedResult.isValid));
      },
    );

    test(".toJson() converts an instance to the json encodable map", () {
      final result = EmailDomainValidationResultData(isValid: isValid);

      expect(result.toJson(), equals(json));
    });
  });
}
