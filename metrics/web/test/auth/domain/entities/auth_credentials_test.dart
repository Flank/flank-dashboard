// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/domain/entities/auth_credentials.dart';

void main() {
  group("AuthCredentials", () {
    const email = 'email';
    const accessToken = 'access token';
    const idToken = 'id token';

    test("successfully creates with the given required parameters", () {
      expect(
        () => AuthCredentials(
          email: email,
          accessToken: accessToken,
          idToken: idToken,
        ),
        returnsNormally,
      );
    });

    test("throws an ArgumentError when created with null email", () {
      expect(
        () => AuthCredentials(
          email: null,
          accessToken: accessToken,
          idToken: idToken,
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError when created with null access token", () {
      expect(
        () => AuthCredentials(
          email: email,
          accessToken: null,
          idToken: idToken,
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError when created with null id token", () {
      expect(
        () => AuthCredentials(
          email: email,
          accessToken: accessToken,
          idToken: null,
        ),
        throwsArgumentError,
      );
    });
  });
}
