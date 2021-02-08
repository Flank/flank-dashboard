// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';

/// A class containing a test data for the [FirestoreDestinationConfig].
class FirestoreConfigTestData {
  static const String firebaseProjectId = 'firebaseProjectId';
  static const String metricsProjectId = 'metricsProjectId';
  static const String firebaseUserEmail = 'firebaseUserEmail';
  static const String firebaseUserPassword = 'firebaseUserPassword';
  static const String firebasePublicApiKey = 'firebasePublicApiKey';

  static const Map<String, dynamic> firestoreDestinationConfigMap = {
    'firebase_project_id': firebaseProjectId,
    'metrics_project_id': metricsProjectId,
    'firebase_user_email': firebaseUserEmail,
    'firebase_user_pass': firebaseUserPassword,
    'firebase_public_api_key': firebasePublicApiKey
  };

  static final FirestoreDestinationConfig firestoreDestiantionConfig =
      FirestoreDestinationConfig(
    metricsProjectId: metricsProjectId,
    firebaseProjectId: firebaseProjectId,
    firebaseUserEmail: firebaseUserEmail,
    firebaseUserPassword: firebaseUserPassword,
    firebasePublicApiKey: firebasePublicApiKey,
  );
}
