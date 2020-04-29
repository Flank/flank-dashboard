import 'dart:convert';
import 'dart:io';

import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

void main() {
  group("BasicAuthorization", () {
    const username = 'username';
    const password = 'password';
    final token = base64Encode(utf8.encode('$username:$password'));

    test(
      "should create basic authorization instance with 'Authorization' header and token with 'Basic' type",
      () {
        final authorization = BasicAuthorization(username, password);
        final expected = {HttpHeaders.authorizationHeader: 'Basic $token'};
        final actual = authorization.toMap();

        expect(actual, equals(expected));
      },
    );

    test(
      ".encode() should base64 encode string with username and password",
      () {
        final encoded = BasicAuthorization.encode(username, password);

        expect(encoded, equals(token));
      },
    );

    test(
      ".encode() should consider null username as empty",
      () {
        final encoded = BasicAuthorization.encode(null, password);
        final expected = base64Encode(utf8.encode(':$password'));

        expect(encoded, equals(expected));
      },
    );

    test(
      ".encode() should consider null password as empty",
      () {
        final encoded = BasicAuthorization.encode(username, null);
        final expected = base64Encode(utf8.encode('$username:'));

        expect(encoded, equals(expected));
      },
    );
  });
}
