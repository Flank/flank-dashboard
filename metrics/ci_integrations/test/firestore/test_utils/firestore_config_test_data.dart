import 'package:ci_integration/firestore/config/model/firestore_config.dart';

/// A class containig a test data for the [FirestoreConfig].
class FirestoreConfigTestData {
  static const String firebaseProjectId = 'firebaseProjectId';
  static const String metricsProjectId = 'metricsProjectId';

  static const Map<String, dynamic> firestoreConfigJson = {
    'firebase_project_id': firebaseProjectId,
    'metrics_project_id': metricsProjectId,
  };

  static final FirestoreConfig firestoreConfig = FirestoreConfig(
    metricsProjectId: metricsProjectId,
    firebaseProjectId: firebaseProjectId,
  );
}
