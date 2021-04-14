// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/firebase/cli/firebase_cli.dart';
import 'package:cli/firebase/constants/firebase_constants.dart';
import 'package:cli/firebase/service/firebase_service.dart';
import 'package:cli/gcloud/cli/gcloud_cli.dart';
import 'package:cli/prompt/prompter.dart';

/// An adapter for the [FirebaseCli] to implement
/// the [FirebaseService] interface.
class FirebaseCliServiceAdapter implements FirebaseService {
  /// A [GCloudCli] class that provides an ability to interact
  /// with the GCloud CLI.
  final FirebaseCli _firebaseCli;

  /// A [Prompter] class this adapter uses to interact with a user.
  final Prompter _prompter;

  /// Creates a new instance of the [FirebaseCliServiceAdapter]
  /// with the given [GCloudCli].
  ///
  /// Throws an [ArgumentError] if the given [GCloudCli] is `null`.
  /// Throws an [ArgumentError] if the given [Prompter] is `null`.
  FirebaseCliServiceAdapter(this._firebaseCli, this._prompter) {
    ArgumentError.checkNotNull(_firebaseCli, 'gcloudCli');
    ArgumentError.checkNotNull(_prompter, 'prompter');
  }

  @override
  Future<void> login() async {
    await _firebaseCli.login();
  }

  @override
  Future<void> addProject(String projectId) async {
    await _firebaseCli.addFirebase(projectId);
    await _firebaseCli.createWebApp(projectId, projectId);
  }

  @override
  Future<void> deployFirebase(
    String projectId,
    String firebasePath,
  ) async {
    await _firebaseCli.setFirebaseProject(projectId, firebasePath);
    await _firebaseCli.deployFirestore(firebasePath);
    await _firebaseCli.deployFunctions(firebasePath);
  }

  @override
  Future<void> deployHosting(String projectId, String appPath) async {
    const target = FirebaseConstants.target;

    await _firebaseCli.setFirebaseProject(projectId, appPath);
    await _firebaseCli.clearTarget(projectId, appPath);
    await _firebaseCli.applyTarget(projectId, target, appPath);
    await _firebaseCli.deployHosting(target, appPath);
  }

  @override
  Future<void> version() {
    return _firebaseCli.version();
  }
}
