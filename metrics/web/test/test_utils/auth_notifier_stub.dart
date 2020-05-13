import 'package:flutter/foundation.dart';
import 'package:metrics/auth/presentation/model/auth_error_message.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';

/// Stub implementation on the [AuthNotifier].
///
/// Provides test implementation of the [AuthNotifier] methods.
class AuthNotifierStub extends ChangeNotifier implements AuthNotifier {
  @override
  AuthErrorMessage get authErrorMessage => null;

  /// Contains a user's authentication status.
  bool _isLoggedIn;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  void subscribeToAuthenticationUpdates() {}

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _isLoggedIn = true;
    notifyListeners();
  }

  @override
  Future<void> signOut() async {}
}
