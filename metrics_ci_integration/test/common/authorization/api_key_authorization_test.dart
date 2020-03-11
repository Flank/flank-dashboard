import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:test/test.dart';

void main() {
  group('ApiKeyAuthorization', () {
    const key = 'key';
    const value = 'value';

    test(
      'should create api key authorization instance with a key as a header '
      'and a value as a token',
      () {
        final authorization = ApiKeyAuthorization(key, value);
        final expected = {key: value};
        final actual = authorization.toMap();

        expect(actual, equals(expected));
      },
    );
  });
}
