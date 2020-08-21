import 'package:flutter/foundation.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';

/// Stub implementation on the [AuthNotifier].
///
/// Provides test implementation of the [AuthNotifier] methods.
class AuthNotifierStub extends ChangeNotifier implements AuthNotifier {
  @override
  String get authErrorMessage => null;

  /// Contains a user's authentication status.
  bool _isLoggedIn;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  bool get isLoading => false;

  @override
  void subscribeToAuthenticationUpdates() {}

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _isLoggedIn = true;
    notifyListeners();
  }

  @override
  Future<void> signInWithGoogle() async {
    _isLoggedIn = true;
    notifyListeners();
  }

  @override
  Future<void> signOut() async {}
}
