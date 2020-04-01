/// Holds the strings for the login screen.
///
/// Preferably, add the string to this file instead of hardcoding them into UI
/// to make them available in tests and avoid code duplication.
class LoginStrings {
  static const String email = 'Email';
  static const String password = 'Password';
  static const String signIn = 'Sign in';

  static const emailIsRequired = 'Email address is required';
  static const emailIsInvalid = 'Invalid email address';
  static const passwordIsRequired = 'Password is required';

  static String getLoadingErrorMessage(String errorMessage) =>
      "An error occured during loading: $errorMessage";
}
