import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:metrics/auth/domain/usecases/sign_in_usecase.dart';
import 'package:metrics/auth/domain/usecases/sign_out_usecase.dart';
import 'package:metrics/auth/presentation/model/auth_error_message.dart';

/// The [ChangeNotifier] that holds the authentication state.
///
/// Provides the ability to sign in and sign out user from the app,
/// track the [isLoggedIn] status and authentication error message if any
class AuthNotifier extends ChangeNotifier {
  /// Used to receive authentication updates.
  final ReceiveAuthenticationUpdates _receiveAuthUpdates;

  /// Used to sign in a user.
  final SignInUseCase _signInUseCase;

  /// Used to sign out a user.
  final SignOutUseCase _signOutUseCase;

  /// Contains a user's authentication status.
  bool _isLoggedIn;

  /// The stream subscription needed to be able to unsubscribe
  /// from authentication state updates.
  StreamSubscription _authUpdatesSubscription;

  /// Contains text description of any authentication exception that may occur.
  AuthErrorMessage _authExceptionDescription;

  AuthNotifier(
    this._receiveAuthUpdates,
    this._signInUseCase,
    this._signOutUseCase,
  )   : assert(_receiveAuthUpdates != null),
        assert(_signInUseCase != null),
        assert(_signOutUseCase != null);

  /// Determines if a user is authenticated.
  bool get isLoggedIn => _isLoggedIn;

  /// Returns an AuthErrorMessage, containing an auth error message.
  AuthErrorMessage get authErrorMessage => _authExceptionDescription;

  /// Subscribes to a user authentication updates
  /// to get notified when the user got signed in or signed out.
  void subscribeToAuthenticationUpdates() {
    _authUpdatesSubscription?.cancel();
    _authUpdatesSubscription = _receiveAuthUpdates().listen((user) {
      _isLoggedIn = user != null;
      notifyListeners();
    });
  }

  /// Signs in user to the app using an [email] and a [password].
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _authExceptionDescription = null;
    notifyListeners();

    try {
      await _signInUseCase(UserCredentialsParam(
        email: email,
        password: password,
      ));
    } on AuthenticationException catch (exception) {
      _authExceptionDescription = AuthErrorMessage(exception.code);
      notifyListeners();
    }
  }

  /// Signs out the user from the app.
  Future<void> signOut() async {
    await _signOutUseCase();
  }

  @override
  void dispose() {
    _authUpdatesSubscription?.cancel();
    super.dispose();
  }
}
