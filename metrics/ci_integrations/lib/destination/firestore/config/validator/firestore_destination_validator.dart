// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/models/firebase_auth_credentials.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_validation_target.dart';
import 'package:ci_integration/destination/firestore/config/validation_delegate/firestore_destination_validation_delegate.dart';
import 'package:ci_integration/destination/firestore/strings/firestore_strings.dart';
import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class responsible for validating the [FirestoreDestinationConfig].
class FirestoreDestinationValidator
    implements ConfigValidator<FirestoreDestinationConfig> {
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
      FirestoreDestinationValidationTarget.firebasePublicApiKey,
      apiKeyValidationResult,
    );

    if (apiKeyValidationResult.conclusion ==
        ConfigFieldValidationConclusion.invalid) {
      return _finalizeValidationResult(
        FirestoreDestinationValidationTarget.firebasePublicApiKey,
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
      FirestoreDestinationValidationTarget.firebaseUserEmail,
      authValidationResult,
    );

    validationResultBuilder.setResult(
      FirestoreDestinationValidationTarget.firebaseUserPassword,
      authValidationResult,
    );

    if (authValidationResult.conclusion ==
        ConfigFieldValidationConclusion.invalid) {
      return _finalizeValidationResult(
        FirestoreDestinationValidationTarget.firebaseUserEmail,
        FirestoreStrings.authInvalidInterruptReason,
      );
    }
    if (authValidationResult.conclusion ==
        ConfigFieldValidationConclusion.unknown) {
      return _finalizeValidationResult(
        FirestoreDestinationValidationTarget.firebaseUserEmail,
        FirestoreStrings.authValidationFailedInterruptReason,
      );
    }

    final firebaseProjectId = config.firebaseProjectId;
    final firebaseProjectIdValidationResult = await validationDelegate
        .validateFirebaseProjectId(firebaseAuthCredentials, firebaseProjectId);

    validationResultBuilder.setResult(
      FirestoreDestinationValidationTarget.firebaseProjectId,
      firebaseProjectIdValidationResult,
    );

    if (firebaseProjectIdValidationResult.conclusion ==
        ConfigFieldValidationConclusion.invalid) {
      return _finalizeValidationResult(
        FirestoreDestinationValidationTarget.firebaseProjectId,
        FirestoreStrings.firebaseProjectIdInvalidInterruptReason,
      );
    }
    if (firebaseProjectIdValidationResult.conclusion ==
        ConfigFieldValidationConclusion.unknown) {
      return _finalizeValidationResult(
        FirestoreDestinationValidationTarget.firebaseProjectId,
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
      FirestoreDestinationValidationTarget.metricsProjectId,
      metricsProjectIdValidationResult,
    );

    return validationResultBuilder.build();
  }

  /// Builds the [ValidationResult] using the [validationResultBuilder], where
  /// the [TargetValidationResult]s of empty fields contain the given [target]
  /// and [interruptReason].
  ValidationResult _finalizeValidationResult(
    ValidationTarget target,
    String interruptReason,
  ) {
    _setEmptyFields(target, interruptReason);

    return validationResultBuilder.build();
  }

  /// Sets empty results of the [validationResultBuilder] to the
  /// [TargetValidationResult] with the given [target] and [interruptReason],
  /// and [ConfigFieldValidationConclusion.unknown] as a
  /// [TargetValidationResult.conclusion].
  void _setEmptyFields(ValidationTarget target, String interruptReason) {
    final emptyFieldResult = TargetValidationResult(
      target: target,
      conclusion: ConfigFieldValidationConclusion.unknown,
      description: interruptReason,
    );

    validationResultBuilder.setEmptyResults(emptyFieldResult);
  }
}
