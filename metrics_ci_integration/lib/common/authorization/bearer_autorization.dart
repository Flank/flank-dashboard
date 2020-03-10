part of authorization;

/// A class for the authentication with Bearer token
/// (see [RFC-6750](https://tools.ietf.org/html/rfc6750)).
///
/// Example:
/// ```dart
/// const authorization = BearerAuthorization('token');
/// // prints {authorization: Bearer token}
/// print(authorization.toMap());
/// ```
class BearerAuthorization extends AuthorizationBase {
  const BearerAuthorization(String token)
      : super(HttpHeaders.authorizationHeader, 'Bearer $token');
}
