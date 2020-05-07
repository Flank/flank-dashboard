/// Holds the strings for the authentication module.
class AuthStrings {
  static const String email = 'Email';
  static const String password = 'Password';
  static const String signIn = 'Sign in';

  static const String requiredEmailErrorMessage = 'Email address is required';
  static const String invalidEmailErrorMessage = 'Invalid email address';
  static const String requiredPasswordErrorMessage = 'Password is required';
  static const String unknownErrorMessage =
      'An unknown error occured, please try again';

  static const String wrongPasswordErrorMessage = 'The password is wrong';
  static const String userNotFoundErrorMessage =
      'User with such email not found';
  static const String userDisabledErrorMessage =
      'The user was disabled, please contact support';
  static const String tooManyRequestsErrorMessage =
      'Too many requests. Please wait and try your request again later';

  static String getPasswordMinLengthErrorMessage(int minLength) =>
      "Password should be at least $minLength characters long";

  static String getLoadingErrorMessage(String errorMessage) =>
      "An error occured during loading: $errorMessage";
}
