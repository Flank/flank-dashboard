import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:metrics/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:metrics/auth/domain/usecases/sign_in_usecase.dart';
import 'package:metrics/auth/domain/usecases/sign_out_usecase.dart';
import 'package:metrics/auth/presentation/models/auth_error_message.dart';
import 'package:metrics_core/metrics_core.dart';

/// The [ChangeNotifier] that holds the authentication state.
///
/// Provides the ability to sign in and sign out user from the app,
/// track the [isLoggedIn] status and authentication error message if any.
class AuthNotifier extends ChangeNotifier {
  /// A [List] of [AuthErrorCode]s to display in toast.
  final List<AuthErrorCode> _toastErrorCodes = [
    AuthErrorCode.googleSignInError,
    AuthErrorCode.tooManyRequests,
    AuthErrorCode.userDisabled,
    AuthErrorCode.unknown,
  ];

  /// A [List] of [AuthErrorCode]s to display near the email field.
  final List<AuthErrorCode> _emailErrorCodes = [
    AuthErrorCode.invalidEmail,
    AuthErrorCode.userNotFound,
  ];

  /// Used to receive authentication updates.
  final ReceiveAuthenticationUpdates _receiveAuthUpdates;

  /// Used to sign in a user.
  final SignInUseCase _signInUseCase;

  /// Used to sign in a user via Google.
  final GoogleSignInUseCase _googleSignInUseCase;

  /// Used to sign out a user.
  final SignOutUseCase _signOutUseCase;

  /// Contains a user's authentication status.
  bool _isLoggedIn;

  /// The stream subscription needed to be able to unsubscribe
  /// from authentication state updates.
  StreamSubscription _authUpdatesSubscription;

  /// Stores the loading status for the sign-in process.
  bool _isLoading = false;

  /// Contains a text description of any authentication exception that may occur.
  AuthErrorMessage _authErrorMessage;

  /// Contains a text description of an email authentication exception that may occur.
  AuthErrorMessage _emailErrorMessage;

  /// Contains a text description of a password authentication exception that may occur.
  AuthErrorMessage _passwordErrorMessage;

  /// Creates a new instance of auth notifier.
  ///
  /// All the parameters must not be null.
  AuthNotifier(
    this._receiveAuthUpdates,
    this._signInUseCase,
    this._googleSignInUseCase,
    this._signOutUseCase,
  )   : assert(_receiveAuthUpdates != null),
        assert(_signInUseCase != null),
        assert(_googleSignInUseCase != null),
        assert(_signOutUseCase != null);

  /// Determines if a user is authenticated.
  bool get isLoggedIn => _isLoggedIn;

  /// Indicates whether the sign-in process is in progress or not.
  bool get isLoading => _isLoading;

  /// Returns an [AuthErrorMessage], containing an authentication error message.
  String get authErrorMessage => _authErrorMessage?.message;

  /// Returns an [AuthErrorMessage], containing an email authentication error message.
  String get emailErrorMessage => _emailErrorMessage?.message;

  /// Returns an [AuthErrorMessage], containing a password authentication error message.
  String get passwordErrorMessage => _passwordErrorMessage?.message;

  /// Provides an authentication error message based on the [errorCode].
  void _addAuthErrorMessage(AuthErrorCode errorCode) {
    final _errorMessage = AuthErrorMessage(errorCode);

    if (_toastErrorCodes.contains(errorCode)) {
      _authErrorMessage = _errorMessage;
    } else if (_emailErrorCodes.contains(errorCode)) {
      _emailErrorMessage = _errorMessage;
    } else {
      _passwordErrorMessage = _errorMessage;
    }
  }

  /// Subscribes to a user authentication updates
  /// to get notified when the user got signed in or signed out.
  void subscribeToAuthenticationUpdates() {
    _authUpdatesSubscription?.cancel();
    _authUpdatesSubscription = _receiveAuthUpdates().listen((user) {
      _isLoggedIn = user != null;
      notifyListeners();
    });
  }

  /// Signs in a user to the app using an [email] and a [password].
  ///
  /// Does nothing if the [isLoading] status is `true`.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (_isLoading) return;

    _isLoading = true;
    clearErrorMessages();

    try {
      await _signInUseCase(UserCredentialsParam(
        email: Email(email),
        password: Password(password),
      ));
    } on AuthenticationException catch (exception) {
      _addAuthErrorMessage(exception.code);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Signs in a user to the app using Google authentication.
  ///
  /// Does nothing if the [isLoading] status is `true`.
  Future<void> signInWithGoogle() async {
    if (_isLoading) return;

    _isLoading = true;
    clearErrorMessages();

    try {
      await _googleSignInUseCase();
    } on AuthenticationException catch (exception) {
      _addAuthErrorMessage(exception.code);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears all authentication error messages.
  void clearErrorMessages() {
    _authErrorMessage = null;
    _emailErrorMessage = null;
    _passwordErrorMessage = null;
    notifyListeners();
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
