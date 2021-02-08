// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// The enum that represents the persistent store error codes.
enum PersistentStoreErrorCode {
  /// Indicates that an error occurred while opening connection
  /// with the persistent store.
  openConnectionFailed,

  /// Indicates that an error occurred while reading from the persistent store.
  readError,

  /// Indicates that an error occurred while updating value in the
  /// persistent store.
  updateError,

  /// Indicates that an error occurred while closing connection
  /// with the persistent store.
  closeConnectionFailed,

  /// Indicates that an unknown error occurred.
  unknown,
}
