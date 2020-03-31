import 'package:api_mock_server/api_mock_server.dart';

/// A path matcher that checks paths using the [RegExp] provided.
class RegExpPathMatcher extends PathMatcher {
  /// The regular expression for the desired path and query parameters pattern.
  final RegExp pattern;

  /// Creates an instance of this path matcher with the given [pattern].
  ///
  /// Throws [ArgumentError] if [pattern] is null.
  RegExpPathMatcher(this.pattern) {
    ArgumentError.checkNotNull(pattern, 'pattern');
  }

  @override
  bool match(String path) {
    return pattern.stringMatch(path) == path;
  }
}
