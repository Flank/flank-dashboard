import 'package:meta/meta.dart';

/// An [AuthCredentials] used to authentication.
@immutable
class AuthCredentials {
  /// The user's email address.
  final String email;

  /// The OAuth access token.
  final String accessToken;

  /// The ID Token associated with this auth credential.
  final String idToken;

  /// Creates an instance of the [AuthCredentials] with
  /// the given [email], [accessToken] and [idToken].
  ///
  /// Throws an [ArgumentError] if either the [email], [accessToken]
  /// or [idToken] is `null`.
  AuthCredentials({
    this.email,
    this.accessToken,
    this.idToken,
  }) {
    ArgumentError.checkNotNull(email, 'email');
    ArgumentError.checkNotNull(accessToken, 'accessToken');
    ArgumentError.checkNotNull(idToken, 'idToken');
  }
}
