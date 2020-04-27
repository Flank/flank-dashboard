import 'package:ci_integration/firestore/config/parser/firestore_config_parser.dart';
import 'package:test/test.dart';

import '../../test_utils/firestore_config_test_data.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("FirestoreConfigParser", () {
    final firestoreConfigParser = FirestoreConfigParser();
    final firestoreConfig = FirestoreConfigTestData.firestoreConfig;
    final firestoreConfigMap = {
      'firestore': FirestoreConfigTestData.firestoreConfigJson,
    };

    test(".canParse() should return false if the given map is null", () {
      final result = firestoreConfigParser.canParse(null);

      expect(false, equals(result));
    });

    test(
      ".canParse() should return false if the given map does not contain a firestore  key",
      () {
        final map = {'test': {}};

        final result = firestoreConfigParser.canParse(map);

        expect(false, equals(result));
      },
    );

    test(
      ".canParse() should return true if parser can parse the given map",
      () {
        final result = firestoreConfigParser.canParse(firestoreConfigMap);

        expect(true, equals(result));
      },
    );

    test(".parse() should return null if the given map is null", () {
      final result = firestoreConfigParser.parse(null);

      expect(result, isNull);
    });

    test(
      ".parse() should return null if the given map does not contain a firestore key",
      () {
        final map = {'test': {}};

        final result = firestoreConfigParser.parse(map);

        expect(result, isNull);
      },
    );

    test(".parse() should parses valid map and returns FirestoreConfig", () {
      final result = firestoreConfigParser.parse(firestoreConfigMap);

      expect(result, equals(firestoreConfig));
    });
  });
}
