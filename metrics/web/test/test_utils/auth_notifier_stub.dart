// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:metrics/auth/presentation/models/user_profile_model.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';

/// Stub implementation of the [AuthNotifier].
///
/// Provides test implementation of the [AuthNotifier] methods.
class AuthNotifierStub extends ChangeNotifier implements AuthNotifier {
  @override
  String get authErrorMessage => null;

  @override
  String get emailErrorMessage => null;

  @override
  String get passwordErrorMessage => null;

  /// Contains a user's authentication status.
  bool _isLoggedIn;

  @override
  bool get authState => _isLoggedIn;

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

  @override
  Future<void> updateUserProfile(UserProfileModel userProfile) async {}

  @override
  String get userProfileErrorMessage => null;

  @override
  UserProfileModel get userProfileModel => null;

  @override
  String get userProfileSavingErrorMessage => null;
}
