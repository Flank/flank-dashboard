// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

/// A class that holds general constants related to Github Actions
/// API integration.
class GithubActionsConstants {
  /// A default URL for Github API to perform HTTP requests to.
  static const String githubApiUrl = 'https://api.github.com';

  /// A recommended value for the [HttpHeaders.acceptHeader] in Github Actions
  /// API requests.
  static const String acceptHeader = 'application/vnd.github.v3+json';
}
