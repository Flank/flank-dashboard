import 'package:flutter/cupertino.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:test/test.dart';

/// A utility class providing base matchers for tests.
class MatcherUtil {
  /// A matcher that can be used to detect that test case throws
  /// an [AssertionError].
  static final Matcher throwsAssertionError = throwsA(isA<AssertionError>());

  /// A matcher that can be used to detect that test case throws
  /// an [AuthenticationException].
  static final Matcher throwsAuthenticationException =
      throwsA(isA<AuthenticationException>());

  /// A matcher that can be used to match named routes in test cases.
  static Matcher namedRoute(String routeName) => isA<Route>().having(
        (route) => route?.settings?.name,
        'route name',
        equals(routeName),
      );
}
