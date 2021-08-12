// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// Represents an auth state of user.
enum AuthState {
  /// Represents logged-in user state.
  loggedIn,

  /// Represents logged-in anonymously user state.
  loggedInAnonymously,

  /// Represents logged-out user state.
  loggedOut,
}
