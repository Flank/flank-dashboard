/// Holds the strings for the authentication module.
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
