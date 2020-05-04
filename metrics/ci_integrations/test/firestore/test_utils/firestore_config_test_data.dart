import 'package:ci_integration/firestore/config/model/firestore_destination_config.dart';

/// A class containing a test data for the [FirestoreDestinationConfig].
class FirestoreConfigTestData {
  static const String firebaseProjectId = 'firebaseProjectId';
  static const String metricsProjectId = 'metricsProjectId';

  static const Map<String, dynamic> firestoreConfigJson = {
    'firebase_project_id': firebaseProjectId,
    'metrics_project_id': metricsProjectId,
  };

  static final FirestoreDestinationConfig firestoreConfig =
      FirestoreDestinationConfig(
    metricsProjectId: metricsProjectId,
    firebaseProjectId: firebaseProjectId,
  );
}
