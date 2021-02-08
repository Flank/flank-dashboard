// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/data/model/email_domain_validation_request_data.dart';
import 'package:test/test.dart';

void main() {
  group("EmailDomainValidationRequestData", () {
    test("throws an ArgumentError when created with null email domain", () {
      expect(
        () => EmailDomainValidationRequestData(emailDomain: null),
        throwsArgumentError,
      );
    });

    test(".toJson() converts an instance to the json encodable map", () {
      const emailDomain = 'email';
      const json = {'emailDomain': emailDomain};

      final result = EmailDomainValidationRequestData(emailDomain: emailDomain);

      expect(result.toJson(), equals(json));
    });
  });
}
