// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/prompter/prompter.dart';
import 'package:cli/services/firebase/cli/firebase_cli.dart';
import 'package:cli/services/firebase/firebase_service.dart';
import 'package:cli/services/firebase/strings/firebase_strings.dart';

/// An adapter for the [FirebaseCli] to implement
/// the [FirebaseService] interface.
class FirebaseCliServiceAdapter implements FirebaseService {
  /// A [FirebaseCli] class that provides an ability to interact
  /// with the Firebase CLI.
  final FirebaseCli _firebaseCli;

  /// A [Prompter] class this adapter uses to interact with a user.
  final Prompter _prompter;

  /// Creates a new instance of the [FirebaseCliServiceAdapter]
  /// with the given [FirebaseCli] and [Prompter].
  ///
  /// Throws an [ArgumentError] if the given [FirebaseCli] is `null`.
  /// Throws an [ArgumentError] if the given [Prompter] is `null`.
  FirebaseCliServiceAdapter(this._firebaseCli, this._prompter) {
    ArgumentError.checkNotNull(_firebaseCli, 'firebaseCli');
    ArgumentError.checkNotNull(_prompter, 'prompter');
  }

  @override
  Future<void> login() {
    return _firebaseCli.login();
  }

  @override
  Future<void> createWebApp(String projectId) async {
    await _firebaseCli.addFirebase(projectId);
    await _firebaseCli.createWebApp(projectId, projectId);
  }

  @override
  Future<void> deployFirebase(String projectId, String firebasePath) async {
    await _firebaseCli.setFirebaseProject(projectId, firebasePath);
    await _firebaseCli.deployFirestore(firebasePath);
    await _firebaseCli.deployFunctions(firebasePath);
  }

  @override
  Future<void> deployHosting(
    String projectId,
    String target,
    String appPath,
  ) async {
    await _firebaseCli.setFirebaseProject(projectId, appPath);
    await _firebaseCli.clearTarget(target, appPath);
    await _firebaseCli.applyTarget(projectId, target, appPath);
    await _firebaseCli.deployHosting(target, appPath);
  }

  @override
  Future<void> version() {
    return _firebaseCli.version();
  }

  @override
  String configureAuthProviders(String projectId) {
    return _prompter.prompt(FirebaseStrings.configureAuthProviders(projectId));
  }

  @override
  void enableAnalytics(String projectId) {
    _prompter.prompt(FirebaseStrings.enableAnalytics(projectId));
  }

  @override
  void initializeFirestoreData(String projectId) {
    _prompter.prompt(FirebaseStrings.initializeData(projectId));
  }

  @override
  void upgradeBillingPlan(String projectId) {
    _prompter.prompt(FirebaseStrings.upgradeBillingPlan(projectId));
  }

  @override
  void acceptTermsOfService() {
    _prompter.prompt(FirebaseStrings.acceptTerms);
  }
}
