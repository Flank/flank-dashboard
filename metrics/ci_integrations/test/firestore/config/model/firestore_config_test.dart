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
              firebaseProjectId: null,
              metricsProjectId: 'id',
              firebaseAuthApiKey: 'apiKey',
              firebaseUserEmail: 'userEmail',
              firebaseUserPassword: 'userPass',
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
              firebaseAuthApiKey: 'apiKey',
              firebaseUserEmail: 'userEmail',
              firebaseUserPassword: 'userPass',
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        "can't be created when the firebaseAuthApiKey is null",
        () {
          expect(
            () => FirestoreConfig(
              firebaseProjectId: 'id',
              metricsProjectId: 'id',
              firebaseAuthApiKey: null,
              firebaseUserEmail: 'userEmail',
              firebaseUserPassword: 'userPass',
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        "can't be created when the firebaseUserEmail is null",
        () {
          expect(
            () => FirestoreConfig(
              firebaseProjectId: 'id',
              metricsProjectId: 'id',
              firebaseAuthApiKey: 'apiKey',
              firebaseUserEmail: null,
              firebaseUserPassword: 'userPass',
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        "can't be created when the firebaseUserPassword is null",
        () {
          expect(
            () => FirestoreConfig(
              firebaseProjectId: 'id',
              metricsProjectId: 'id',
              firebaseAuthApiKey: 'apiKey',
              firebaseUserEmail: 'userEmail',
              firebaseUserPassword: null,
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
          const firebaseAuthApiKey = 'apiKey';
          const firebaseUserEmail = 'userEmail';
          const firebaseUserPassword = 'userPassword';

          final firestoreConfigJson = {
            'firebase_project_id': firebaseProjectId,
            'metrics_project_id': metricsProjectId,
            'firebase_api_key': firebaseAuthApiKey,
            'firebase_user_email': firebaseUserEmail,
            'firebase_user_pass': firebaseUserPassword,
          };

          final firestoreConfig = FirestoreConfig.fromJson(firestoreConfigJson);

          expect(firestoreConfig.firebaseProjectId, firebaseProjectId);
          expect(firestoreConfig.metricsProjectId, metricsProjectId);
          expect(firestoreConfig.firebaseAuthApiKey, firebaseAuthApiKey);
          expect(firestoreConfig.firebaseUserEmail, firebaseUserEmail);
          expect(firestoreConfig.firebaseUserPassword, firebaseUserPassword);
        },
      );

      test(
        ".fromJson() return null if null is passed",
        () {
          final config = FirestoreConfig.fromJson(null);

          expect(config, isNull);
        },
      );
    },
  );
}
