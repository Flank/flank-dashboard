import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:metrics/auth/data/adapter/firebase_user_adapter.dart';
import 'package:metrics/auth/data/converter/firebase_auth_error_code_converter.dart';
import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/entities/user.dart';
import 'package:metrics/auth/domain/repositories/user_repository.dart';

/// Provides methods for interaction with the [FirebaseAuth].
class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard(scopes: ['email']);

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
      final errorCode = error.code as String;
      final authErrorCode =
          FirebaseAuthErrorCodeConverter.convertErrorStringToErrorCode(
              errorCode);

      throw AuthenticationException(code: authErrorCode);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    Object googleSignInError;
    try {
      final account = await _googleSignIn.signIn().catchError((error) {
        googleSignInError = error;
      });

      final authentication = await account.authentication;

      final credential = GoogleAuthProvider.getCredential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } catch (error) {
      if (googleSignInError != null) {
        throw const AuthenticationException(
          code: AuthErrorCode.googleSignInError,
        );
      }

      final errorCode = error.code as String;
      final authErrorCode =
          FirebaseAuthErrorCodeConverter.convertErrorStringToErrorCode(
              errorCode);

      throw AuthenticationException(code: authErrorCode);
    }
  }

  @override
  Future<void> signOut() async {
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.signOut();
    }
    return _firebaseAuth.signOut();
  }
}
