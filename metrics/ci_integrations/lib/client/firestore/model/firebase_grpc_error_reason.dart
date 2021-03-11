// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// Represents a Firebase gRPC error reason.
enum FirebaseGrpcErrorReason {
  /// Indicates whether the provided Firebase project ID is not valid
  /// or does not exist.
  consumerInvalid,

  /// Indicates whether the provided Firebase with the given project ID
  /// is not found.
  notFound,
}
