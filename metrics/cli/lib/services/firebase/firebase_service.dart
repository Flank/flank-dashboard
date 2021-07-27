// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:cli/services/common/auth_service.dart';
import 'package:cli/services/common/info_service.dart';
import 'package:cli/services/common/service/model/service_name.dart';

/// An abstract class for Firebase service that provides methods
/// for working with Firebase.
abstract class FirebaseService implements AuthService, InfoService {
  @override
  ServiceName get serviceName => ServiceName.firebase;

  /// Logins into the Firebase.
  Future<void> login();

  /// Creates a Firebase Web application in the Firebase project with the given
  /// [projectId].
  Future<void> createWebApp(String projectId);

  /// Deploys the given Firebase hosting [target] from the given [appPath]
  /// to the Firebase project with the given [projectId] hosting.
  Future<void> deployHosting(
    String projectId,
    String target,
    String appPath,
  );

  /// Deploys Firebase rules, indexes, and functions to the project
  /// with the given [projectId] from the given [firebasePath].
  Future<void> deployFirebase(
    String projectId,
    String firebasePath,
  );

  /// Upgrades the Firebase account billing plan of the Firebase project with
  /// the given [projectId].
  FutureOr<void> upgradeBillingPlan(String projectId);

  /// Initializes the firestore data in the Firebase project with
  /// the given [projectId].
  FutureOr<void> initializeFirestoreData(String projectId);

  /// Enables Firestore Analytics service for the Firebase project with
  /// the given [projectId].
  FutureOr<void> enableAnalytics(String projectId);

  /// Configures Firebase auth providers for the Firebase project with
  /// the given [projectId].
  FutureOr<String> configureAuthProviders(String projectId);

  /// Accepts the terms of the service.
  FutureOr<void> acceptTermsOfService();
}
