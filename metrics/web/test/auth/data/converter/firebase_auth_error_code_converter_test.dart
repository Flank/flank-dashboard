// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/data/converter/firebase_auth_error_code_converter.dart';
import 'package:metrics/auth/data/model/firebase_auth_error_code.dart';
import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:test/test.dart';

void main() {
  group("FirebaseAuthErrorCodeConverter", () {
    const converter = FirebaseAuthErrorCodeConverter.convert;

    test(
      ".convert() returns the user not found auth error code to the given error string is the user not found Firebase auth error code string",
      () {
        final authErrorCode = converter(FirebaseAuthErrorCode.userNotFound);

        expect(authErrorCode, equals(AuthErrorCode.userNotFound));
      },
    );

    test(
      ".convert() returns the wrong password auth error code to the given error string is the wrong password Firebase auth error code string",
      () {
        final authErrorCode = converter(FirebaseAuthErrorCode.wrongPassword);

        expect(authErrorCode, equals(AuthErrorCode.wrongPassword));
      },
    );

    test(
      ".convert() returns the invalid email auth error code to the given error string is the invalid email Firebase auth error code string",
      () {
        final authErrorCode = converter(FirebaseAuthErrorCode.invalidEmail);

        expect(authErrorCode, equals(AuthErrorCode.invalidEmail));
      },
    );

    test(
      ".convert() returns the user disabled auth error code to the given error string is the user disabled Firebase auth error code string",
      () {
        final authErrorCode = converter(FirebaseAuthErrorCode.userDisabled);

        expect(authErrorCode, equals(AuthErrorCode.userDisabled));
      },
    );

    test(
      ".convert() returns the too many requests error code to the given error string is the too man requests Firebase auth error code string",
      () {
        final authErrorCode = converter(FirebaseAuthErrorCode.tooManyRequests);

        expect(authErrorCode, equals(AuthErrorCode.tooManyRequests));
      },
    );

    test(
      ".convert() returns the unknown error code if there is no corresponding authentication error code for the given Firebase auth error code string",
      () {
        final authErrorCode = converter("unknown error");

        expect(authErrorCode, equals(AuthErrorCode.unknown));
      },
    );

    test(
      ".convert() returns the unknown error code if the given Firebase auth error code string is null",
      () {
        final authErrorCode = converter(null);

        expect(authErrorCode, equals(AuthErrorCode.unknown));
      },
    );
  });
}
