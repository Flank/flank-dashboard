// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/model/firebase_error_code.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping [FirebaseErrorCode]s.
class FirebaseAuthErrorCodeMapper implements Mapper<String, FirebaseErrorCode> {
  /// An auth error code indicating that the Firebase API key is invalid.
  static const String invalidApiKey =
      'API key not valid. Please pass a valid API key.';

  /// An auth error code indicating that the email with the given
  /// email is not found.
  static const String emailNotFound = 'EMAIL_NOT_FOUND';

  /// An auth error code indicating that the password is invalid.
  static const String invalidPassword = 'INVALID_PASSWORD';

  /// An auth error code indicating that the password sign-in option
  /// is disabled in Firebase.
  static const String passwordLoginDisabled = 'PASSWORD_LOGIN_DISABLED';

  /// Creates a new instance of the [FirebaseAuthErrorCodeMapper].
  const FirebaseAuthErrorCodeMapper();

  @override
  FirebaseErrorCode map(String value) {
    switch (value) {
      case invalidApiKey:
        return FirebaseErrorCode.invalidApiKey;
      case emailNotFound:
        return FirebaseErrorCode.emailNotFound;
      case invalidPassword:
        return FirebaseErrorCode.invalidPassword;
      case passwordLoginDisabled:
        return FirebaseErrorCode.passwordLoginDisabled;
      default:
        return null;
    }
  }

  @override
  String unmap(FirebaseErrorCode value) {
    switch (value) {
      case FirebaseErrorCode.invalidApiKey:
        return invalidApiKey;
      case FirebaseErrorCode.emailNotFound:
        return emailNotFound;
      case FirebaseErrorCode.invalidPassword:
        return invalidPassword;
      case FirebaseErrorCode.passwordLoginDisabled:
        return passwordLoginDisabled;
    }
    return null;
  }
}
