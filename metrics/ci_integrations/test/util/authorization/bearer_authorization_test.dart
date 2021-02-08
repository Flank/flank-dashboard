// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

void main() {
  group("BearerAuthorization", () {
    const token = 'token';

    test(
      "creates bearer authorization instance with 'Authorization' header and token with 'Bearer' type",
      () {
        final authorization = BearerAuthorization(token);
        final expected = {HttpHeaders.authorizationHeader: 'Bearer $token'};
        final actual = authorization.toMap();

        expect(actual, equals(expected));
      },
    );
  });
}
