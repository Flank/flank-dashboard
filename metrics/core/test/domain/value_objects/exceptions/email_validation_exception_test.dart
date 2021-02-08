// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("EmailValidationException", () {
    test("throws an ArgumentError if the given code is null", () {
      expect(() => EmailValidationException(null), throwsArgumentError);
    });

    test("successfully creates with the given error code", () {
      const errorCode = EmailValidationErrorCode.isNull;

      final validationException = EmailValidationException(errorCode);

      expect(validationException.code, equals(errorCode));
    });
  });
}
