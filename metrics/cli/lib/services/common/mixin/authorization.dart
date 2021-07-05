// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A mixin that provides common methods for setting the authorization up.
mixin Authorization {
  /// Initializes the given [authorization] for this service.
  void initializeAuthorization(String authorization);

  /// Resets this service current authorization.
  void resetAuthorization();
}
