// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/firestore.dart';
import 'package:firedart/firedart.dart' as fd;

/// A factory class that provides a method for creating a new instance of
/// the [Firestore].
class FirestoreFactory {
  /// Creates a new instance of the [FirestoreFactory].
  const FirestoreFactory();

  /// Creates a new instance of the [Firestore] with the given
  /// [firebaseProjectId] and [firebaseAuth].
  ///
  /// Throws an [ArgumentError] if the given [firebaseProjectId]
  /// or [firebaseAuth] is `null`.
  Firestore create(
    String firebaseProjectId,
    fd.FirebaseAuth firebaseAuth,
  ) {
    ArgumentError.checkNotNull(firebaseProjectId, 'firebaseProjectId');
    ArgumentError.checkNotNull(firebaseAuth, 'firebaseAuth');

    return Firestore(
      firebaseProjectId,
      firebaseAuth: firebaseAuth,
    );
  }
}
