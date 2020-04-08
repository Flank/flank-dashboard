import 'package:firebase_auth/firebase_auth.dart';
import 'package:metrics/features/auth/data/adapter/firebase_user_adapter.dart';
import 'package:metrics/features/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/features/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/domain/repositories/user_repository.dart';

/// Provides methods for interaction with the [FirebaseAuth].
class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User> authenticationStream() {
    return _firebaseAuth.onAuthStateChanged
        .map((user) => user != null ? FirebaseUserAdapter(user) : null);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      throw const AuthenticationException(code: AuthErrorCode.unknown);
    }
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
