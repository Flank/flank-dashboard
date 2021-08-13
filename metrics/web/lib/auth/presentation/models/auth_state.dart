// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// Represents an auth state of the user.
enum AuthState {
  /// Represents the logged in user state.
  loggedIn,

  /// Represents the logged in anonymously user state.
  loggedInAnonymously,

  /// Represents the logged out user state.
  loggedOut,
}
