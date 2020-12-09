import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/common/presentation/routes/metrics_page_route.dart';
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
  static Matcher metricsNamedRoute(Matcher routeName) {
    return isA<MetricsPageRoute>().having(
      (route) => route?.settings?.name,
      'route name',
      routeName,
    );
  }
}
