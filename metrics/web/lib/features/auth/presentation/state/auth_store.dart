import 'dart:async';

import 'package:metrics/features/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/features/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/features/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:metrics/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:metrics/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:metrics/features/auth/presentation/model/auth_error_message.dart';
import 'package:rxdart/rxdart.dart';

/// The auth store for a user.
///
/// Stores [_isLoggedInSubject] stream to determine user's authentication status.
/// Provides the ability to sign in and sign out user from the app,
/// track the [isLoggedIn] status and authentication error message if any
class AuthStore {
  /// Used to receive authentication updates.
  final ReceiveAuthenticationUpdates _receiveAuthUpdates;

  /// Used to sign in a user.
  final SignInUseCase _signInUseCase;

  /// Used to sign out a user.
  final SignOutUseCase _signOutUseCase;

  /// Stream that contains a user's authentication status.
  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  StreamSubscription _authUpdatesSubscription;

  /// Contains text description of any authentication exception that may occur.
  AuthErrorMessage _authExceptionDescription;

  AuthStore(
    this._receiveAuthUpdates,
    this._signInUseCase,
    this._signOutUseCase,
  )   : assert(_receiveAuthUpdates != null),
        assert(_signInUseCase != null),
        assert(_signOutUseCase != null);

  /// Returns a stream of a user's authentication status.
  Stream<bool> get loggedInStream => _isLoggedInSubject.stream;

  /// Determines if a user is authenticated.
  bool get isLoggedIn => _isLoggedInSubject.value;

  /// Returns a string, containing an auth error message.
  AuthErrorMessage get authErrorMessage => _authExceptionDescription;

  /// Subscribes to a user authentication updates
  /// to get notified when the user got signed in or signed out.
  void subscribeToAuthenticationUpdates() {
    _authUpdatesSubscription?.cancel();
    _authUpdatesSubscription = _receiveAuthUpdates().listen(
      (user) => _isLoggedInSubject.add(user != null),
    );
  }

  /// Signs in user to the app using an [email] and a [password].
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _authExceptionDescription = null;

    try {
      await _signInUseCase(UserCredentialsParam(
        email: email,
        password: password,
      ));
    } on AuthenticationException catch (exception) {
      _authExceptionDescription = AuthErrorMessage(exception.code);
    }
  }

  /// Signs out the user from the app.
  Future<void> signOut() async {
    await _signOutUseCase();
  }

  /// Cancels all created subscriptions.
  void dispose() {
    _authUpdatesSubscription?.cancel();
    _isLoggedInSubject.close();
  }
}
