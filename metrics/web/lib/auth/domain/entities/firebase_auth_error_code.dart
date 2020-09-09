import 'package:metrics/auth/domain/entities/auth_error_code.dart';

/// A class that holds the Firebase authentication error code and
/// converts the [errorCode] to the corresponding [AuthErrorCode].
class FirebaseAuthErrorCode {
  /// Represents the given Firebase auth error code.
  final String errorCode;

  static const String _userNotFound = "auth/user-not-found";
  static const String _wrongPassword = "auth/wrong-password";
  static const String _invalidEmail = "auth/invalid-email";
  static const String _userDisabled = "auth/user-disabled";
  static const String _tooManyRequests = "auth/too-many-requests";

  /// Creates a new [FirebaseAuthErrorCode] instance with the given error string.
  FirebaseAuthErrorCode(this.errorCode);

  /// Returns the corresponding [AuthErrorCode] to the given Firebase error code.
  /// If the corresponding [AuthErrorCode] is not found,
  /// returns [AuthErrorCode.unknown].
  AuthErrorCode toAuthErrorCode() {
    switch (errorCode) {
      case _userNotFound:
        return AuthErrorCode.userNotFound;

      case _wrongPassword:
        return AuthErrorCode.wrongPassword;

      case _invalidEmail:
        return AuthErrorCode.invalidEmail;

      case _tooManyRequests:
        return AuthErrorCode.tooManyRequests;

      case _userDisabled:
        return AuthErrorCode.userDisabled;

      default:
        return AuthErrorCode.unknown;
    }
  }
}
