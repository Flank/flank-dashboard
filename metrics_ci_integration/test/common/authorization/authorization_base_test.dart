import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:test/test.dart';

void main() {
  group('AuthorizationBase', () {
    const header = 'header';
    const token = 'token';

    test(
      'toMap() should include provided header and token as a key and '
      'value respectively',
      () {
        final authorization = AuthorizationBaseTestbed(header, token);
        final expected = {header: token};
        final actual = authorization.toMap();

        expect(actual, equals(expected));
      },
    );

    test(
      'should throw ArgumentError creating a new instance with null header',
      () {
        expect(
          () => AuthorizationBaseTestbed(null, token),
          throwsArgumentError,
        );
      },
    );

    test(
      'should throw ArgumentError creating a new instance with empty header',
      () {
        expect(
          () => AuthorizationBaseTestbed('', token),
          throwsArgumentError,
        );
      },
    );

    test(
      'should throw ArgumentError creating a new instance with null token',
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
