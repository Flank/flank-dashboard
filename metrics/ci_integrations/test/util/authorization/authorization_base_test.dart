// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

void main() {
  group("AuthorizationBase", () {
    const header = 'header';
    const token = 'token';

    test(
      ".toMap() includes provided header and token as a key and value respectively",
      () {
        final authorization = AuthorizationBaseTestbed(header, token);
        final expected = {header: token};
        final actual = authorization.toMap();

        expect(actual, equals(expected));
      },
    );

    test(
      "throws an ArgumentError if the given header is null",
      () {
        expect(
          () => AuthorizationBaseTestbed(null, token),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given header is empty",
      () {
        expect(
          () => AuthorizationBaseTestbed('', token),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given token is null",
      () {
        expect(
          () => AuthorizationBaseTestbed(header, null),
          throwsArgumentError,
        );
      },
    );
  });
}

/// A testbed class for testing [AuthorizationBase] constructor and non-virtual
/// methods directly.
class AuthorizationBaseTestbed extends AuthorizationBase {
  AuthorizationBaseTestbed(String httpHeader, String token)
      : super(httpHeader, token);
}
