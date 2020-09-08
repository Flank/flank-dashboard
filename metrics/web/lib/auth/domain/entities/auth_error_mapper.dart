import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/presentation/strings/firebase_auth_error_codes.dart';

/// A class that is used to map the Firebase error codes to [AuthErrorCode]
class AuthErrorMapper {
  /// Returns an [AuthErrorCode] that corresponds to the given error code string.
  /// If the corresponding [AuthErrorCode] is not found,
  /// returns the [AuthErrorCode.unknown].
  static AuthErrorCode mapErrorStringToErrorCode({String errorCode}) {
    switch (errorCode) {
      case FirebaseAuthErrorCodes.userNotFound:
        return AuthErrorCode.userNotFound;

      case FirebaseAuthErrorCodes.wrongPassword:
        return AuthErrorCode.wrongPassword;

      case FirebaseAuthErrorCodes.invalidEmail:
        return AuthErrorCode.invalidEmail;

      case FirebaseAuthErrorCodes.tooManyRequests:
        return AuthErrorCode.tooManyRequests;

      case FirebaseAuthErrorCodes.userDisabled:
        return AuthErrorCode.userDisabled;

      default:
        return AuthErrorCode.unknown;
    }
  }
}
