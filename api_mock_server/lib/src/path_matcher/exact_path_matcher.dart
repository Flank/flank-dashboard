// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:api_mock_server/api_mock_server.dart';

/// A path matcher for exact path patterns.
class ExactPathMatcher extends PathMatcher {
  /// The exact desired path and query parameters pattern.
  final String pattern;

  /// Creates an instance of this path matcher with the given [pattern].
  ///
  /// Throws [ArgumentError] if [pattern] is null.
  ExactPathMatcher(this.pattern) {
    ArgumentError.checkNotNull(pattern, 'pattern');
  }

  @override
  bool match(String path) {
    return pattern == path;
  }
}
