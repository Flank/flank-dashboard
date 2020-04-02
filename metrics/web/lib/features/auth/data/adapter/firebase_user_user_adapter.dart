import 'package:firebase_auth/firebase_auth.dart';
import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/domain/repositories/user_repository.dart';

/// Adapts the [FirebaseUser] to match the [UserRepository] contract.
class FirebaseUserUserAdapter {
  /// Creates the [User] instance from the given [firebaseUser].
  static User adapt(FirebaseUser firebaseUser) {
    if (firebaseUser == null) return null;

    return User(email: firebaseUser.email, id: firebaseUser.uid);
  }
}
