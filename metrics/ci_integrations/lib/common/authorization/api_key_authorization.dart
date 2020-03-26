part of authorization;

/// A class for the API Key authorization.
///
/// This authorization stands for the case if it is required to put a token to
/// the custom header instead of [HttpHeaders.authorizationHeader].
///
/// Example:
/// ```dart
/// final authorization = ApiKeyAuthorization('x-some-api-header', 'token');
/// // prints {x-some-api-header: token}
/// print(authorization.toMap());
/// ```
class ApiKeyAuthorization extends AuthorizationBase {
  ApiKeyAuthorization(String key, String value) : super(key, value);
}
