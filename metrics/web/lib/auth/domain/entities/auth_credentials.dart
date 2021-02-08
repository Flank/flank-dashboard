// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';

/// An entity representing the credentials used to authenticate a user.
@immutable
class AuthCredentials {
  /// An email address of a user.
  final String email;

  /// An OAuth access token.
  final String accessToken;

  /// An ID Token associated with this auth credential.
  final String idToken;

  /// Creates an instance of the [AuthCredentials] with
  /// the given [email], [accessToken] and [idToken].
  ///
  /// Throws an [ArgumentError] if either the [email], [accessToken]
  /// or [idToken] is `null`.
  AuthCredentials({
    @required this.email,
    @required this.accessToken,
    @required this.idToken,
  }) {
    ArgumentError.checkNotNull(email, 'email');
    ArgumentError.checkNotNull(accessToken, 'accessToken');
    ArgumentError.checkNotNull(idToken, 'idToken');
  }
}
