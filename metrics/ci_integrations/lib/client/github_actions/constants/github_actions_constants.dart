import 'dart:io';

/// A class that holds general constants related to Github Actions
/// API integration.
class GithubActionsConstants {
  /// The recommended value for the [HttpHeaders.acceptHeader] in Github Actions
  /// API requests.
  static const String acceptHeader = 'application/vnd.github.v3+json';
}
