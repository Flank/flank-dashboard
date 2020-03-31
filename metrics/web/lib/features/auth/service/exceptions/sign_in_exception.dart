class SignInException extends Error {
  final String title;
  final String code;
  final String message;

  SignInException({this.title, this.code, this.message});
}
