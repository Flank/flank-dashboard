/// Handles authentication exceptions that may occur.
class AuthException implements Exception {
  final String title;
  final String code;
  final String message;

  AuthException({this.title, this.code, this.message});
}
