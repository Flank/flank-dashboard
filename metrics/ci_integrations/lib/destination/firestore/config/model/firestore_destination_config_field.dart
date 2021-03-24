// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:ci_integration/integration/interface/base/config/model/config_field.dart';

/// A class that represents the [FirestoreDestinationConfig]'s fields.
class FirestoreDestinationConfigField extends ConfigField {
  /// A Firebase project ID field of the [FirestoreDestinationConfig].
  static final FirestoreDestinationConfigField firebaseProjectId =
      FirestoreDestinationConfigField._('firebase_project_id');

  /// A Firebase user email field of the [FirestoreDestinationConfig].
  static final FirestoreDestinationConfigField firebaseUserEmail =
      FirestoreDestinationConfigField._('firebase_user_email');

  /// A Firebase user password field of the [FirestoreDestinationConfig].
  static final FirestoreDestinationConfigField firebaseUserPassword =
      FirestoreDestinationConfigField._('firebase_user_pass');

  /// A Firebase public API key field of the [FirestoreDestinationConfig].
  static final FirestoreDestinationConfigField firebasePublicApiKey =
      FirestoreDestinationConfigField._('firebase_public_api_key');

  /// A Metrics project ID field of the [FirestoreDestinationConfig].
  static final FirestoreDestinationConfigField metricsProjectId =
      FirestoreDestinationConfigField._('metrics_project_id');

  /// A list containing all [FirestoreDestinationConfigField]s of
  /// the [FirestoreDestinationConfig].
  static final List<FirestoreDestinationConfigField> values =
      UnmodifiableListView([
    firebaseProjectId,
    firebaseUserEmail,
    firebaseUserPassword,
    firebasePublicApiKey,
    metricsProjectId,
  ]);

  /// Creates an instance of the [FirestoreDestinationConfigField] with the
  /// given value.
  ///
  /// Throws an [ArgumentError] if the given [value] is `null`.
  FirestoreDestinationConfigField._(
    String value,
  ) : super(value);
}
