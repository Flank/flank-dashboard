// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:meta/meta.dart';

/// A class representing credentials for authorized HTTP requests.
///
/// Instances of [ApiMockServer] use this class to provide valid authorization
/// data for requests to be verified.
class AuthCredentials {
  /// A header name for authorization data.
  final String header;

  /// A value for the authorization header provided.
  final String token;

  /// Creates credentials instance with the given [token].
  ///
  /// A [token] is required.
  /// A [header] defaults to the [HttpHeaders.authorizationHeader].
  const AuthCredentials({
    @required this.token,
    this.header = HttpHeaders.authorizationHeader,
  });
}
