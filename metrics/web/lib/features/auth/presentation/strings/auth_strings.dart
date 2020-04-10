/// Preferably, add the string to this file instead of hardcoding them into UI
/// to make them available in tests and avoid code duplication.
class AuthStrings {
  static const String email = 'Email';
  static const String password = 'Password';
  static const String signIn = 'Sign in';

  static const String emailIsRequired = 'Email address is required';
  static const String emailIsInvalid = 'Invalid email address';
  static const String passwordIsRequired = 'Password is required';
  static String getPasswordMinLengthErrorMessage(int minLength) =>
      "Password should be at least $minLength characters long";
}
