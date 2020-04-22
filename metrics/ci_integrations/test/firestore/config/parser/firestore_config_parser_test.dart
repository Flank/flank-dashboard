import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:ci_integration/firestore/config/parser/firestore_config_parser.dart';
import 'package:test/test.dart';

void main() {
  group("FirestoreConfigParser", () {
    const firestoreConfigParser = FirestoreConfigParser();
    const destinationMap = {
      'firestore': {
        'firebase_project_id': 'firestore_project_id',
        'metrics_project_id': 'metrics_project_id',
      },
    };
    test(".canParse() should returns false if the given map is null", () {
      final result = firestoreConfigParser.canParse(null);

      expect(false, equals(result));
    });

    test(
        ".canParse() should returns false if the given map does not contain a firestore  key",
        () {
      final result = firestoreConfigParser.canParse({});

      expect(false, equals(result));
    });

    test(".canParse() should returns true if parser can parse the given map", () {
      final result = firestoreConfigParser.canParse(destinationMap);

      expect(true, equals(result));
    });

    test(".parse() should returns null if the given map is null", () {
      final result = firestoreConfigParser.parse(null);

      expect(result, isNull);
    });

    test(
        ".parse() should returns null if the given map does not contain a firestore key",
        () {
      final result = firestoreConfigParser.parse({});

      expect(result, isNull);
    });

    test(".parse() should parses valid map and returns FirestoreConfig", () {
      final expected = FirestoreConfig(
        firebaseProjectId: 'firestore_project_id',
        metricsProjectId: 'metrics_project_id',
      );
      final result = firestoreConfigParser.parse(destinationMap);

      expect(result, equals(expected));
    });
  });
}
