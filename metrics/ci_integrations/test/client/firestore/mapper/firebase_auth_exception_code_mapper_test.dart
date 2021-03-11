// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/mappers/firebase_auth_exception_code_mapper.dart';
import 'package:ci_integration/client/firestore/model/firebase_auth_exception_code.dart';
import 'package:test/test.dart';

void main() {
  group("FirebaseAuthExceptionCodeMapper", () {
    const mapper = FirebaseAuthExceptionCodeMapper();

    test(
      ".map() maps the email not found auth exception code to FirebaseAuthExceptionCode.emailNotFound",
      () {
        const expectedCode = FirebaseAuthExceptionCode.emailNotFound;

        final code = mapper.map(FirebaseAuthExceptionCodeMapper.emailNotFound);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".map() maps the invalid api key auth exception code to FirebaseAuthExceptionCode.invalidApiKey",
      () {
        const expectedCode = FirebaseAuthExceptionCode.invalidApiKey;

        final code = mapper.map(FirebaseAuthExceptionCodeMapper.invalidApiKey);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".map() maps the invalid password auth exception code to FirebaseAuthExceptionCode.invalidPassword",
      () {
        const expectedCode = FirebaseAuthExceptionCode.invalidPassword;

        final code =
            mapper.map(FirebaseAuthExceptionCodeMapper.invalidPassword);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".map() maps the password login disabled auth exception code to FirebaseAuthExceptionCode.passwordLoginDisabled",
      () {
        const expectedCode = FirebaseAuthExceptionCode.passwordLoginDisabled;

        final code =
            mapper.map(FirebaseAuthExceptionCodeMapper.passwordLoginDisabled);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".map() returns null if the given value does not match any FirebaseAuthExceptionCode value",
      () {
        final code = mapper.map('test');

        expect(code, isNull);
      },
    );

    test(
      ".map() maps the null auth exception code to null",
      () {
        final code = mapper.map(null);

        expect(code, isNull);
      },
    );

    test(
      ".unmap() unmaps the FirebaseAuthExceptionCode.emailNotFound to the email not found auth exception code",
      () {
        const expectedCode = FirebaseAuthExceptionCodeMapper.emailNotFound;

        final code = mapper.unmap(FirebaseAuthExceptionCode.emailNotFound);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".unmap() unmaps the FirebaseAuthExceptionCode.invalidApiKey to the invalid api key auth exception code",
      () {
        const expectedCode = FirebaseAuthExceptionCodeMapper.invalidApiKey;

        final code = mapper.unmap(FirebaseAuthExceptionCode.invalidApiKey);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".unmap() unmaps the FirebaseAuthExceptionCode.invalidPassword to the invalid password auth exception code",
      () {
        const expectedCode = FirebaseAuthExceptionCodeMapper.invalidPassword;

        final code = mapper.unmap(FirebaseAuthExceptionCode.invalidPassword);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".unmap() unmaps the FirebaseAuthExceptionCode.passwordLoginDisabled to the password login disabled auth exception code",
      () {
        const expectedCode =
            FirebaseAuthExceptionCodeMapper.passwordLoginDisabled;

        final code =
            mapper.unmap(FirebaseAuthExceptionCode.passwordLoginDisabled);

        expect(code, equals(expectedCode));
      },
    );

    test(
      ".unmap() unmaps null auth exception code to null",
      () {
        final code = mapper.unmap(null);

        expect(code, isNull);
      },
    );
  });
}
