// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/data/model/firebase_auth_error_code.dart';
import 'package:metrics/auth/domain/entities/auth_error_code.dart';

/// A class that converts the the Firebase Authentication error code
/// to the corresponding [AuthErrorCode].
class FirebaseAuthErrorCodeConverter {
  /// Returns the corresponding [AuthErrorCode] to the given Firebase [errorCode].
  /// If the corresponding [AuthErrorCode] is not found,
  /// returns [AuthErrorCode.unknown].
  static AuthErrorCode convert(String errorCode) {
    switch (errorCode) {
      case FirebaseAuthErrorCode.userNotFound:
        return AuthErrorCode.userNotFound;

      case FirebaseAuthErrorCode.wrongPassword:
        return AuthErrorCode.wrongPassword;

      case FirebaseAuthErrorCode.invalidEmail:
        return AuthErrorCode.invalidEmail;

      case FirebaseAuthErrorCode.tooManyRequests:
        return AuthErrorCode.tooManyRequests;

      case FirebaseAuthErrorCode.userDisabled:
        return AuthErrorCode.userDisabled;

      default:
        return AuthErrorCode.unknown;
    }
  }
}
