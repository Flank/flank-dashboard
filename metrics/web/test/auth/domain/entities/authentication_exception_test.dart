// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("AuthenticationException", () {
    test(
      "constructor creates the instance with unknown error code when the null is passed",
      () {
        const authException = AuthenticationException(code: null);

        expect(authException.code, AuthErrorCode.unknown);
      },
    );
  });
}
