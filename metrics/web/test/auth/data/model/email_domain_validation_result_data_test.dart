// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/data/model/email_domain_validation_result_data.dart';
import 'package:test/test.dart';

void main() {
  group("EmailDomainValidationResultData", () {
    const isValid = true;
    const json = {'isValid': isValid};

    test("throws an ArgumentError if the given is valid is null", () {
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
      ".fromJson() successfully creates an instance from the json encodable map",
      () {
        final actualResult = EmailDomainValidationResultData.fromJson(json);

        expect(actualResult.isValid, equals(isValid));
      },
    );

    test(".toJson() converts an instance to the json encodable map", () {
      final result = EmailDomainValidationResultData(isValid: isValid);

      expect(result.toJson(), equals(json));
    });
  });
}
