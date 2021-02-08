// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';

/// A class that provides the authentication error description, based on [AuthErrorCode].
class AuthErrorMessage {
  /// An [AuthErrorCode] provides an information about
  /// concrete authentication error.
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
      case AuthErrorCode.googleSignInError:
        return AuthStrings.googleSignInErrorOccurred;
      case AuthErrorCode.notAllowedEmailDomain:
        return AuthStrings.notAllowedEmailDomainErrorMessage;
      default:
        return null;
    }
  }
}
