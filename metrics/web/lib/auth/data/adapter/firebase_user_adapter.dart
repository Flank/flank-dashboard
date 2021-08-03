// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:metrics/auth/domain/entities/user.dart';

/// Adapts the [FirebaseUser] to match the [User] contract.
class FirebaseUserAdapter implements User {
  final FirebaseUser _firebaseUser;

  @override
  String get email => _firebaseUser.email;

  @override
  String get id => _firebaseUser.uid;

  @override
  bool get isAnonymous => _firebaseUser.isAnonymous;

  /// Creates a [FirebaseUserAdapter] with the given [FirebaseUser].
  FirebaseUserAdapter(this._firebaseUser) {
    ArgumentError.checkNotNull(_firebaseUser, 'firebaseUser');
  }
}
