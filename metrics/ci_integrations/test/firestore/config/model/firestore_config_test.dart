import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:test/test.dart';

void main() {
  group(
    "FirestoreConfig",
    () {
      test(
        "can't be created when the firebaseProjectId is null",
        () {
          expect(
            () => FirestoreConfig(
              metricsProjectId: 'id',
              firebaseProjectId: null,
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        "can't be created when the metricsProjectId is null",
        () {
          expect(
            () => FirestoreConfig(
              firebaseProjectId: 'id',
              metricsProjectId: null,
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        '.fromJson() creates instance of FirestoreConfig from json encodable Map',
        () {
          const firebaseProjectId = 'firebaseId';
          const metricsProjectId = 'projectId';

          final firestoreConfigJson = {
            'firebase_project_id': firebaseProjectId,
            'metrics_project_id': metricsProjectId,
          };

          final firestoreConfig = FirestoreConfig.fromJson(firestoreConfigJson);

          expect(firestoreConfig.firebaseProjectId, firebaseProjectId);
          expect(firestoreConfig.metricsProjectId, metricsProjectId);
        },
      );

      test(
        ".fromJson() return null if null is passed",
        () {
          final credentials = FirestoreConfig.fromJson(null);

          expect(credentials, isNull);
        },
      );
    },
  );
}
