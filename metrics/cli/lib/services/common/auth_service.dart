// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A base class for services that support authentication. Provides common
/// methods for handling the authentication.
abstract class AuthService {
  /// Initializes the given [auth] for this service.
  void initializeAuth(String auth);

  /// Resets the current authentication for this service.
  void resetAuth();
}
