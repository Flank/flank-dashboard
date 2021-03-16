// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// An enum that represents a Firestore exception reason.
enum FirestoreExceptionReason {
  /// Indicates that the provided Firebase project identifier is not valid
  /// or does not exist.
  consumerInvalid,

  /// Indicates that the provided Firebase with the given project identifier
  /// is not found.
  notFound,

  /// Indicates that the provided Firebase with the given project identifier
  /// is deleted.
  projectDeleted,

  /// Indicates that the given Firebase project identifier does not represent
  /// a valid one.
  projectInvalid,
}
