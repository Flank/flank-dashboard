// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:api_mock_server/api_mock_server.dart';

/// An abstract class representing a path matcher for the [RequestHandler].
abstract class PathMatcher {
  /// Checks whether the given [path] matches this path matcher.
  bool match(String path);
}
