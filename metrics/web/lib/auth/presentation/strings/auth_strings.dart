// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// Holds the strings for the authentication module.
class AuthStrings {
  static const String email = 'Email address';
  static const String password = 'Password';
  static const String signIn = 'Sign in';
  static const String signInWithGoogle = 'Sign in with Google';

  static const String emailRequiredErrorMessage = 'Email address is required';
  static const String invalidEmailErrorMessage = 'Invalid email address';
  static const String passwordRequiredErrorMessage = 'Password is required';
  static const String unknownErrorMessage =
      'An unknown error occurred, please try again';

  static const String wrongPasswordErrorMessage = 'The password is wrong';
  static const String userNotFoundErrorMessage =
      'User with such email not found';
  static const String userDisabledErrorMessage =
      'The user was disabled, please contact support';
  static const String tooManyRequestsErrorMessage =
      'Too many requests. Please wait and try your request again later';
  static const String googleSignInErrorOccurred =
      'An error occurred while signing in with Google';
  static const String notAllowedEmailDomainErrorMessage =
      'Your email domain is not allowed. Please contact the Site Administrator if you need to have access.';

  static String getPasswordMinLengthErrorMessage(int minLength) =>
      'Password should be at least $minLength characters long';
}
