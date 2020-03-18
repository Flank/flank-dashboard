import 'dart:io';

import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:test/test.dart';

void main() {
  group("BearerAuthorization", () {
    const token = 'token';

    test(
      "should create bearer authorization instance with 'Authorization' header and token with 'Bearer' type",
      () {
        final authorization = BearerAuthorization(token);
        final expected = {HttpHeaders.authorizationHeader: 'Bearer $token'};
        final actual = authorization.toMap();

        expect(actual, equals(expected));
      },
    );
  });
}
