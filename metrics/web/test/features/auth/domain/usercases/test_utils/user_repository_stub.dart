import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/domain/repositories/user_repository.dart';

/// Stub implementation of the [UserRepository].
///
/// Provides test implementation of the [UserRepository] methods.
class UserRepositoryStub implements UserRepository {
  bool _isSignInCalled = false;
  bool _isSignOutCalled = false;
  bool _isCurrentUserStreamCalled = false;

  bool get isSignInCalled => _isSignInCalled;

  bool get isSignOutCalled => _isSignOutCalled;

  bool get isCurrentUserStreamCalled => _isCurrentUserStreamCalled;

  UserRepositoryStub();

  @override
  Stream<User> currentUserStream() {
    _isCurrentUserStreamCalled = true;
    return const Stream<User>.empty();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _isSignInCalled = true;
  }

  @override
  Future<void> signOut() async {
    _isSignOutCalled = true;
  }
}
