import 'package:metrics/auth/domain/entities/auth_credentials.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/entities/email_domain_validation_result.dart';
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

  /// Provides an ability to get the [AuthCredentials] using the Google sign in.
  ///
  /// Throws an [AuthenticationException] if something went wrong
  /// during receiving the [AuthCredentials].
  Future<AuthCredentials> getGoogleSignInCredentials();

  /// Provides an ability to validate the given user's [emailDomain].
  ///
  /// Throws an [AuthenticationException] if there are any
  /// errors occurred during validation process.
  Future<EmailDomainValidationResult> validateEmailDomain(String emailDomain);

  /// Provides an ability to sign in a user to the app
  /// using Google authentication.
  ///
  /// Throws an [AuthenticationException] if sign in is failed.
  Future<void> signInWithGoogle(AuthCredentials credentials);

  /// Provides an ability to sign out a user.
  Future<void> signOut();
}
