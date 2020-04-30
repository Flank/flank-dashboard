import 'package:metrics/features/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/features/auth/presentation/strings/auth_strings.dart';

/// A class that provides the authentication error description based on [AuthErrorCode].
class AuthErrorMessage {
  final AuthErrorCode _code;

  /// Creates the [AuthErrorMessage] from the given [AuthErrorCode].
  const AuthErrorMessage(this._code);

  /// Provides an authentication error message based on the [AuthErrorCode].
  String get message {
    switch (_code) {
      case AuthErrorCode.invalidEmail:
        return AuthStrings.invalidEmailErrorMessage;
      case AuthErrorCode.wrongPassword:
        return AuthStrings.wrongPasswordErrorMessage;
      case AuthErrorCode.userNotFound:
        return AuthStrings.userNotFoundErrorMessage;
      case AuthErrorCode.userDisabled:
        return AuthStrings.userDisabledErrorMessage;
      case AuthErrorCode.tooManyRequests:
        return AuthStrings.tooManyRequestsErrorMessage;
      case AuthErrorCode.unknown:
        return AuthStrings.unknownErrorMessage;
      default:
        return null;
    }
  }
}
