import 'dart:io';

import 'package:meta/meta.dart';

/// A class representing credentials for authorized HTTP requests.
///
/// Instances of [ApiMockServer] use this class to provide valid authorization
/// data for requests to be verified.
class AuthCredentials {
  /// A header name for authorization data.
  ///
  /// Defaults to the [HttpHeaders.authorizationHeader].
  final String header;

  /// A value for the authorization header provided.
  final String token;

  const AuthCredentials({
    @required this.token,
    this.header = HttpHeaders.authorizationHeader,
  });

  /// A verification method for the instance of [HttpHeaders].
  ///
  /// Returns `true` if [headers] contains header with [header] name
  /// with [token] value. Otherwise, returns `false`.
  bool verify(HttpHeaders headers) {
    return headers.value(header) == token;
  }
}
