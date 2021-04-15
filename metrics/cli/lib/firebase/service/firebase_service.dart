// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/service/info_service.dart';

/// An abstract class for Firebase service that provides methods
/// for working with Firebase.
abstract class FirebaseService extends InfoService {
  /// Logins into the Firebase.
  Future<void> login();

  /// Adds Firebase capabilities to the project based on the given [projectId].
  Future<void> createWebApp(String projectId);

  /// Deploys a project with the given [projectId] from the given [appPath]
  /// to the firebase hosting.
  Future<void> deployHosting(String projectId, String target, String appPath);

  /// Deploys Firebase rules, indexes, and functions to the project
  /// with the given [projectId] from the given [firebasePath].
  Future<void> deployFirebase(String projectId, String firebasePath);
}
