// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:metrics/auth/presentation/models/auth_state.dart';
import 'package:metrics/auth/presentation/models/user_profile_model.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/view_models/user_profile_view_model.dart';
import 'package:metrics/feature_config/presentation/models/public_dashboard_feature_config_model.dart';

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

  /// Contains a user's authorization state.
  AuthState _authState;

  @override
  bool get isLoggedIn =>
      _authState == AuthState.loggedIn ||
      _authState == AuthState.loggedInAnonymously;

  @override
  bool get isLoading => false;

  @override
  void subscribeToAuthenticationUpdates() {}

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _authState = AuthState.loggedIn;
    notifyListeners();
  }

  @override
  Future<void> signInWithGoogle() async {
    _authState = AuthState.loggedIn;
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

  @override
  AuthState get authState => _authState;

  @override
  Future<void> handlePublicDashboardFeatureConfigUpdates(
      PublicDashboardFeatureConfigModel model) async {}

  @override
  UserProfileViewModel get userProfileViewModel =>
      const UserProfileViewModel(isAnonymous: false);
  
  @override
  bool get isInitialized => true;
}
