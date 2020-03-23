import 'package:test/test.dart';

class MatcherUtil {
  static final Matcher throwsAssertionError = throwsA(isA<AssertionError>());
}
