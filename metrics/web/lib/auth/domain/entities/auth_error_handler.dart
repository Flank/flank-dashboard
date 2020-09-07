import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/presentation/strings/auth_error_code_strings.dart';

/// A class that is used to handle the errors that occur at the time
/// of the authentication.
class AuthErrorHandler {
  /// Returns an [AuthErrorCode] that corresponds to the given error code string.
  /// If the corresponding [AuthErrorCode] is not found,
  /// the [AuthErrorCode.unknown] is returned.
  static AuthErrorCode handleError({String errorCode}) {
    switch (errorCode) {
      case AuthErrorCodeStrings.userNotFound:
        return AuthErrorCode.userNotFound;

      case AuthErrorCodeStrings.wrongPassword:
        return AuthErrorCode.wrongPassword;

      case AuthErrorCodeStrings.invalidEmail:
        return AuthErrorCode.invalidEmail;

      case AuthErrorCodeStrings.tooManyRequests:
        return AuthErrorCode.tooManyRequests;

      case AuthErrorCodeStrings.userDisabled:
        return AuthErrorCode.userDisabled;

      default:
        return AuthErrorCode.unknown;
    }
  }
}
