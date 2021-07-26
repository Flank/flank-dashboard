// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/models/firebase_auth_credentials.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config_field.dart';
import 'package:ci_integration/destination/firestore/config/validation_delegate/firestore_destination_validation_delegate.dart';
import 'package:ci_integration/destination/firestore/strings/firestore_strings.dart';
import 'package:ci_integration/integration/stub/base/config/validator/config_validator_stub.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';

/// A class responsible for validating the [FirestoreDestinationConfig].
class FirestoreDestinationValidator
    implements ConfigValidatorStub<FirestoreDestinationConfig> {
  @override
  final FirestoreDestinationValidationDelegate validationDelegate;

  @override
  final ValidationResultBuilder validationResultBuilder;

  /// Creates a new instance of the [FirestoreDestinationValidator] with
  /// the given [validationDelegate] and [validationResultBuilder].
  ///
  /// Throws an [ArgumentError] if the given [validationDelegate]
  /// or [validationResultBuilder] is `null`.
  FirestoreDestinationValidator(
    this.validationDelegate,
    this.validationResultBuilder,
  ) {
    ArgumentError.checkNotNull(validationDelegate, 'validationDelegate');
    ArgumentError.checkNotNull(
      validationResultBuilder,
      'validationResultBuilder',
    );
  }

  @override
  Future<ValidationResult> validate(FirestoreDestinationConfig config) async {
    final apiKey = config.firebasePublicApiKey;
    final apiKeyValidationResult =
        await validationDelegate.validatePublicApiKey(apiKey);

    validationResultBuilder.setResult(
      FirestoreDestinationConfigField.firebasePublicApiKey,
      apiKeyValidationResult,
    );

    if (apiKeyValidationResult.isFailure) {
      return _finalizeValidationResult(
        FirestoreStrings.publicApiKeyInvalidInterruptReason,
      );
    }

    final firebaseAuthCredentials = FirebaseAuthCredentials(
      apiKey: apiKey,
      email: config.firebaseUserEmail,
      password: config.firebaseUserPassword,
    );

    final authValidationResult = await validationDelegate.validateAuth(
      firebaseAuthCredentials,
    );

    validationResultBuilder.setResult(
      FirestoreDestinationConfigField.firebaseUserEmail,
      authValidationResult,
    );

    validationResultBuilder.setResult(
      FirestoreDestinationConfigField.firebaseUserPassword,
      authValidationResult,
    );

    if (authValidationResult.isFailure) {
      return _finalizeValidationResult(
        FirestoreStrings.authInvalidInterruptReason,
      );
    }
    if (authValidationResult.isUnknown) {
      return _finalizeValidationResult(
        FirestoreStrings.authValidationFailedInterruptReason,
      );
    }

    final firebaseProjectId = config.firebaseProjectId;
    final firebaseProjectIdValidationResult = await validationDelegate
        .validateFirebaseProjectId(firebaseAuthCredentials, firebaseProjectId);

    validationResultBuilder.setResult(
      FirestoreDestinationConfigField.firebaseProjectId,
      firebaseProjectIdValidationResult,
    );

    if (firebaseProjectIdValidationResult.isFailure) {
      return _finalizeValidationResult(
        FirestoreStrings.firebaseProjectIdInvalidInterruptReason,
      );
    }
    if (firebaseProjectIdValidationResult.isUnknown) {
      return _finalizeValidationResult(
        FirestoreStrings.firebaseProjectIdValidationFailedInterruptReason,
      );
    }

    final metricsProjectId = config.metricsProjectId;
    final metricsProjectIdValidationResult =
        await validationDelegate.validateMetricsProjectId(
      firebaseAuthCredentials,
      firebaseProjectId,
      metricsProjectId,
    );

    validationResultBuilder.setResult(
      FirestoreDestinationConfigField.metricsProjectId,
      metricsProjectIdValidationResult,
    );

    return validationResultBuilder.build();
  }

  /// Sets the empty results of the [validationResultBuilder] using the given
  /// [interruptReason] and builds the [ValidationResult]
  /// using the [validationResultBuilder].
  ValidationResult _finalizeValidationResult(String interruptReason) {
    _setEmptyFields(interruptReason);

    return validationResultBuilder.build();
  }

  /// Sets empty results of the [validationResultBuilder] to the
  /// [FieldValidationResult.unknown] with the given [interruptReason] as
  /// a [FieldValidationResult.additionalContext].
  void _setEmptyFields(String interruptReason) {
    final emptyFieldResult = FieldValidationResult.unknown(
      additionalContext: interruptReason,
    );

    validationResultBuilder.setEmptyResults(emptyFieldResult);
  }
}
