// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:test/test.dart';

void main() {
  group('AuthStrings', () {
    test(
        ".getPasswordMinLengthErrorMessage() returns a message that contains the given password length",
        () {
      const passwordLength = 8;

      expect(
        AuthStrings.getPasswordMinLengthErrorMessage(passwordLength),
        contains(passwordLength.toString()),
      );
    });
  });
}
