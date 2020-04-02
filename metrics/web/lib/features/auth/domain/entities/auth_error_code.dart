/// Enum that represents the authentication error code.
enum AuthErrorCode {
  /// Indicates that email is malformed.
  invalidEmail,

  /// Indicates that the password is wrong.
  wrongPassword,

  /// Indicates that there is no user with such email.
  userNotFound,

  /// Indicates that the user was disabled in the console.
  userDisabled,

  /// Indicates that there are was too many attempts to sign in as this user.
  tooManyRequests,

  /// Indicates that an unknown error occurred.
  unknown,
}
