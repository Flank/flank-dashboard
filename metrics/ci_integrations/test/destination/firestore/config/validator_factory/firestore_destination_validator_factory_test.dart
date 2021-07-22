// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:ci_integration/destination/firestore/config/validation_delegate/firestore_destination_validation_delegate.dart';
import 'package:ci_integration/destination/firestore/config/validator_factory/firestore_destination_validator_factory.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("FirestoreDestinationValidatorFactory", () {
    final config = FirestoreDestinationConfig(
      firebaseProjectId: 'id',
      firebaseUserEmail: 'email',
      firebaseUserPassword: 'password',
      firebasePublicApiKey: 'apiKey',
      metricsProjectId: 'metricsId',
    );

    const validatorFactory = FirestoreDestinationValidatorFactory();

    test(
      ".create() throws an ArgumentError if the given config is null",
      () {
        expect(() => validatorFactory.create(null), throwsArgumentError);
      },
    );

    test(
      ".create() creates a config validator with the firestore destination validation delegate",
      () {
        final validator = validatorFactory.create(config);

        expect(
          validator.validationDelegate,
          isA<FirestoreDestinationValidationDelegate>(),
        );
      },
    );

    test(
      ".create() creates a config validator with the validation result builder",
      () {
        final validator = validatorFactory.create(config);

        expect(
          validator.validationResultBuilder,
          isA<ValidationResultBuilder>(),
        );
      },
    );
  });
}
