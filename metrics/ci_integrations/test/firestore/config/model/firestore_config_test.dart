import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:test/test.dart';

void main() {
  group(
    "FirestoreModel",
    () {
      test(
        "can't be created when metricsProjectId or firestoreProjectId is null",
        () {
          expect(
            () => FirestoreConfig(
              metricsProjectId: 'id',
              firestoreProjectId: null,
            ),
            throwsArgumentError,
          );
          expect(
            () => FirestoreConfig(
              firestoreProjectId: 'id',
              metricsProjectId: null,
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        '.fromJson() creates instance of FirestoreModel from json encodable Map',
        () {
          const firestoreProjectId = 'firestoreId';
          const metricsProjectId = 'projectId';

          final firestoreConfigJson = {
            'firestore_project_id': firestoreProjectId,
            'metrics_project_id': metricsProjectId,
          };

          final firestoreConfig = FirestoreConfig.fromJson(firestoreConfigJson);

          expect(firestoreConfig.firestoreProjectId, firestoreProjectId);
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
