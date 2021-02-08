// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// Enum that represents the authentication error code.
enum AuthErrorCode {
  /// Indicates that email is malformed.
  invalidEmail,

  /// Indicates that the password is wrong.
  wrongPassword,

  /// Indicates that the user is not found.
  userNotFound,

  /// Indicates that the user was disabled in the console.
  userDisabled,

  /// Indicates that there are was too many attempts to sign in as this user.
  tooManyRequests,

  /// Indicates that an error has occurred while signing in with Google.
  googleSignInError,

  /// Indicates that the domain of the given email is not allowed.
  notAllowedEmailDomain,

  /// Indicates that an unknown error occurred.
  unknown,
}
