// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/mappers/firebase_auth_error_code_mapper.dart';
import 'package:ci_integration/client/firestore/model/firebase_auth_error_code.dart';
import 'package:test/test.dart';

void main() {
  group("FirebaseAuthErrorCodeMapper", () {
    const mapper = FirebaseAuthErrorCodeMapper();

    test(
      ".map() maps the email not found auth error code to FirebaseAuthErrorCode.emailNotFound",
      () {
        const expectedCode = FirebaseAuthErrorCode.emailNotFound;

        final code = mapper.map(FirebaseAuthErrorCodeMapper.emailNotFound);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".map() maps the invalid api key auth error code to FirebaseAuthErrorCode.invalidApiKey",
      () {
        const expectedCode = FirebaseAuthErrorCode.invalidApiKey;

        final code = mapper.map(FirebaseAuthErrorCodeMapper.invalidApiKey);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".map() maps the invalid password auth error code to FirebaseAuthErrorCode.invalidPassword",
      () {
        const expectedCode = FirebaseAuthErrorCode.invalidPassword;

        final code = mapper.map(FirebaseAuthErrorCodeMapper.invalidPassword);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".map() maps the password login disabled auth error code to FirebaseAuthErrorCode.passwordLoginDisabled",
      () {
        const expectedCode = FirebaseAuthErrorCode.passwordLoginDisabled;

        final code =
            mapper.map(FirebaseAuthErrorCodeMapper.passwordLoginDisabled);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".map() returns null if the given value does not match any FirebaseAuthErrorCode value",
      () {
        final code = mapper.map('test');

        expect(code, isNull);
      },
    );

    test(
      ".map() maps the null auth error code to null",
      () {
        final code = mapper.map(null);

        expect(code, isNull);
      },
    );

    test(
      ".unmap() unmaps the FirebaseAuthErrorCode.emailNotFound to the email not found auth error code",
      () {
        const expectedCode = FirebaseAuthErrorCodeMapper.emailNotFound;

        final code = mapper.unmap(FirebaseAuthErrorCode.emailNotFound);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".unmap() unmaps the FirebaseAuthErrorCode.invalidApiKey to the invalid api key auth error code",
      () {
        const expectedCode = FirebaseAuthErrorCodeMapper.invalidApiKey;

        final code = mapper.unmap(FirebaseAuthErrorCode.invalidApiKey);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".unmap() unmaps the FirebaseAuthErrorCode.invalidPassword to the invalid password auth error code",
      () {
        const expectedCode = FirebaseAuthErrorCodeMapper.invalidPassword;

        final code = mapper.unmap(FirebaseAuthErrorCode.invalidPassword);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".unmap() unmaps the FirebaseAuthErrorCode.passwordLoginDisabled to the password login disabled auth error code",
      () {
        const expectedCode = FirebaseAuthErrorCodeMapper.passwordLoginDisabled;

        final code = mapper.unmap(FirebaseAuthErrorCode.passwordLoginDisabled);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".unmap() unmaps null auth error code to null",
      () {
        final code = mapper.unmap(null);

        expect(code, isNull);
      },
    );
  });
}
