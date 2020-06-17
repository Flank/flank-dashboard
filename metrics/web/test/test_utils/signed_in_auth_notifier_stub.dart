import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:metrics/auth/presentation/model/auth_error_message.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';

/// Stub implementation on the [AuthNotifier].
///
/// Provides test implementation of the [AuthNotifier] methods and
/// ensures that a user is already logged in into the application.
class SignedInAuthNotifierStub extends ChangeNotifier implements AuthNotifier {
  @override
  AuthErrorMessage get authErrorMessage => _authExceptionDescription;

  /// Contains text description of any authentication exception that may occur.
  AuthErrorMessage _authExceptionDescription;

  /// Contains a user's authentication status.
  bool _isLoggedIn;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  void subscribeToAuthenticationUpdates() {
    _isLoggedIn = true;
    notifyListeners();
  }

  @override
  Future<void> signInWithEmailAndPassword(
      String email, String password) async {}

  @override
  Future<void> signOut() async {
    _isLoggedIn = false;
    notifyListeners();
  }
}
