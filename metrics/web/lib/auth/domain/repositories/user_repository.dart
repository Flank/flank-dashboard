import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/entities/user.dart';

/// A base class for all user repositories.
///
/// Provides methods for authenticating and getting the stream
/// of the current user.
abstract class UserRepository {
  /// Provides a stream of the authentication status
  /// returning [User] if authenticated, null otherwise.
  Stream<User> authenticationStream();

  /// Provides an ability to sign in a user using the [email] and [password].
  ///
  /// Throws an [AuthenticationException] if sign in is failed.
  Future<void> signInWithEmailAndPassword(String email, String password);

  /// Provides an ability to sign in a user to the app
  /// using Google authentication.
  ///
  /// Throws an [AuthenticationException] if sign in is failed.
  Future<void> signInWithGoogle();

  /// Provides an ability to sign out a user.
  Future<void> signOut();
}
