import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

void main() {
  group("ApiKeyAuthorization", () {
    const key = 'key';
    const value = 'value';

    test(
      "creates api key authorization instance with a key as a header and a value as a token",
      () {
        final authorization = ApiKeyAuthorization(key, value);
        final expected = {key: value};
        final actual = authorization.toMap();

        expect(actual, equals(expected));
      },
    );
  });
}
