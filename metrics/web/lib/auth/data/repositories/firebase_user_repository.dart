import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:metrics/auth/data/adapter/firebase_user_adapter.dart';
import 'package:metrics/auth/data/converter/firebase_auth_error_code_converter.dart';
import 'package:metrics/auth/data/model/email_domain_validation_request_data.dart';
import 'package:metrics/auth/data/model/email_domain_validation_result_data.dart';
import 'package:metrics/auth/domain/entities/auth_credentials.dart';
import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/entities/email_domain_validation_result.dart';
import 'package:metrics/auth/domain/entities/user.dart';
import 'package:metrics/auth/domain/repositories/user_repository.dart';

/// Provides methods for interaction with the [FirebaseAuth].
class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard(scopes: ['email']);
  final _cloudFunctions = CloudFunctions.instance;

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
      final authErrorCode = FirebaseAuthErrorCodeConverter.convert(errorCode);

      throw AuthenticationException(code: authErrorCode);
    }
  }

  @override
  Future<AuthCredentials> getGoogleSignInCredentials() async {
    Object googleSignInError;
    try {
      final account = await _googleSignIn.signIn().catchError((error) {
        googleSignInError = error;
      });
      final authentication = await account.authentication;

      return AuthCredentials(
        email: account.email,
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );
    } catch (error) {
      if (googleSignInError != null) {
        throw const AuthenticationException(
          code: AuthErrorCode.googleSignInError,
        );
      }
      final errorCode = error.code as String;
      final authErrorCode = FirebaseAuthErrorCodeConverter.convert(errorCode);

      throw AuthenticationException(code: authErrorCode);
    }
  }

  @override
  Future<EmailDomainValidationResult> validateEmailDomain(
    String emailDomain,
  ) async {
    final requestData = EmailDomainValidationRequestData(
      emailDomain: emailDomain,
    );

    final validateEmailDomain = _cloudFunctions.getHttpsCallable(
      functionName: 'validateEmailDomain',
    );

    try {
      final response = await validateEmailDomain.call(requestData.toJson());
      final responseData = response.data as Map<String, dynamic>;

      return EmailDomainValidationResultData.fromJson(responseData);
    } catch (error) {
      throw const AuthenticationException(code: AuthErrorCode.unknown);
    }
  }

  @override
  Future<void> signInWithGoogle(AuthCredentials credentials) async {
    try {
      final credential = GoogleAuthProvider.getCredential(
        accessToken: credentials.accessToken,
        idToken: credentials.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } catch (error) {
      final errorCode = error.code as String;
      final authErrorCode = FirebaseAuthErrorCodeConverter.convert(errorCode);

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
