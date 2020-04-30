/// Holds the strings for the login page.
///
/// Preferably, add the string to this file instead of hardcoding them into UI
/// to make them available in tests and avoid code duplication.
class LoginStrings {
  static const String email = 'Email';
  static const String password = 'Password';
  static const String signIn = 'Sign in';

  static const String emailIsRequired = 'Email address is required';
  static const String emailIsInvalid = 'Invalid email address';
  static const String passwordIsRequired = 'Password is required';
  static const String passwordMinLength =
      'Password should be at least 6 characters long';
  static const String unknownErrorMessage =
      'An unknown error occured, please try again';

  static const String wrongPasswordErrorMessage = 'The password is wrong';
  static const String userNotFoundErrorMessage =
      'User with such email not found';
  static const String userDisabledErrorMessage =
      'The user was disabled, please contact support';
  static const String tooManyRequestsErrorMessage =
      'Too many requests. Wait a while and try again';

  static String getLoadingErrorMessage(String errorMessage) =>
      "An error occured during loading: $errorMessage";
}
