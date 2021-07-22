// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [FirestoreDestinationConfig]'s fields.
class FirestoreDestinationValidationTarget {
  /// A Firebase project ID field of the [FirestoreDestinationConfig].
  static const firebaseProjectId = ValidationTarget(
    name: 'firebase_project_id',
  );

  /// A Firebase user email field of the [FirestoreDestinationConfig].
  static const firebaseUserEmail = ValidationTarget(
    name: 'firebase_user_email',
  );

  /// A Firebase user password field of the [FirestoreDestinationConfig].
  static const firebaseUserPassword = ValidationTarget(
    name: 'firebase_user_pass',
  );

  /// A Firebase public API key field of the [FirestoreDestinationConfig].
  static const firebasePublicApiKey = ValidationTarget(
    name: 'firebase_public_api_key',
  );

  /// A Metrics project ID field of the [FirestoreDestinationConfig].
  static const metricsProjectId = ValidationTarget(name: 'metrics_project_id');

  /// A list containing all [FirestoreDestinationValidationTarget]s of
  /// the [FirestoreDestinationConfig].
  static final List<ValidationTarget> values = UnmodifiableListView([
    firebaseProjectId,
    firebaseUserEmail,
    firebaseUserPassword,
    firebasePublicApiKey,
    metricsProjectId,
  ]);
}
