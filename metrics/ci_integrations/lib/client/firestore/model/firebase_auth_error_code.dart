// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// Represents a Firebase error code.
enum FirebaseAuthErrorCode {
  /// Indicates whether the Firebase API key is not valid.
  invalidApiKey,

  /// Indicates whether the user with such email is not found.
  emailNotFound,

  /// Indicates whether the password is invalid.
  invalidPassword,

  /// Indicates whether the password sign-in option is disabled.
  passwordLoginDisabled,
}
