// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

/// A class that holds general constants related to HTTP requests and responses.
class HttpConstants {
  /// A default [Map] with headers for HTTP requests.
  static const Map<String, String> defaultHeaders = {
    HttpHeaders.userAgentHeader: null,
  };
}
