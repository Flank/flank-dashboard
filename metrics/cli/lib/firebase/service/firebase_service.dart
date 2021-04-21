// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/service/info_service.dart';

/// An abstract class for Firebase service that provides methods
/// for working with Firebase.
abstract class FirebaseService extends InfoService {
  /// Logins into the Firebase.
  Future<void> login();

  /// Creates a Firebase Web application in the Firebase project with the given
  /// [projectId].
  Future<void> createWebApp(String projectId);

  /// Deploys the given Firebase hosting [target] from the given [appPath]
  /// to the Firebase project with the given [projectId] hosting.
  Future<void> deployHosting(String projectId, String target, String appPath);

  /// Deploys Firebase rules, indexes, and functions to the project
  /// with the given [projectId] from the given [firebasePath].
  Future<void> deployFirebase(String projectId, String firebasePath);

  /// Upgrades the Firebase account billing plan.
  void upgradeBillingPlan(String projectId);

  /// Initializes the firestore data.
  void initializeFirestoreData(String projectId);

  /// Enables Firestore Analytics service for the Firebase project.
  void enableAnalytics(String projectId);

  /// Configures Firebase auth providers.
  String configureAuth(String projectId);

  /// Accepts the terms of the service.
  void acceptTerms() {}
}
