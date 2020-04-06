import 'package:metrics/features/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/domain/repositories/user_repository.dart';

/// Stub implementation of the [UserRepository] that throws an error
/// on [UserRepository.signInWithEmailAndPassword]
/// and [UserRepository.signOut] methods.
class ErrorUserRepositoryStub implements UserRepository {
  static const authException = AuthenticationException();

  @override
  Stream<User> currentUserStream() {
    throw authException;
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) {
    throw authException;
  }

  @override
  Future<void> signOut() {
    throw authException;
  }
}
