import 'package:metrics/features/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/features/auth/presentation/strings/login_strings.dart';

/// A class that provides the authentication error description based on [AuthErrorCode].
class AuthErrorMessage {
  final AuthErrorCode _code;

  /// Creates the [AuthErrorMessage] from the given [AuthErrorCode].
  const AuthErrorMessage(this._code);

  /// Provides an authentication error message based on the [AuthErrorCode].
  String get message {
    switch (_code) {
      case AuthErrorCode.invalidEmail:
        return LoginStrings.invalidEmailErrorMessage;
      case AuthErrorCode.wrongPassword:
        return LoginStrings.wrongPasswordErrorMessage;
      case AuthErrorCode.userNotFound:
        return LoginStrings.userNotFoundErrorMessage;
      case AuthErrorCode.userDisabled:
        return LoginStrings.userDisabledErrorMessage;
      case AuthErrorCode.tooManyRequests:
        return LoginStrings.tooManyRequestsErrorMessage;
      case AuthErrorCode.unknown:
        return LoginStrings.unknownErrorMessage;
      default:
        return null;
    }
  }
}
