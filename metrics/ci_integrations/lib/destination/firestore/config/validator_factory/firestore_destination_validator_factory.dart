// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/destination/firestore/factory/firebase_auth_factory.dart';
import 'package:ci_integration/destination/firestore/factory/firestore_factory.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config_field.dart';
import 'package:ci_integration/destination/firestore/config/validation_delegate/firestore_destination_validation_delegate.dart';
import 'package:ci_integration/destination/firestore/config/validator/firestore_destination_validator.dart';
import 'package:ci_integration/integration/stub/base/config/validator/config_validator_stub.dart';
import 'package:ci_integration/integration/stub/base/config/validator_factory/config_validator_factory_stub.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';

/// A factory class that provides a method for creating
/// [FirestoreDestinationValidator].
class FirestoreDestinationValidatorFactory
    implements ConfigValidatorFactoryStub<FirestoreDestinationConfig> {
  /// Creates a new instance of the [FirestoreDestinationValidatorFactory].
  const FirestoreDestinationValidatorFactory();

  @override
  ConfigValidatorStub<FirestoreDestinationConfig> create(
    FirestoreDestinationConfig config,
  ) {
    ArgumentError.checkNotNull(config, 'config');

    const firebaseAuthFactory = FirebaseAuthFactory();
    const firestoreFactory = FirestoreFactory();

    final validationDelegate = FirestoreDestinationValidationDelegate(
      firebaseAuthFactory,
      firestoreFactory,
    );

    final validationResultBuilder = ValidationResultBuilder.forFields(
      FirestoreDestinationConfigField.values,
    );

    return FirestoreDestinationValidator(
      validationDelegate,
      validationResultBuilder,
    );
  }
}
