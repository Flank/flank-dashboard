class SignOutException extends Error {
  final String title;
  final String code;
  final String message;

  SignOutException({this.title, this.code, this.message});
}
