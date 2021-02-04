// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:firedart/firedart.dart' as fd;

/// A Firestore wrapper class providing an access to the project id
/// and the Firebase Authentication client.
class Firestore extends fd.Firestore {
  /// The Firestore project id.
  final String projectId;

  /// The Firebase Authentication client.
  final fd.FirebaseAuth firebaseAuth;

  /// Creates an instance of this Firestore wrapper with the given [projectId].
  ///
  /// Can be created with an optional [firebaseAuth] to allow
  /// user identity verification.
  Firestore(
    this.projectId, {
    this.firebaseAuth,
  }) : super(
          projectId,
          auth: firebaseAuth,
        );
}
