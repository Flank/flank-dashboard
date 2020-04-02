import 'package:metrics/features/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/features/auth/domain/entities/user.dart';

/// Base class for all user repositories.
///
/// Provides methods for authenticating and getting current user.
abstract class UserRepository {
  /// Provides a stream of current [User].
  Stream<User> currentUserStream();

  /// Provides an ability to sign in user using the [email] amd [password].
  ///
  /// Throws an [AuthenticationException] if sign in is failed.
  Future<void> signInWithEmailAndPassword(String email, String password);

  /// Provides an ability to sign out user.
  Future<void> signOut();
}
