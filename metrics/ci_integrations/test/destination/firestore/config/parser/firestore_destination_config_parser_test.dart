import 'package:ci_integration/destination/firestore/config/parser/firestore_destination_config_parser.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/firestore_config_test_data.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("FirestoreDestinationConfigParser", () {
    final firestoreDestinationConfigParser = FirestoreDestinationConfigParser();
    final firestoreConfig = FirestoreConfigTestData.firestoreConfig;
    final firestoreConfigMap = {
      'firestore': FirestoreConfigTestData.firestoreConfigJson,
    };

    test(".canParse() should return false if the given map is null", () {
      final result = firestoreDestinationConfigParser.canParse(null);

      expect(false, equals(result));
    });

    test(
      ".canParse() should return false if the given map does not contain a Firestore key",
      () {
        final map = {'test': {}};

        final result = firestoreDestinationConfigParser.canParse(map);

        expect(false, equals(result));
      },
    );

    test(
      ".canParse() should return true if the parser can parse the given map",
      () {
        final result =
            firestoreDestinationConfigParser.canParse(firestoreConfigMap);

        expect(true, equals(result));
      },
    );

    test(".parse() should return null if the given map is null", () {
      final result = firestoreDestinationConfigParser.parse(null);

      expect(result, isNull);
    });

    test(
      ".parse() should return null if the given map does not contain a Firestore key",
      () {
        final map = {'test': {}};

        final result = firestoreDestinationConfigParser.parse(map);

        expect(result, isNull);
      },
    );

    test(".parse() should parses valid map and returns FirestoreConfig", () {
      final result = firestoreDestinationConfigParser.parse(firestoreConfigMap);

      expect(result, equals(firestoreConfig));
    });
  });
}
