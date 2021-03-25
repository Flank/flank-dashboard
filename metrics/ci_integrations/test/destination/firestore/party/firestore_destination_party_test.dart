// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/destination/firestore/client_factory/firestore_destination_client_factory.dart';
import 'package:ci_integration/destination/firestore/config/parser/firestore_destination_config_parser.dart';
import 'package:ci_integration/destination/firestore/config/validator_factory/firestore_destination_validator_factory.dart';
import 'package:ci_integration/destination/firestore/party/firestore_destination_party.dart';
import 'package:test/test.dart';

void main() {
  group("FirestoreDestinationParty", () {
    final firestoreDestinationParty = FirestoreDestinationParty();

    test(
      "uses FirestoreDestinationClientFactory as a client factory",
      () {
        final clientFactory = firestoreDestinationParty.clientFactory;

        expect(clientFactory, isA<FirestoreDestinationClientFactory>());
      },
    );

    test("uses FirestoreConfigParser as a config parser", () {
      final configParser = firestoreDestinationParty.configParser;

      expect(configParser, isA<FirestoreDestinationConfigParser>());
    });

    test("uses FirestoreDestinationValidatorFactory as a validator factory",
        () {
      final validatorFactory = firestoreDestinationParty.configValidatorFactory;

      expect(validatorFactory, isA<FirestoreDestinationValidatorFactory>());
    });
  });
}
