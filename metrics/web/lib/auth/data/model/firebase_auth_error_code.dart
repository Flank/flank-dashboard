/// A class that holds the Firebase authentication error codes.
class FirebaseAuthErrorCode {
  /// An error code that occurs when there is no existing user record
  /// corresponding to the provided identifier.
  static const String userNotFound = "auth/user-not-found";

  /// An error code that occurs when the provided value
  /// for the password user property is invalid.
  static const String wrongPassword = "auth/wrong-password";

  /// An error code that occurs when the provided value
  /// for the email user property is invalid.
  static const String invalidEmail = "auth/invalid-email";

  /// An error code that occurs if the user account has been disabled
  /// by an administrator.
  static const String userDisabled = "auth/user-disabled";

  /// An error code that occurs if there too many requests
  /// were made to a server method.
  static const String tooManyRequests = "auth/too-many-requests";
}
