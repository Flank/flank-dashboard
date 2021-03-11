// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/model/firebase_auth_error_code.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping [FirebaseAuthErrorCode]s.
class FirebaseAuthErrorCodeMapper
    implements Mapper<String, FirebaseAuthErrorCode> {
  /// An auth error code indicating that the given Firebase API key is not valid.
  static const String invalidApiKey =
      'API key not valid. Please pass a valid API key.';

  /// An auth error code indicating that the user with the given
  /// email is not found.
  static const String emailNotFound = 'EMAIL_NOT_FOUND';

  /// An auth error code indicating that the given password is invalid.
  static const String invalidPassword = 'INVALID_PASSWORD';

  /// An auth error code indicating that the password sign-in option
  /// is disabled in Firebase.
  static const String passwordLoginDisabled = 'PASSWORD_LOGIN_DISABLED';

  /// Creates a new instance of the [FirebaseAuthErrorCodeMapper].
  const FirebaseAuthErrorCodeMapper();

  @override
  FirebaseAuthErrorCode map(String value) {
    switch (value) {
      case invalidApiKey:
        return FirebaseAuthErrorCode.invalidApiKey;
      case emailNotFound:
        return FirebaseAuthErrorCode.emailNotFound;
      case invalidPassword:
        return FirebaseAuthErrorCode.invalidPassword;
      case passwordLoginDisabled:
        return FirebaseAuthErrorCode.passwordLoginDisabled;
      default:
        return null;
    }
  }

  @override
  String unmap(FirebaseAuthErrorCode value) {
    switch (value) {
      case FirebaseAuthErrorCode.invalidApiKey:
        return invalidApiKey;
      case FirebaseAuthErrorCode.emailNotFound:
        return emailNotFound;
      case FirebaseAuthErrorCode.invalidPassword:
        return invalidPassword;
      case FirebaseAuthErrorCode.passwordLoginDisabled:
        return passwordLoginDisabled;
    }
    return null;
  }
}
