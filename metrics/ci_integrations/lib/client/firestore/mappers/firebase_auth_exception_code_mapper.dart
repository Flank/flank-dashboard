// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/model/firebase_auth_exception_code.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping [FirebaseAuthExceptionCode]s.
class FirebaseAuthExceptionCodeMapper
    implements Mapper<String, FirebaseAuthExceptionCode> {
  /// An auth exception code indicating that the given Firebase API key
  /// is not valid.
  static const String invalidApiKey =
      'API key not valid. Please pass a valid API key.';

  /// An auth exception code indicating that the user with the given
  /// email is not found.
  static const String emailNotFound = 'EMAIL_NOT_FOUND';

  /// An auth exception code indicating that the given password is invalid.
  static const String invalidPassword = 'INVALID_PASSWORD';

  /// An auth exception code indicating that the password sign-in option
  /// is disabled in Firebase.
  static const String passwordLoginDisabled = 'PASSWORD_LOGIN_DISABLED';

  /// Creates a new instance of the [FirebaseAuthExceptionCodeMapper].
  const FirebaseAuthExceptionCodeMapper();

  @override
  FirebaseAuthExceptionCode map(String value) {
    switch (value) {
      case invalidApiKey:
        return FirebaseAuthExceptionCode.invalidApiKey;
      case emailNotFound:
        return FirebaseAuthExceptionCode.emailNotFound;
      case invalidPassword:
        return FirebaseAuthExceptionCode.invalidPassword;
      case passwordLoginDisabled:
        return FirebaseAuthExceptionCode.passwordLoginDisabled;
      default:
        return null;
    }
  }

  @override
  String unmap(FirebaseAuthExceptionCode value) {
    switch (value) {
      case FirebaseAuthExceptionCode.invalidApiKey:
        return invalidApiKey;
      case FirebaseAuthExceptionCode.emailNotFound:
        return emailNotFound;
      case FirebaseAuthExceptionCode.invalidPassword:
        return invalidPassword;
      case FirebaseAuthExceptionCode.passwordLoginDisabled:
        return passwordLoginDisabled;
    }
    return null;
  }
}
