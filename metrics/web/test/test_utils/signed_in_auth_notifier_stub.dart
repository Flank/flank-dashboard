// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:metrics/auth/presentation/models/auth_error_message.dart';
import 'package:metrics/auth/presentation/models/auth_state.dart';
import 'package:metrics/auth/presentation/models/user_profile_model.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/feature_config/presentation/models/public_dashboard_feature_config_model.dart';

/// Stub implementation of the [AuthNotifier].
///
/// Provides test implementation of the [AuthNotifier] methods and
/// ensures that a user is already logged in into the application.
class SignedInAuthNotifierStub extends ChangeNotifier implements AuthNotifier {
  @override
  String get authErrorMessage => _authExceptionDescription?.message;

  @override
  String get emailErrorMessage => null;

  @override
  String get passwordErrorMessage => null;

  /// Contains text description of any authentication exception that may occur.
  AuthErrorMessage _authExceptionDescription;

  /// Contains a state of the user authorization.
  AuthState _authState;

  @override
  bool get isLoggedIn =>
      _authState == AuthState.loggedIn ||
      _authState == AuthState.loggedInAnonymously;

  @override
  bool get isLoading => false;

  @override
  void subscribeToAuthenticationUpdates() {
    _authState = AuthState.loggedIn;
    notifyListeners();
  }

  @override
  Future<void> signInWithEmailAndPassword(
      String email, String password) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async {
    _authState = AuthState.loggedOut;
    notifyListeners();
  }

  @override
  Future<void> updateUserProfile(UserProfileModel userProfile) async {}

  @override
  String get userProfileErrorMessage => null;

  @override
  UserProfileModel get userProfileModel => null;

  @override
  String get userProfileSavingErrorMessage => null;

  @override
  AuthState get authState => _authState;

  @override
  void handlePublicDashboardFeatureConfigUpdates(
      PublicDashboardFeatureConfigModel model) {}
}
