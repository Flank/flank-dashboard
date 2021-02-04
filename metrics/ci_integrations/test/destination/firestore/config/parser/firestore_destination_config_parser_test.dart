// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/destination/firestore/config/parser/firestore_destination_config_parser.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/firestore_config_test_data.dart';

void main() {
  group("FirestoreDestinationConfigParser", () {
    const firestoreDestinationConfigParser = FirestoreDestinationConfigParser();
    final firestoreConfig = FirestoreConfigTestData.firestoreDestiantionConfig;
    final firestoreConfigMap = {
      'firestore': FirestoreConfigTestData.firestoreDestinationConfigMap,
    };

    test(".canParse() returns false if the given map is null", () {
      final result = firestoreDestinationConfigParser.canParse(null);

      expect(false, equals(result));
    });

    test(
      ".canParse() returns false if the given map does not contain a Firestore key",
      () {
        final map = {'test': {}};

        final result = firestoreDestinationConfigParser.canParse(map);

        expect(false, equals(result));
      },
    );

    test(
      ".canParse() returns true if the parser can parse the given map",
      () {
        final result =
            firestoreDestinationConfigParser.canParse(firestoreConfigMap);

        expect(true, equals(result));
      },
    );

    test(".parse() returns null if the given map is null", () {
      final result = firestoreDestinationConfigParser.parse(null);

      expect(result, isNull);
    });

    test(
      ".parse() returns null if the given map does not contain a Firestore key",
      () {
        final map = {'test': {}};

        final result = firestoreDestinationConfigParser.parse(map);

        expect(result, isNull);
      },
    );

    test(".parse() parses a valid map and returns FirestoreConfig", () {
      final result = firestoreDestinationConfigParser.parse(firestoreConfigMap);

      expect(result, equals(firestoreConfig));
    });
  });
}
